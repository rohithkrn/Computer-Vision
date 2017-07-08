% clc
% clear all
function [blend_im] = blendImages(I1,I2)
% I1 = im2double(imread('apple.jpg'));
% I2 = im2double(imread('orange.jpg'));

[s1,s2,s3] = size(I1);

X = [1 4 6 4 1]/16;
numlevels = 4;

L1 = getLapPyr(I1,X,numlevels);
L2 = getLapPyr(I2,X,numlevels);

G1 = zeros(s1,s2)*1;
G1(:,1:s2/2) = 1;
G1_pyr =  getGaussPyr(G1,X,numlevels);


G2 = zeros(s1,s2);
G2(:,s2/2:end) = 1;
G2_pyr =  getGaussPyr(G2,X,numlevels);

for i =1:numlevels
   L{i} = (G1_pyr{i}.*L1{i}) + (G2_pyr{i}.*L2{i});   
end

blend_im = reconstructImage(L);
figure,imshow(blend_im);
end
% figure,subplot(3,3,1),imshow(L{1}); title 'Level 1 - Blended Laplace Pyr';
% subplot(3,3,2),imshow(L{2}); title 'Level 2 - Blended Laplace Pyr';
% subplot(3,3,3),imshow(L{3}); title 'Level 3 - Blended Laplace Pyr';
% subplot(3,3,4),imshow(L{4}); title 'Level 4 - Blended Laplace Pyr'
% subplot(3,3,5),imshow(L{5}); title 'Level 5 - Blended Laplace Pyr'
% subplot(3,3,6),imshow(L{6}); title 'Level 6 - Blended Laplace Pyr'
% 
% figure,subplot(3,3,1),imshow(G2_pyr{1}); title 'Level 1 - Gaussian Mask2 Pyr';
% subplot(3,3,2),imshow(G2_pyr{2}); title 'Level 2 - Gaussian Mask2 Pyr';
% subplot(3,3,3),imshow(G2_pyr{3}); title 'Level 3 - Gaussian Mask2 Pyr';
% subplot(3,3,4),imshow(G2_pyr{4}); title 'Level 4 - Gaussian Mask2 Pyr'
% subplot(3,3,5),imshow(G2_pyr{5}); title 'Level 5 - Gaussian Mask2 Pyr'
% subplot(3,3,6),imshow(G2_pyr{6}); title 'Level 6 - Gaussian Mask2 Pyr'
 
