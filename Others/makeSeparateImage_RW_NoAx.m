function [] = makeSeparateImage_RW_NoAx(f_p,imBV,imRaw, index)
% This function generates separate plot for each patch shwoing blood
% vessels in red with white background and no axis
%
% Input:
% - f_p: File name or identifier.
% - imBV: Blood vessel image.
% - imRaw: Raw RGB image.
% - index: Index to exclude a color channel.
if not(isfolder('Plots/Plots_RW_NoAx'))
    mkdir('Plots/Plots_RW_NoAx')
end

if not(isfolder('Plots/Plots_RW_NoAx/Eps_files'))
    mkdir('Plots/Plots_RW_NoAx/Eps_files')
end
if not(isfolder('Plots/Plots_RW_NoAx/Png_files'))
    mkdir('Plots/Plots_RW_NoAx/Png_files')
end


% Set initial rectangle parameters
x = 0; % Initial x-coordinate of the top-left corner of the rectangle
y = 0; % Initial y-coordinate of the top-left corner of the rectangle
noXDirection = 10;
noYDirection = 10;
width = floor(size(imBV,1)/noXDirection); % Width of the rectangle
height = floor(size(imBV,2)/noYDirection); % Height of the rectangle


count = 1;


redChannel = imRaw(:, :, 1);
greenChannel = imRaw(:, :, 2);
blueChannel = imRaw(:, :, 3);
blackpixelsmask = redChannel < 50 & greenChannel < 50 & blueChannel < 50;


redChannel(blackpixelsmask) = 255;
greenChannel(blackpixelsmask) = 255;
blueChannel(blackpixelsmask) = 255;
rgbImage2 = cat(3, redChannel, greenChannel, blueChannel);

colorset = [1,2,3];
colorset(index)=[];
imageCopy = imRaw;
imageCopy(:,:,colorset) = 0;


while(y+height<=size(imBV,2))
    while(x+width<=size(imBV,1))
        f = figure(1);
        f.Visible = 'off';


        M = size(imBV,1);
        N = size(imBV,2);
        % subplot(1, 2, 1);
        % cla reset;


        imagesc(rgbImage2);
        % colormap sky
        % colorbar
        %----------------------------------------------

        set(gca,'YDir','normal')
        set(gca,'FontSize', 12);
        title(['Whole Tissue ',f_p], Interpreter="none", FontWeight="bold");
        xticks([]);
        yticks([])

        hold on
        for k = 1:width:M
            y1 = [1 N];
            x1 = [k k];
            plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 1.5);

        end

        for k = 1:height:N
            y1 = [k k];
            x1 = [1 M];
            plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 1.5);

        end


        hold off

        % now rectangle ------------------
        hold on;

        rectangle('Position', [x, y, width, height], 'EdgeColor', 'k', 'LineWidth', 1.5); % Draw the rectangle
        drawnow
        % plot(x,y,'r-');
        hold off;


        f1 = figure(2);
        %f1.Position = [1 1 1500 800];
        f1.Visible = 'off';



        imCrop = imcrop(imageCopy,[x, y, width, height]);


        %------------------- to change backgrond -------------------------
        redChannel = imCrop(:, :, 1);
        greenChannel = imCrop(:, :, 2);
        blueChannel = imCrop(:, :, 3);
        blackpixelsmask = redChannel < 50 & greenChannel < 50 & blueChannel < 50;

        % blackpixelsmask = redChannel < 50 & greenChannel <30 & blueChannel <30 ;

        redChannel(blackpixelsmask) = 255;
        greenChannel(blackpixelsmask) = 255;
        blueChannel(blackpixelsmask) = 255;
        rgbImage3 = cat(3, redChannel, greenChannel, blueChannel);
        imagesc(rgbImage3);
        set(gca,'YDir','normal');
        set(gca,'FontSize', 12);
        title(['Patch No.', ' ', num2str(count)], FontSize = 12,FontWeight="bold");
        xticks([]);
        yticks([])


        temp_msg = sprintf('The patch number %d is done! \n', count);
        fprintf(temp_msg);


        x = x + width;

        saveas(f,strcat('Plots/Plots_RW_NoAx/Eps_files/Sample_line', f_p,'Patch_',num2str(count)),'epsc');
        saveas(f,strcat('Plots/Plots_RW_NoAx/Png_files/Sample_line',f_p,'Patch', num2str(count),'.png'));

        saveas(f1,strcat('Plots/Plots_RW_NoAx/Eps_files/zoom_', f_p,'Patch_',num2str(count)),'epsc');
        saveas(f1,strcat('Plots/Plots_RW_NoAx/Png_files/zoom_',f_p,'Patch', num2str(count),'.png'));
        count = count + 1;
    end
    x = 0;
    y = y + height;

    close all
end

close all

end