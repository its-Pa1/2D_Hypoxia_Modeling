function [imCrop] = makeCropImage(imBV,imRaw, index)


x = 0; % Initial x-coordinate of the top-left corner of the rectangle
y = 0; % Initial y-coordinate of the top-left corner of the rectangle
noXDirection = 10;
noYDirection = 10;
width = floor(size(imBV,1)/noXDirection); % Width of the rectangle
height = floor(size(imBV,2)/noYDirection); % Height of the rectangle


imCrop = cell(1,noXDirection*noYDirection); % pre-allocate memory

count = 1;

colorset = [1,2,3];
colorset(index)=[];
% for frame = 1:numFrames
while(y+height<=size(imBV,2))
    while(x+width<=size(imBV,1))

        % lines first-----------
        imageCopy = imRaw;
        imageCopy(:,:,colorset) = 0;

        imCrop{count} = imcrop(imageCopy,[x, y, width, height]);

        % temp_msg = sprintf('The patch number %d is done! \n', count);
        % fprintf(temp_msg);

        x = x + width;


        count = count + 1;

    end
    x = 0;
    y = y + height;
end

end