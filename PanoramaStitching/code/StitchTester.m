%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script tests your implementation of MultiStitch.m, and you can also
% use it for generating panoramas from your own images.
% 
% In case generating a panorama takes too long or too much memory, it is
% advisable to resize images to smaller sizes.
%
% You may also want to tune matching criterion and RANSAC parameters in
% order to get better quality panorama.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear all
clc; close all; clc;

%% Load a list of images (Change file name if you want to use other images)
imgList = dir('../data/MelakwaLake*.png');

saveFileName = 'melakwalake.jpg';

%% Add path
addpath('KeypointDetect');

IMAGES = cell(1, length(imgList));
for i = 1 : length(imgList),
    IMAGES{i} = imread(['../data/' imgList(i).name]);
    %% Resize to make memory efficient
    if max(size(IMAGES{i})) > 1000 || length(imgList) > 10,
        IMAGES{i} = imresize(IMAGES{i}, 0.6);
    end
end
disp('Images loaded. Beginning feature detection...');
%% Feature detection
DESCRIPTOR = cell(1, length(imgList));
POINT_IN_IMG = cell(1, length(imgList));
for i = 1 : length(imgList),
	I = single(rgb2gray(IMAGES{i}));
	[f,d] = vl_sift(I) ;
	POINT_IN_IMG{i} = double(f(1:2,:)');
	DESCRIPTOR{i} = double(d');
end

%% Compute Transformation
TRANSFORM = cell(1, length(imgList)-1);
for i = 1 : (length(imgList)-1),
    disp(['fitting transformation from ' num2str(i) ' to ' num2str(i+1)])
    M = SIFTSimpleMatcher(DESCRIPTOR{i}, DESCRIPTOR{i+1}, 0.7);
    TRANSFORM{i} = RANSACFit(POINT_IN_IMG{i}, POINT_IN_IMG{i+1}, M);
end

%% Make Panoramic image
disp('Stitching images...')
MultipleStitch(IMAGES, TRANSFORM, saveFileName);
disp(['The completed file has been saved as ' saveFileName]);
imshow(imread(saveFileName));
