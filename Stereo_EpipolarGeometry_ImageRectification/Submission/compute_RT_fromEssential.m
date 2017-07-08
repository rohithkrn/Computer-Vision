function [R,t] = compute_RT_fromEssential(E)

% K1 = [1692.679116 0.000 536.000000;
%       0.000 1692.679116 356.000000;
%         0.000 0.000 1.000;];
% 
% K2 = [1721.811833 0.000 536.000000;
%       0.000 1721.811833 356.000000;
%       0.000 0.000 1.000];
%   %% Choose this for sport.png
% %     load('Sport_cam.mat');
% %   [K1,R1,t1] = art(pml);
% %   [K2,R2,t2] = art(pmr);
% %   
%   %%
% E = K2'*F_RS*K1;
% % [U,D,V] = svd(E);
% % D = [1 0 0;0 1 0; 0 0 0];
% % E = U*D*V';

%% Camera Poses
W = [0 -1 0;1 0 0;0 0 1];
[U,D,V] = svd(E);
R = U*W*V';
C = U(:,3);
if det(R) < 0
    R = -R;
    C = -C;
end
R_cell{1} = R;
C_cell{1} = -R'*C;
% PM2{1} = K2*[R_cell{1} C_cell{1}];

R = U*W*V';
C = -U(:,3);
if det(R) < 0
    R = -R;
    C = -C;
end
R_cell{2} = R;
C_cell{2} = -R'*C;
% PM2{2} = K2*[R_cell{2} C_cell{2}];

R = U*W'*V';
C = U(:,3);
if det(R) < 0
    R = -R;
    C = -C;
end
R_cell{3} = R;
C_cell{3} = -R'*C;
% PM2{3} = K2*[R_cell{3} C_cell{3}];

R = U*W'*V';
C = -U(:,3);
if det(R) < 0
    R = -R;
    C = -C;
end
R_cell{4} = R;
C_cell{4} = -R'*C;
% PM2{4} = K2*[R_cell{4} C_cell{4}];

R = R_cell;
t = C_cell;
end