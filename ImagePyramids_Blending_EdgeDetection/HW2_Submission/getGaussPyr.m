function [GPyr] = getGaussPyr(im,X,numlevels)

H = X'*X;
im = im2double(im);
GPyr{1} = im;
% figure ,imshow(Pyr{1});
for i = 1:numlevels-1
imDs = GPyr{i}(1:2:end,1:2:end,:);
[s1,s2,s3] =  size(imDs);
imDs_blur = zeros(s1,s2,s3);
if s3 ~= 1
imDs_blur(1:s1,1:s2,1) = conv2(imDs(:,:,1),H,'same');
imDs_blur(1:s1,1:s2,2) = conv2(imDs(:,:,2),H,'same');
imDs_blur(1:s1,1:s2,3) = conv2(imDs(:,:,3),H,'same');
% imDs_blur = imDs_blur(1:s1,1:s2,:);
end

if s3 == 1
imDs_blur = conv2(imDs,H,'same');  
end

GPyr{i+1} = imDs_blur;

end

end