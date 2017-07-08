clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% synthetic data loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load triang_data.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% triangulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% triangulate all points -- method 1
points_triangulated_1 = zeros(3,N_points);
for i = 1:N_points
    points_triangulated_1(:,i) = triangulate_1(P_1, P_2, pixels_1(:,i), pixels_2(:,i));
end

% triangulate all points -- method 2
points_triangulated_2 = zeros(3,N_points);
for i = 1:N_points
    points_triangulated_2(:,i) = triangulate_2(P_1, P_2, pixels_1(:,i), pixels_2(:,i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
plot3(points_true(1,:), points_true(2,:), points_true(3,:), 'r x');
hold on;
plot3(points_triangulated_1(1,:), points_triangulated_1(2,:), points_triangulated_1(3,:), 'b o');
legend('true points','triangulated points');
grid on;
axis equal;
title('Triangulation - Method 1');
plot3(W_t_c1(1), W_t_c1(2), W_t_c1(3), 'r square');
plot3(W_t_c2(1), W_t_c2(2), W_t_c2(3), 'k square');
axis([-8,8,-2,18,-8,8]);

figure(2)
plot3(points_true(1,:), points_true(2,:), points_true(3,:), 'r x');
hold on;
plot3(points_triangulated_2(1,:), points_triangulated_2(2,:), points_triangulated_2(3,:), 'b o');
legend('true points','triangulated points');
grid on;
axis equal;
title('Triangulation - Method 2');
plot3(W_t_c1(1), W_t_c1(2), W_t_c1(3), 'r square');
plot3(W_t_c2(1), W_t_c2(2), W_t_c2(3), 'k square');
axis([-8,8,-2,18,-8,8]);
