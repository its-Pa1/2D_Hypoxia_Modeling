function [im_BV_Crop, im_Hypo_Crop] = get_density_patches(imRaw_CD31, imRaw_CA9)
% GET_DENSITY_PATCHES extracts patches from CD31 and CA9 images for analysis.
%   [im_BV_Crop, im_Hypo_Crop] = GET_DENSITY_PATCHES(imRaw_CD31, imRaw_CA9)
%   takes raw CD31 and CA9 images as input and extracts patches for further
%   analysis. The function divides the images into a specified number of
%   rectangles and crops patches, filtering out low-intensity values.

% Get image dimensions
sz1  = size(imRaw_CD31(:,:,1)',1); % Take red color for blood vessels
sz2  = size(imRaw_CD31(:,:,1)',2); % Take red color for blood vessels

% Set parameters for creating patches
noXDirection = 10; % Number of patches in the x-direction
noYDirection = 10; % Number of patches in the y-direction
width = floor(sz1/noXDirection); % Width of the rectangle
height = floor(sz2/noYDirection); % Height of the rectangle

% Pre-allocate memory for cropped images
im_BV_Crop = cell(1, noXDirection * noYDirection);
im_Hypo_Crop = cell(1, noXDirection * noYDirection);
count = 1;

% Initialize rectangle coordinates
x = 0;
y = 0;

% Loop through each patch
while(y + height <= sz2)
    while(x + width <= sz1)
        % Crop patches from CD31 and CA9 images
        temp1 = imcrop(imRaw_CD31, [x, y, width, height]);
        temp2 = imcrop(imRaw_CA9, [x, y, width, height]);

        % Take only red channel for CD31 and green channel for CA9
        temp1 = temp1(:,:,1);
        temp2 = temp2(:,:,2);

        % Thresholding to filter out low-intensity values
        temp1(temp1 <= 25) = 0;
        temp2(temp2 <= 25) = 0;

        % Store cropped images in cell arrays
        im_BV_Crop{count} = temp1;
        im_Hypo_Crop{count} = temp2;

        % Update rectangle coordinates and counter
        x = x + width;
        count = count + 1;
    end
    x = 0;
    y = y + height;
end

end
