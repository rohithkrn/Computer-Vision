function [JL, JR] = warp(IL, IR, TL, TR)
% TODO: Implement the warping function to warp the images
%__________ Solution ______________
% 1. Warp LEFT
JL = imwarp(IL, TL);
% 2. Warp RIGHT
JR = imwarp(IR, TR);
end