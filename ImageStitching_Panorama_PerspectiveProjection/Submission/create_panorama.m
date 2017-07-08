% function Im_pan = create_panorama(I1,I2,I3,I4,I5)
% 
% end
clc
clear variables

I1 = imread('mall0.jpg');
I2 = imread('mall1.jpg');
I3 = imread('mall2.jpg');
I4 = imread('mall3.jpg');
I5 = imread('mall4.jpg');

I1 = im2double(I1);
I2 = im2double(I2);
I3 = im2double(I3);
I4 = im2double(I4);
I5 = im2double(I5);

%%
Is1 = stitch_images(I2,I3,0);
Is2 = stitch_images(I1,Is1,0);
Is3 = stitch_images(Is2,I4,1);
Is3 = Is3(:,1:1600,:); % Selecting in the plane
Is4 = stitch_images(Is3,I5,1);
figure,imshow(Is4(1:1100,1:2000,:)); title 'panorama output'