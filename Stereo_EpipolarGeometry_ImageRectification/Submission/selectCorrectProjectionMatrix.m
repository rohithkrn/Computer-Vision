function [P,corr_ind] = selectCorrectProjectionMatrix(PM2,P1_tri,P2_tri)
%% PM2 = k[R t];
n_tri =  size(P1_tri,1);
K1 = [1692.679116 0.000 536.000000;
      0.000 1692.679116 356.000000;
        0.000 0.000 1.000];
PM1 = K1*[eye(3) zeros(3,1)];
points_triangulated_1 = zeros(3,n_tri);

for j =  1:4

for i = 1:n_tri
    points_triangulated_1(:,i) = triangulate_2(PM1, PM2{j}, P1_tri(i,:), P2_tri(i,:));
end
X_cell{j} = points_triangulated_1;

end
for i = 1:4
    R_cell{i} = PM2{i}(:,1:3);
    C_cell{i} = PM2{i}(:,4);
    
end

[C R X, corr_ind] = Cheirality(C_cell, R_cell, X_cell);

P = [R C];
end