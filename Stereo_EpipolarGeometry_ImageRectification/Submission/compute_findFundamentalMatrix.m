function [F_new] = compute_findFundamentalMatrix(P1,P2)
% IM_left = imread('00000015.JPG');
% IM_right = imread('00000017.JPG');
% IM_left = imread('Sport0.png');
% IM_right = imread('Sport1.png');
% 
% 
% [fa, da] = vl_sift(single(rgb2gray(IM_left)));
% [fb, db] = vl_sift(single(rgb2gray(IM_right)));
% [matches, scores] = vl_ubcmatch(da, db) ;
% 
% [scores_val, scores_ind] = sort(scores); % ascending order
% 
% % 8 high matches
% matches_high = matches(:,scores_ind(1:8));
% 
% m_fa = fa(:,matches_high(1,:));
% m_fb = fb(:,matches_high(2,:));
% 
% % m_fa = fa(:,matches(1,:));
% % m_fb = fb(:,matches(2,:));
% 
% % labels = cellstr( num2str([1:size(m_fa,2)]'));
% % figure, subplot(1,2,1);imshow(IM_left);title 'Matches'; hold on;
% % plot(m_fa(1,:),m_fa(2,:),'c.');
% % text(m_fa(1,:),m_fa(2,:), labels)
% % 
% % subplot(1,2,2);imshow(IM_right);title 'Matches'; hold on;
% % plot(m_fb(1,:),m_fb(2,:),'r.');
% % text(m_fb(1,:),m_fb(2,:), labels)
% N = size(m_fa,2);
% P1 = ones(N,3);
% P2 = ones(N,3);
% 
% P1(:,1) = m_fa(2,:)';
% P2(:,1) = m_fb(2,:)';
% P1(:,2) = m_fa(1,:)';
% P2(:,2) = m_fb(1,:)';

%% compute_findFundamentalMatrix(P1,P2)
%% Normalize the points
[s1,~,~] = size(P1);

P1_n = ones(s1,3);
P2_n = ones(s1,3);

m1  = mean(P1(:,1:2));
m2  = mean(P2(:,1:2));

P1_norm = (sum(sum(abs(P1(:,1:2) - repmat(m1,s1,1)).^2,2)))/s1;
P2_norm = (sum(sum(abs(P2(:,1:2) - repmat(m2,s1,1)).^2,2)))/s1;

% P1_norm_rep = repmat(P1_norm,1,2);
% P2_norm_rep = repmat(P2_norm,1,2);

sc1 = sqrt(2)/sqrt(P1_norm);
sc2 = sqrt(2)/sqrt(P2_norm);

T_left = [sc1,0,0;0,sc1,0;0,0,1]*[1,0,-m1(1);0,1,-m1(2);0,0,1];
T_right = [sc2,0,0;0,sc2,0;0,0,1]*[1,0,-m2(1);0,1,-m2(2);0,0,1];

for j = 1:s1
   P1_n(j,:) = (T_left*P1(j,:)')'; 
   P2_n(j,:) = (T_right*P2(j,:)')';
end
% P1_n = 1.414*P1(:,1:2)./P1_norm_rep;
% P2_n = 1.414*P2(:,1:2)./P2_norm_rep;


%% Consruct A  and compute F  
A = ones(s1,9);
for i = 1:s1
    A(i,:) = [P1_n(i,1)*P2_n(i,1), P2_n(i,1)*P1_n(i,2), P2_n(i,1), P2_n(i,2)*P1_n(i,1), P2_n(i,2)*P1_n(i,2), P2_n(i,2), P1_n(i,1), P1_n(i,2), 1];
end


[U, S, V] = svd(A);
f = V(:,end);
F = reshape(f, [3 3])';

%% Enforicing rank constraint

[U,S,V] = svd(F);
S(end,end) = 0;
F_new = U*S*V';

%% Denormalize F

F_temp = F_new;
F_new = T_right'*F_temp*T_left;
% F_new = F_new./F_new(3,3);
end
