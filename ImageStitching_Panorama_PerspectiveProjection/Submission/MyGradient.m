function [Gm,Gd] =  MyGradient(I)

Pk = [-1 0 1;-1 0 1;-1 0 1];

[~,~,s3] = size(I);
if s3 == 3
I = rgb2gray(I);
end
I = im2double(I);
% imshow(I);
GrX = conv2(I,Pk,'same');
GrY = conv2(I,Pk','same');

    
Gm = sqrt(GrX.^2 + GrY.^2);

Gd = atan2(GrY,GrX);
%Gd = Gd*180/pi;

% figure,subplot(1,2,1),imshow(GrX); title 'Horizontal Gradient'
% subplot(1,2,2),imshow(GrY); title 'Vertical Gradient'
% 
% figure,subplot(1,2,1),imshow(Gm); title 'Gradient Strength'
% subplot(1,2,2),imshow(Gd); title 'Gradient Orientation'
figure,subplot(1,5,1);imshow(I); title 'Original';
subplot(1,5,2);imshow(GrX); title 'Gx';
subplot(1,5,3);imshow(GrY); title 'Gy';
subplot(1,5,4);imshow(Gm); title 'Magnitude';
subplot(1,5,5);imshow(Gd); title 'Direction';


%% Smoothing

% Gf = fspecial('gaussian',[100 100]);
% im_f = conv2(I,Gf,'same');
% 
% GrX_f = conv2(im_f,Pk,'same');
% GrY_f = conv2(im_f,Pk','same');
% 
% Gm_f = sqrt(GrX_f.^2 + GrY_f.^2);
% 
% Gd_f = atan(GrY_f./GrX_f);

% figure,subplot(1,2,1),imshow(GrX_f); title 'Horizontal Gradient'
% subplot(1,2,2),imshow(GrY_f); title 'Vertical Gradient'
% 
% figure,subplot(1,2,1),imshow(Gm_f); title 'Gradient Strength'
% subplot(1,2,2),imshow(Gd_f); title 'Gradient Orientation'


end