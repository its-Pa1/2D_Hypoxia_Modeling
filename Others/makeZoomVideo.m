function [] = makeZoomVideo(f_p, video_ext, v_pro, imBV, imRaw, index)
% MAKEZOOMVIDEO generates a zooming video of image patches and saves it.
%   MAKEZOOMVIDEO(f_p, video_ext, v_pro, imBV, imRaw, index) generates a zooming video
%   by progressively zooming into patches of the input image and saves the video
%   file. The function uses the VideoWriter class and creates zoomed-in images
%   with rectangles and lines to enhance visualization.

% Set initial rectangle parameters
x = 0; % Initial x-coordinate of the top-left corner of the rectangle
y = 0; % Initial y-coordinate of the top-left corner of the rectangle
noXDirection = 10; % Number of patches in the x-direction
noYDirection = 10; % Number of patches in the y-direction
width = floor(size(imBV, 1) / noXDirection); % Width of the rectangle
height = floor(size(imBV, 2) / noYDirection); % Height of the rectangle

count = 1;

% Set up video file properties
videofile = VideoWriter(strcat('Videos/', 'Zoom_', f_p, video_ext), v_pro);
videofile.Quality = 100;
videofile.FrameRate = 10;
open(videofile);

% Set up figure properties
f = figure(1);
f.Position = [1 1 1500 800];
f.Visible = 'off';
colorset = [1, 2, 3];
colorset(index) = [];

% Loop through each patch to create the zooming effect
while (y + height <= size(imBV, 2))
    while (x + width <= size(imBV, 1))
        % Display lines on the original image
        imageCopy = imRaw;
        imageCopy(:, :, colorset) = 0;
        M = size(imBV, 1);
        N = size(imBV, 2);
        subplot(1, 2, 1);
        imagesc(imRaw)
        title(['Whole Tissue ', f_p], Interpreter="none");
        hold on
        for k = 1:width:M
            y1 = [1 N];
            x1 = [k k];
            plot(x1, y1, 'Color', 'g', 'LineStyle', '-', 'LineWidth', 2);
        end

        for k = 1:height:N
            y1 = [k k];
            x1 = [1 M];
            plot(x1, y1, 'Color', 'g', 'LineStyle', '-', 'LineWidth', 2);
        end
        hold off

        % Display rectangle on the original image
        hold on;
        rectangle('Position', [x, y, width, height], 'EdgeColor', 'y', 'LineWidth', 2);
        drawnow

        % Crop and display the zoomed-in patch
        imCrop = imcrop(imageCopy, [x, y, width, height]);
        subplot(1, 2, 2);
        imagesc(imCrop);
        set(gca, 'YDir', 'normal')
        title(['Patch No.', ' ', num2str(count)]);
        drawnow

        % Write frame to video file
        F = getframe(f);
        writeVideo(videofile, F);

        % Display progress message
        temp_msg = sprintf('The patch number %d is done! \n', count);
        fprintf(temp_msg);

        % Save images
        
        % saveas(f, strcat('PlotsPatches/Eps_files/Together_zoom_', f_p, 'Patch_', num2str(count)), 'epsc');
        % saveas(f, strcat('PlotsPatches/Png_files/Together_zoom_', f_p, 'Patch', num2str(count), '.png'));

        % Update coordinates and count
        x = x + width;
        count = count + 1;

        
    end
    x = 0;
    y = y + height;
end

% Close video file and figure
close(videofile);
close all
end
