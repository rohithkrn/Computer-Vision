function [IM] = stitch_images(IM_left,IM_right,to_left)

IM_left = im2double(IM_left);
IM_right = im2double(IM_right);
% to_left = 1;

% figure,imshow(IM_left); title 'Left Image';
% figure,imshow(IM_right); title 'Right Image';
%% SIFT

[fa, da] = vl_sift(single(rgb2gray(IM_left)));
[fb, db] = vl_sift(single(rgb2gray(IM_right)));
[matches, scores] = vl_ubcmatch(da, db) ;

[scores_val, scores_ind] = sort(scores); % ascending order

% 10 high matches
% matches_high = matches(:,scores_ind(1:20));

% m_fa = fa(:,matches_high(1,:));
% m_fb = fb(:,matches_high(2,:));

m_fa = fa(:,matches(1,:));
m_fb = fb(:,matches(2,:));

N = size(m_fa,2);
P1 = ones(N,3);
P2 = ones(N,3);

P1(:,1) = m_fa(2,:)';
P2(:,1) = m_fb(2,:)';
P1(:,2) = m_fa(1,:)';
P2(:,2) = m_fb(1,:)';

% labels = cellstr( num2str([1:size(matches,2)]'));
% figure, subplot(1,2,1);imshow(IM_left);title 'Matches'; hold on;
% plot(m_fa(1,:),m_fa(2,:),'c.');
% text(m_fa(1,:),m_fa(2,:), labels)
% 
% subplot(1,2,2);imshow(IM_right);title 'Matches'; hold on;
% plot(m_fb(1,:),m_fb(2,:),'r.');
% text(m_fb(1,:),m_fb(2,:), labels)


%%
H = compute_homography_RANSAC(P2,P1);
[sl1,sl2,~]=size(IM_left);
[sr1,sr2,~]=size(IM_right);
%Ir = zeros(size(IM_left));
plrc = zeros(sl1,sl2); plrr =zeros(sl1,sl2);
prlc = zeros(sr1,sr2); prlr =zeros(sr1,sr2);

plane_size = 10000;
plane0 = zeros(plane_size,plane_size,3);
plane1 = zeros(plane_size,plane_size,3);

if to_left == 1
plane0(1:sl1,1:sl2,1:3) =  IM_left;
% figure,imshow(plane0);
elseif to_left == 0
plane0(1:sr1,plane_size-sr2+1:end,1:3) =  IM_right;
% figure,imshow(plane0);
end
%% Mapping
if to_left == 1
    for i = 1 : sl1
    for j = 1 : sl2
    p1 = [i;j;1];
    
    p2rl = H*p1;
    p2rl = (p2rl/p2rl(3));

    prlr(i,j) = p2rl(1);
    prlc(i,j) = p2rl(2); 

    end
    end
elseif to_left == 0
    for i = 1 : sr1
    for j = 1 : sr2
    p1 = [i;j;1];
    
    p2lr = H\p1;
    p2lr = (p2lr/p2lr(3));
    
    plrr(i,j) = p2lr(1);
    plrc(i,j) = p2lr(2);
   
    end
    end
end
%% Transformed Image Boundaries
   if to_left == 1
    topRow = round(min([prlr(1,1),prlr(1,end),prlr(end,1),prlr(end,end)]));
    BottomRow = round(max([prlr(1,1),prlr(1,end),prlr(end,1),prlr(end,end)]));
    LeftCol = round(min([prlc(1,1),prlc(1,end),prlc(end,1),prlc(end,end)]));    
    RightCol = round(max([prlc(1,1),prlc(1,end),prlc(end,1),prlc(end,end)]));
   elseif to_left == 0
    topRow = round(min([plrr(1,1),plrr(1,end),plrr(end,1),plrr(end,end)]));
    BottomRow = round(max([plrr(1,1),plrr(1,end),plrr(end,1),plrr(end,end)]));  
    LeftCol = round(min([plrc(1,1),plrc(1,end),plrc(end,1),plrc(end,end)]));
    RightCol = round(max([plrc(1,1),plrc(1,end),plrc(end,1),plrc(end,end)]));
   end
   
%    LeftCol
%    RightCol
   
%% Pixel Mapping

for i = topRow : BottomRow
    for j = LeftCol:RightCol
	if i>0 
    p1 = [i;j;1];
   
    if to_left == 1
        p_tr = H\p1;
        p_tr = (p_tr/p_tr(3));
        if p_tr(1) > 0 && p_tr(1) <= sr1 && p_tr(2) > 0 && p_tr(2) <= sr2
        % Interpolation
        pv = myInterpolation(IM_right,p_tr);
        plane0(i,j,:) = pv;
        plane1(i,j,:) = pv;
        end
    elseif to_left == 0
        p_tr = H*p1;
        p_tr = (p_tr/p_tr(3));
        if p_tr(1) > 0 && p_tr(1) <= sl1 && p_tr(2) > 0 && p_tr(2) <= sl2
        % Interpolation
        pv = myInterpolation(IM_left,p_tr);
        plane0(i,plane_size-sr2+j,:) = pv;
%         plane1(i,j,:) = pv;
        end
    end
    end
    end
end
if to_left == 1
    IM = plane0(1:max(sl1,BottomRow),1:max(sl2,RightCol),1:3);
elseif to_left == 0
    IM = plane0(1:max(sr1,BottomRow),min(plane_size-sr2,plane_size-sr2+LeftCol):end,1:3);
end
% figure,imshow(plane1);
% figure,imshow(plane0);
% figure,imshow(IM);title 'Stitched Image';
end

