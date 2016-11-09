%% Clear all
clc; close all; clc;

%% Load image
img1 = imread('../data/uttower1.jpg');
img2 = imread('../data/uttower2.jpg');

%% Feature detection
I = single(rgb2gray(img1));
[f,d] = vl_sift(I) ;
pointsInImage1 = double(f(1:2,:)');
desc1 = double(d');

I = single(rgb2gray(img2));
[f,d] = vl_sift(I) ;
pointsInImage2 = double(f(1:2,:)');
desc2 = double(d');

%% Matching
M = SIFTSimpleMatcher(desc1, desc2);

%% Transformation
maxIter = 200;
maxInlierErrorPixels = .05*size(img1,1);
seedSetSize = max(3, ceil(0.1 * size(M, 1)));
minInliersForAcceptance = ceil(0.3 * size(M, 1));
H = RANSACFit(pointsInImage1, pointsInImage2, M, maxIter, seedSetSize, maxInlierErrorPixels, minInliersForAcceptance);

%% Make Panoramic image
saveFileName = 'uttower_pano.jpg';
PairStitch(img1, img2, H, saveFileName);
disp(['Panorama was saved as uttower_pano.jpg' saveFileName]);
imshow(imread(saveFileName));
