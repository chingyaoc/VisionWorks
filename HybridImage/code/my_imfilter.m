function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% size retrieval
[img_row, img_col, C] = size(image);    % Image Size
[f_row, f_col] = size(filter);              % Filter Size

% filter's W & L must be odds
assert(mod(f_row, 2)==1 && mod(f_col, 2)==1, 'The input filter must have odd width and height');

% do zero-padding
image_pad = padarray(image, [floor(f_row/2), floor(f_col/2)], 0);  

% start filtering
output = zeros(size(image));  
for i=1:img_row
  for j=1:img_col
    for k=1:C
      output(i, j, k) = sum(dot(filter, image_pad(i:i+f_row-1, j:j+f_col-1, k)));
    end
  end
end





