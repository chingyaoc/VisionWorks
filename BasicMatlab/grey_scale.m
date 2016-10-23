%% grey scale 
% 1. for each pixel, intensity Y = 0.299 * R + 0.587 * G + 0.114 * B
%    =>  Y = [0.299 0.587 0.114] * [R G B]'
%
% 2. matrix: [a,b,c] = [a b c]
%    matrix: [a;b;c] = [a b c]'
%
% 3. zeros: create array of 0
% zeros(3) = [ 0 0 0 
%              0 0 0 
%              0 0 0 ]
% zeros(2,5) = [ 0 0 0 0 0
%                0 0 0 0 0 ]
% data type of zeros() is preset "double".
%

%% data type
% 1. data type of RGB channel is preset "uint8", range 0-255
% assume that Y = R+G+B; if R+G+B > 255, Y will be assigned the maximum 255,
% so we need to calculate in data type "double": 
%               Y = double(R) + double(G) + double(B);
%
% 2. data type and data range for imshow(I)
% uint8: 0-255:   Y = uint8((double(R) + double(G) + double(B)) / 3);
%                    => turn back to uint8
% double: 0-1     Y = ((double(R) + double(G) + double(B)) / 3) / 255;
%                    => scale 0-255 to 0-1
%

%% function
% input---source image: I
% output---grey scale image: I_grey
function I_grey = grey_scale(I);

% RGB channel
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

% get height, width, channel of image
[height, width, channel] = size(I);

% initial intensity array Y using zeros()
Y = zeros(height, width);

% weight of rgb channel
matrix = [0.299 0.587 0.114];

for h = 1 : height
    for w = 1 : width 
        Y(h, w) = matrix * [double(R(h, w)) ; double(G(h, w)) ; double(B(h, w))] / 255;
    end
end

% save intensity Y to output image
I_grey(:,:,1) = Y;
I_grey(:,:,2) = Y;
I_grey(:,:,3) = Y;



