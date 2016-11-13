function image = DeleteSeams(transBitMask, sizeReduction, image, operation)
% delete seams following optimal way
    i = size(transBitMask, 1);
    j = size(transBitMask, 2);

    for it = 1 : (sizeReduction(1) + sizeReduction(2))

        energy = energyRGB(image);
        if (transBitMask(i, j) == 0)
            [optSeamMask, seamEnergyRaw] = findOptSeam(energy');
            image = operation(image, optSeamMask, 0);
            i = i - 1;
        else
            [optSeamMask, seamEnergyColumn] = findOptSeam(energy);
            image = operation(image, optSeamMask, 1);
            j = j - 1;
        end;

    end;
end
