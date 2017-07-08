%% Stereo Rectification
%%
close all; 
clear; clc;
% read camera matrices pml and pmr
load(['Sport_cam']);

[IM_left] = imread(['Sport0.png'],'png');
IM_left = im2double(rgb2gray(IM_left));
[IM_right] = imread(['Sport1.png'],'png');
IM_right = im2double(rgb2gray(IM_right));
%%
% % load('Proj_Mat2_new_house.mat');
% % load('Proj_Mat2.mat');
% % pmr = Proj_Matrix2;
% pml = [eye(3) [0;0;0]];
% % pmr = [-926.8 1.42 394.28 -825; 5.0076 -903.58 290.98 34.462; 0.0205 0.0011 0.9998 0.2248];
% pmr = [-927.15 -0.6649 393.49 -899.45; 5.40 -904.61 287.75 6.86;0.0197 -0.0024 0.9998 0.0846];
% % pmr = [1721.811833 0.000 536.000000;
% %       0.000 1721.811833 356.000000;
% %       0.000 0.000 1.000]*[-0.9996 0.0022 0.0283 0.9896; -0.0022 -1.00 0.0010 0.0294; -0.0283 -0.0010 -0.9996 0.1407];
% [IM_left] = imread('00000015.JPG');
% % IM_left = im2double(rgb2gray(IM_left));
% IM_left = (rgb2gray(IM_left));
% [IM_right] = imread('00000015.JPG');
% % IM_right = im2double(rgb2gray(IM_right));
%  IM_right = (rgb2gray(IM_right));
%%

[T_left,T_right,pmln,pmrn] = MyRectify(pml,pmr);


% warp stereo images channels,
% [JL, JR] = warp(IM_left, IM_right, T_left, T_right);
% 
% % figure, imshow(JL)
% % Plot the unrectified and rectified images
% plotimages(IM_left, IM_right, JL, JR, pml, pmr, T_left);


%% Warping
%%
to_left = 1;
[sl1,sl2]=size(IM_left);

plrc = zeros(sl1,sl2); plrr =zeros(sl1,sl2);

%% Mapping

for i = 1 : sl1
    for j = 1 : sl2
  
    p1 = [i;j;1];
    
    p2lr = T_left*p1;
    p2lr = (p2lr/p2lr(3));
    
    plrr(i,j) = p2lr(1);
    plrc(i,j) = p2lr(2);

    end
end

topRow = round(min([plrr(1,1),plrr(1,end),plrr(end,1),plrr(end,end)]));
BottomRow = round(max([plrr(1,1),plrr(1,end),plrr(end,1),plrr(end,end)]));  
LeftCol = round(min([plrc(1,1),plrc(1,end),plrc(end,1),plrc(end,end)]));
RightCol = round(max([plrc(1,1),plrc(1,end),plrc(end,1),plrc(end,end)]));

%%
height = abs(topRow - BottomRow);
width = abs(RightCol - LeftCol);
plane0 = zeros(height+1,width+1);

for i = topRow:BottomRow
    for j = LeftCol:RightCol
        p1 = [i;j;1];
        p_tr = T_left\p1;
        p_tr = (p_tr/p_tr(3));
        if p_tr(1) > 0 && p_tr(1) <= sl1 && p_tr(2) > 0 && p_tr(2) <= sl2
           pv = myInterpolation(IM_left,p_tr);
           plane0(i-topRow + 1,j-LeftCol+1) = pv;
        end
    end
end

figure, imshow(plane0);










































