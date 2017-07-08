function H = compute_homography_RANSAC(P1,P2)

N = size(P1,1);
% P1 = ones(N,3);
% P2 = ones(N,3);
% 
% P1(:,1:2) = m_fa(1:2,:)';
% P2(:,1:2) = m_fb(1:2,:)';

%% Ransac
rs.nIter = 100;
rs.thresh = 20;
rs.inlier_count = 0;
rs.inlier_ind = [];

for i =1:rs.nIter

perm = randperm(N);

P1_rand = P1(perm(1:4),:);
P2_rand = P2(perm(1:4),:);

% P2 = H*P1

H = getHomography(P1_rand,P2_rand);

P2_recon = H*P1';
P2_recon = P2_recon./P2_recon(3,:);
P2_err = (P2 - P2_recon');
P2_dist = sum(P2_err.^2,2);

P1_recon = H\P2';
P1_recon = P1_recon./P1_recon(3,:);
P1_err = P1 - P1_recon';
P1_dist = sum(P1_err.^2,2);

dist = P1_dist + P2_dist;

inlier_ind = find(dist < rs.thresh);

if size(inlier_ind,1) > rs.inlier_count
   rs.inlier_ind = inlier_ind;
   rs.inlier_count = size(inlier_ind,1);
end
end

P1_inlier = P1(rs.inlier_ind,:);
P2_inlier = P2(rs.inlier_ind,:);
disp('inliers:');
disp(rs.inlier_count);
H = compute_homography_LS(P1_inlier,P2_inlier);
end