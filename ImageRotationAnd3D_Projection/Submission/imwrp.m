clc

theta = pi/3;
p0=[250+127,250+127]';

plane1 = zeros(600);
plane2 = zeros(600);
I = im2double(imread('cameraman.tif'));
[a,b] = size(I);

start_pt = [250,250]';
plane1(start_pt(1):start_pt(1)+a-1,start_pt(2):start_pt(2)+b-1)= I;

R = [cos(theta) -sin(theta);
   sin(theta) cos(theta)];
T = -R*p0+p0;
plane2 = imwarp(plane1,...,
   affine2d([cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; T(1) T(2) 1]));
subplot(1,2,1),imshow(plane1); title 'original'
subplot(1,2,2),imshow(plane2); title 'Rotated by imwrap'
