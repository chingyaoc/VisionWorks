close;
clear;
clc;

%% read image
filename = 'image.jpg';
I = imread(filename);
figure('name', 'source image');
imshow(I);

%% ----- pre-lab ----- %%
% output = function(input1, input2, ...);
% grey_scale function
I2 = grey_scale(I);

%% ----- homework lab ----- %%
% flip function
I3 = flip(I,0);

% rotation function
I4 = rotation(I, pi/3);

%% show image
figure('name', 'grey scale image'),
imshow(I2);
% 
figure('name', 'flip image'),
imshow(I3);
% 
figure('name', 'rotate image'),
imshow(I4);

%% write image
% save image for your report
% filename = 'test_g.jpg'; imwrite(I2, filename);
% filename = 'test_hf.jpg'; imwrite(I3, filename);
% filename = 'test_r.jpg'; imwrite(I4, filename);

