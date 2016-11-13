function imageReduced = reduceImageByMask( image, seamMask, isVertical )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removes pixels by input mask
% Removes vertical line if isVertical == 1, otherwise horizontal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (isVertical)
        imageReduced = reduceImageByMaskVertical(image, seamMask);
    else
        imageReduced = reduceImageByMaskHorizontal(image, seamMask');
    end;
end

function imageReduced = reduceImageByMaskVertical(image, seamMask)
    % Note that the type of the mask is logical and you 
    % can make use of this.
    
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    sz = size(image);
    imageReduced = zeros(sz(1),sz(2)-1,sz(3));
    for c = 1:sz(3)
        for h = 1:sz(1)
            [a,b] = min(seamMask(h,:));
            imageReduced(h,:,c) = [image(h,1:b-1,c), image(h,b+1:end,c)];
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end

function imageReduced = reduceImageByMaskHorizontal(image, seamMask)
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    image = image';
    sz = size(image);
    imageReduced = zeros(sz(1),sz(2)-1,sz(3));
    for c = 1:sz(3)
        for h = 1:sz(1)
            [a,b] = min(seamMask(h,:));
            imageReduced(h,:,c) = [image(h,1:b-1,c), image(h,b+1:end,c)];
        end
    end
    imageReduced = imageReduced';
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end