% (C) Copyright Kirill Lykov 2013.
%
% Distributed under the FreeBSD Software License (See accompanying file license.txt)

function image = seamCarving(image, newSize)
% apply seam carving to the image
% following paper by Avidan and Shamir '07
    sizeReductionX = size(image, 1) - newSize(1);
    sizeReductionY = size(image, 2) - newSize(2);
    
    mmax = @(left, right) max([left right]);
    
    image = seamCarvingReduce([mmax(0, sizeReductionX), mmax(0, sizeReductionY)], image);
end

function image = seamCarvingReduce(sizeReduction, image)
    if (sizeReduction == 0)
        return;
    end;
    [T, transBitMask] = findTransportMatrix(sizeReduction, image);
    image = DeleteSeams(transBitMask, sizeReduction, image, @reduceImageByMask);
end











