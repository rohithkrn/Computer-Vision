function [] = plotimages(IL, IR, JL, JR, pml, pmr, TL);

% Points
ml = [619,542,343;46,271,526];

% -------------------- PLOT LEFT VIEW
%figure(1)
subplot(2,2,1)
imshow(IL);
axis image
title('Left image');
hold on
plot(ml(1,:), ml(2,:),'r*','MarkerSize',15);
hold off

% Epipolar geometry
[F,epil,epir] = fund(pml,pmr);

% -------------------- PLOT RIGHT VIEW
%figure(2)
subplot(2,2,2)

imshow(IR);
axis image
title('Right image');
% plot epipolar lines
x1 =0;
x2 = size(IR,2);
hold on
for i =1:size(ml,2)
    liner = F * [ml(:,i) ; 1];
    plotseg(liner,x1,x2);
end
hold off

% warp tie points
dime = size(ml,2);
c3d = [ml;  ones(1,dime)];
h2d = TL * c3d;
c2d = h2d(1:2,:)./ [h2d(3,:)' h2d(3,:)']';
mlx = c2d(1:2,:);

% -------------------- PLOT LEFT
%figure(3)
subplot(2,2,3)
imshow(JL);
axis image
hold on
title('Rectified left image');
x2 = size(JL,2);
for i =1:size(mlx,2)
    plot (mlx(1,i), mlx(2,i),'r*','MarkerSize',15);
end
hold off

% --------------------  PLOT RIGHT
%figure(4)
subplot(2,2,4)
imshow(JR);
axis image
hold on
title('Rectified right image')
x2 = size(JR,2);
for i =1:size(mlx,2)
    X=[0    0  0; 0    0   -1; 0  1   0];
    liner = X  * [mlx(:,i) ;  1];
    plotseg(liner,x1,x2);
end

end