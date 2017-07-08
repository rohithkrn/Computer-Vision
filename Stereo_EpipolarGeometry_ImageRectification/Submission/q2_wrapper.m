%% F = compute_fundamental_Robust(P1,P2,n,thresh)
%% 
clc
clear all
% 
IM_left = imread('00000015.JPG');
IM_right = imread('00000017.JPG');
% IM_left = imread('Sport0.png');
% IM_right = imread('Sport1.png');
% 

[fa, da] = vl_sift(single(rgb2gray(IM_left)));
[fb, db] = vl_sift(single(rgb2gray(IM_right)));
[matches, scores] = vl_ubcmatch(da, db) ;

[scores_val, scores_ind] = sort(scores); % ascending order

% 8 high matches
% matches_high = matches(:,scores_ind(1:35));
% m_fa = fa(:,matches_high(1,:));
% m_fb = fb(:,matches_high(2,:));

m_fa = fa(:,matches(1,:));
m_fb = fb(:,matches(2,:));
% 
N = size(m_fa,2);
P1 = ones(N,3);
P2 = ones(N,3);

P1(:,1) = m_fa(2,:)';
P2(:,1) = m_fb(2,:)';
P1(:,2) = m_fa(1,:)';
P2(:,2) = m_fb(1,:)';

% load('home_F_RS.mat');
%% 
thresh = 0.001;
[F_RS] = compute_fundamental_Robust(P1,P2,thresh)
%%
% labels = cellstr( num2str([1:NoOfInliers]'));
% figure, subplot(1,2,1);imshow(IM_left);title 'Matches'; hold on;
% plot(m_fa(1,MatchIndices),m_fa(2,MatchIndices),'c.');
% text(m_fa(1,MatchIndices),m_fa(2,MatchIndices), labels);
% labels = cellstr( num2str([1:NoOfInliers]'));
% 
% subplot(1,2,2);imshow(IM_right);title 'Matches'; hold on;
% plot(m_fb(1,MatchIndices),m_fb(2,MatchIndices),'r.');
% text(m_fb(1,MatchIndices),m_fb(2,MatchIndices), labels);

labels = cellstr( num2str([1:size(m_fa,2)]'));
figure, subplot(1,2,1);imshow(IM_left);title 'Matches'; hold on;
plot(m_fa(1,:),m_fa(2,:),'c.');
text(m_fa(1,:),m_fa(2,:), labels, 'FontSize', 15)

subplot(1,2,2);imshow(IM_right);title 'Matches'; hold on;
plot(m_fb(1,:),m_fb(2,:),'r.');
text(m_fb(1,:),m_fb(2,:), labels,'FontSize', 15)

%% show the images
% 
IM_left = imread('00000015.JPG');
IM_right = imread('00000017.JPG');

% IM_left = imread('Sport0.png');
% IM_right = imread('Sport1.png');


[row,col,~]=size(IM_left);

n=col;

rh = figure; imshow(IM_right);
lh = figure; imshow(IM_left);

disp('click on multiple points. Dbl click to finish');
figure(lh);

[x1s,y1s] = getpts;
hold on
plot(x1s, y1s, 'r*','MarkerSize',20);
   

% plot the epipolar line for each point
for i=1:length(x1s),
   x1 = x1s(i);
   y1 = y1s(i);
   
   figure(rh); %% all drawing is on the right image
   hold on
  % plot(x1, y1, 'gd'); %%green diamonds show where you clicked in the left image.
   
   %%left point is the clicked one
   l = [x1; y1; 1];
   %%map using the fundamental matrix
 
   
   
   % TODO: compute the epipolar line
    e_1 = l'*F_RS;
%     e_1=F'*l;
   
   % solve for the y coordinate of the point with x = 1 on the line e_l
   p1x = 1;
   p1y = -(e_1(1)+e_1(3))/e_1(2);
   
   
   % solve for the y coordinate of the point with x = n on the line e_l
   
   p2x = n;
   p2y = -(n*e_1(1)+e_1(3))/(e_1(2));
   
   % draw the line and the two points
   figure(rh); hold on;
   plot([p1x p2x], [p1y, p2y], 'LineWidth', 2);
   plot(p1x, p1y, 'yx');
   plot(p2x, p2y, 'kx');
end;

