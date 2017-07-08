function im_recon = reconstructImage(LPyr)

X = [1 4 6 4 1]/16;
H = X'*X;
H_lap = 4*H;
numlevels = size(LPyr,2);
im_Lap = LPyr{1,numlevels};
%imshow(im_Lap);
for i = size(LPyr,2)-1:-1:1
   [s1,s2,s3] =  size(LPyr{i});
   im_Lap_up = zeros(s1,s2,s3); 
   im_Lap_up(1:2:end,1:2:end,:) = im_Lap;
   im_Lap_up_blur = zeros(s1,s2,s3);
   
   if s3 == 1
   im_Lap_up_blur = conv2(im_Lap_up,H_lap,'same');
   end

   if s3 == 3
   im_Lap_up_blur(:,:,1) = conv2(im_Lap_up(:,:,1),H_lap,'same');
   im_Lap_up_blur(:,:,2) = conv2(im_Lap_up(:,:,2),H_lap,'same');
   im_Lap_up_blur(:,:,3) = conv2(im_Lap_up(:,:,3),H_lap,'same');
   end
   
   im_Lap = im_Lap_up_blur + LPyr{i};
%    figure,imshow(im_Lap);
   
end
    im_recon = im_Lap;
end