% input1---source image: I
% input2---flip direction: type (0:horizontal, 1:vertical, 2:both)
% output---flipped image: I_flip

function I_flip = flip(I, type);

% RGB channel
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

% get height, width, channel of image
[height, width, channel] = size(I);

%%  horizontal flipping
if type==0
    % initial r,g,b array for flipped image, using zeros()
    R_flip = zeros(height, width);
    G_flip = zeros(height, width);
    B_flip = zeros(height, width);
    
    % assign pixels from R,G,B to R_flip, G_flip, B_flip
   for h = 1 : height
       for w = 1 : width 
            R_flip(h, w) = R(h, width - w + 1);
            G_flip(h, w) = G(h, width - w + 1);
            B_flip(h, w) = B(h, width - w + 1);
       end
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:,:,1) = R_flip;
    I_flip(:,:,2) = G_flip;
    I_flip(:,:,3) = B_flip;
    I_flip = uint8(I_flip);
end

%% vertical flipping
if type==1
    % initial r,g,b array for flipped image, using zeros()
    R_flip = zeros(height, width);
    G_flip = zeros(height, width);
    B_flip = zeros(height, width);
    
    % assign pixels from R,G,B to R_flip, G_flip, B_flip
   for h = 1 : height
       for w = 1 : width 
            R_flip(h, w) = R(height - h + 1, w);
            G_flip(h, w) = G(height - h + 1, w);
            B_flip(h, w) = B(height - h + 1, w);
       end
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:,:,1) = R_flip;
    I_flip(:,:,2) = G_flip;
    I_flip(:,:,3) = B_flip;
    I_flip = uint8(I_flip);
end
%%  horizontal + vertical flipping
if type==2
    % initial r,g,b array for flipped image, using zeros()
    R_flip = zeros(height, width);
    G_flip = zeros(height, width);
    B_flip = zeros(height, width);
    
    % assign pixels from R,G,B to R_flip, G_flip, B_flip
   for h = 1 : height
       for w = 1 : width 
            R_flip(h, w) = R(height - h + 1, width - w + 1);
            G_flip(h, w) = G(height - h + 1, width - w + 1);
            B_flip(h, w) = B(height - h + 1, width - w + 1);
       end
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:,:,1) = R_flip;
    I_flip(:,:,2) = G_flip;
    I_flip(:,:,3) = B_flip;
    I_flip = uint8(I_flip);
end