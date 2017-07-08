% Rectification with calibration data

% This function reads a (stereo) pair of images and respective camera matrices
% (PPMs) from files and rectify them. It outputs on files the two rectified
% images in PNG format. It reads  RGB images in PNG format.
close all; 
clear; clc;
% read camera matrices pml and pmr
load(['Sport_cam']);

% Load the image pairs
[IL] = imread(['Sport0.png'],'png');
IL = rgb2gray(IL);
[IR] = imread(['Sport1.png'],'png');
IR = rgb2gray(IR);

% Compute the rectification matrices
[TL,TR,pmln,pmrn] = rectify(pml,pmr);

% warp stereo images channels,
[JL, JR] = warp(IL, IR, TL, TR);

% Plot the unrectified and rectified images
plotimages(IL, IR, JL, JR, pml, pmr, TL);

