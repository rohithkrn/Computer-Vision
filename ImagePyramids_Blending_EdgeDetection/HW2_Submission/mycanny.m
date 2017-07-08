function [edge_final] = mycanny(I)
%%
% I = imread('cameraman.tif');

[s1,s2,s3] = size(I);
if s3 == 3
I = rgb2gray(I);
end

I = im2double(I);
    
%% Smoothing and Gradient
Gf = fspecial('gaussian',[5 5]);
im_f = conv2(I,Gf,'same');

%Pk = [-1 0 1;-1 0 1;-1 0 1];

%[Gm,Gd] =  gradient(im_f);
Pk = [-1 0 1;-1 0 1;-1 0 1];

[~,~,s3] = size(I);
if s3 == 3
I = rgb2gray(I);
end
I = im2double(I);
% imshow(I);
GrX = conv2(im_f,Pk,'same');
GrY = conv2(im_f,Pk','same');

    
Gm = sqrt(GrX.^2 + GrY.^2);

Gd = atan2(GrY,GrX);

%% Non-maxima suppression

for i=1:s1
    for j=1:s2
        if (Gd(i,j)<0) 
            Gd(i,j)=360+Gd(i,j);
        end;
    end;
end;

Gd2=zeros(s1,s2);

for i = 1  : s1
    for j = 1 : s2
        if ((Gd(i, j) >= 0 ) && (Gd(i, j) < 22.5) || (Gd(i, j) >= 157.5) && (Gd(i, j) < 202.5) || (Gd(i, j) >= 337.5) && (Gd(i, j) <= 360))
            Gd2(i, j) = 0;
        elseif ((Gd(i, j) >= 22.5) && (Gd(i, j) < 67.5) || (Gd(i, j) >= 202.5) && (Gd(i, j) < 247.5))
            Gd2(i, j) = 45;
        elseif ((Gd(i, j) >= 67.5 && Gd(i, j) < 112.5) || (Gd(i, j) >= 247.5 && Gd(i, j) < 292.5))
            Gd2(i, j) = 90;
        elseif ((Gd(i, j) >= 112.5 && Gd(i, j) < 157.5) || (Gd(i, j) >= 292.5 && Gd(i, j) < 337.5))
            Gd2(i, j) = 135;
        end;
    end;
end;

NonMS = zeros (s1,s2);

for i=2:s1-1
    for j=2:s2-1
        if (Gd2(i,j)==0)
            NonMS(i,j) = (Gm(i,j) == max([Gm(i,j), Gm(i,j+1), Gm(i,j-1)]));
        elseif (Gd2(i,j)==45)
            NonMS(i,j) = (Gm(i,j) == max([Gm(i,j), Gm(i+1,j-1), Gm(i-1,j+1)]));
        elseif (Gd2(i,j)==90)
            NonMS(i,j) = (Gm(i,j) == max([Gm(i,j), Gm(i+1,j), Gm(i-1,j)]));
        elseif (Gd2(i,j)==135)
            NonMS(i,j) = (Gm(i,j) == max([Gm(i,j), Gm(i+1,j+1), Gm(i-1,j-1)]));
        end;
    end;
end;

NonMS = NonMS.*Gm;
% figure, imshow(BW);title 's=nms'

%% Hysteresis Threshloding
Thresh_Low = 0.1;
Thresh_High = 0.25;
% T_Low = 0.1;
% T_High = 0.30;

Thresh_Low = Thresh_Low * max(max(NonMS));
Thresh_High = Thresh_High * max(max(NonMS));

res = zeros (s1,s2);

imL = zeros (s1,s2);
imH = zeros (s1,s2);
imV = zeros (s1,s2);

for i =1:s1
    for j = 1:s2
        if (NonMS(i, j) > Thresh_Low)
        imL(i,j) =  1;
        end
        if (NonMS(i, j) > Thresh_High)
        imH(i,j) =  1;
        end
    end
end

imL = imL - imH;
for i =2:s1-1
    for j = 2:s2-1
        if imH(i,j) > 0
        if imL(i-1,j-1) > 0
          imV(i-1,j-1) = 1;  
        end
        if imL(i-1,j) > 0
          imV(i-1,j) = 1;  
        end
        if imL(i-1,j+1) > 0
          imV(i-1,j+1) = 1;  
        end
        if imL(i,j-1) > 0
          imV(i,j-1) = 1;  
        end
        if imL(i,j+1) > 0
          imV(i,j+1) = 1;  
        end
        if imL(i+1,j-1) > 0
          imV(i+1,j-1) = 1;  
        end
        if imL(i+1,j) > 0
          imV(i+1,j) = 1;  
        end
        if imL(i+1,j+1) > 0
          imV(i+1,j+1) = 1;  
        end
        end
    end
end

imH = imH + imV;
res = imH;
edge_final = uint8(res.*255);
%Show final edge detection result
% figure, subplot(1,2,1);imshow(edge_final);title 'mycanny';
% subplot(1,2,2);imshow(edge(I));title 'canny matlab';

figure,subplot(2,4,1);imshow(I);title 'Original';
subplot(2,4,2);imshow(im_f);title 'Filtered Image';
subplot(2,4,3);imshow(GrX);title 'X-direction Image';
subplot(2,4,4);imshow(GrY);title 'Y-directio Image';
subplot(2,4,5);imshow(Gm);title 'Magnitude';
subplot(2,4,6);imshow(NonMS);title 'Non-max Suppression';
subplot(2,4,7);imshow(edge_final );title 'mycanny edge';
subplot(2,4,8);imshow(edge(I));title 'matlab edge';

end