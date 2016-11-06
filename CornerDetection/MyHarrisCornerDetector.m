% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N


%%%
%corner : significant change in all direction for a sliding window
%%%


%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=20;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/box.jpg');
frame = rgb2gray(frame);
I = double(frame);
figure(1);
imshow(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%
% get image gradient
% [Your Code here] 
% calculate Ix
x_gradient = imfilter(I, dx, 'same');
Ix = imfilter(x_gradient, g, 'same');

% calcualte Iy
y_gradient = imfilter(I, dy, 'same');
Iy = imfilter(y_gradient, g, 'same');

%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
% calculate Ix2  
Ix2 = (Ix - mean(mean(Ix))) .^2;

% calculate Iy2
Iy2 = (Iy - mean(mean(Iy))) .^2;

% calculate Ixy
Ixy = (Ix - mean(mean(Ix))) .* (Iy - mean(mean(Iy)));

%%%%%
Ix2 = imfilter(Ix2, g, 'same');
Iy2 = imfilter(Iy2, g, 'same');
Ixy = imfilter(Ixy, g, 'same');
%% visualize Ixy
figure(2);
imagesc(Ixy);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
M = zeros(2,2);
R = zeros(size(frame));
for i=1:xmax
    for j=1:ymax
        M = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
        R(i,j) = det(M) - alpha * (trace(M)^2);
    end
end

% calculate R
%%%%%

%% make R value range from 0 to 1000
R=(1000/max(max(R)))*R;%

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
MX = ordfilt2(R ,sze^2, ones(sze));
%%%%%

%%%%%
% find local maximum.
RBinary = (R==MX)&(R>Thrshold);
% calculate RBinary
%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
PIP=[r1,c1]; % IP , 2d location ie.(u,v)
  

%% Display
figure(3)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
return;
