function [LPyr] = getLapPyr(im,X,numlevels)

im = im2double(im);

GPyr =  getGaussPyr(im,X,numlevels);

H = X'*X;
H_lap = 4*H;

for i = 1:numlevels-1

[s1,s2,s3] =  size(GPyr{i});
GP_up = zeros(s1,s2,s3);
GP_up(1:2:end,1:2:end,:) = GPyr{i+1};

GP_up_blur = zeros(s1,s2,s3);

if s3 == 1
GP_up_blur = conv2(GP_up,H_lap,'same');
end

if s3 == 3
GP_up_blur(:,:,1) = conv2(GP_up(:,:,1),H_lap,'same');
GP_up_blur(:,:,2) = conv2(GP_up(:,:,2),H_lap,'same');
GP_up_blur(:,:,3) = conv2(GP_up(:,:,3),H_lap,'same');
end

LPyr{i} = GPyr{i} - GP_up_blur;
 
end

LPyr{i+1} = GPyr{i+1};


end