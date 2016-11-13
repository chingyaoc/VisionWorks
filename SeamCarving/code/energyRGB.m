function res = energyRGB(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum up the enery for each channel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res = energyGrey(I(:, :, 1)) + energyGrey(I(:, :, 2)) + energyGrey(I(:, :, 3));
end

function res = energyGrey(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% returns energy of all pixelels
% e = |dI/dx| + |dI/dy|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res = abs(imfilter(I, [-1,0,1])) + abs(imfilter(I, [-1,0,1]'));
end