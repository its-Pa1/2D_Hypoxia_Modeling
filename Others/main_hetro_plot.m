%%
clear all;
clc
close all;
% figure 5c

tic

% Define the folder to search for files
%image folder
imFolder = '../../../Image_Data/Training_data';

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(imFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', imFolder);
    uiwait(warndlg(errorMessage));
    return;
end

% List all files in the folder
imFiles = dir(fullfile(imFolder, '/**/*.tif'));

if ~exist("imFiles","var")
    errorMessage = sprintf('Error: There is no such files');
    disp(errorMessage);
    return
end

% Initialize an empty cell array to store filenames containing 'temp'
CD31_files = {};
CA9_files = {};
All_files = {};

% Loop through the list of files and check for the keyword 'temp'
for i = 1:length(imFiles)
    currentFile = imFiles(i);
    currentFileName = currentFile.name;
    currentFilePath = fullfile(currentFile.folder, currentFile.name);



    % Check if the current item is a file and if the filename contains 'CD31'
    if (currentFile.isdir == 0 && contains(currentFileName, 'CD31'))
        CD31_files{end+1} = imFiles(i);
    elseif (currentFile.isdir == 0 && contains(currentFileName, 'CA9'))
        CA9_files{end+1} = imFiles(i);
    elseif (currentFile.isdir == 0 && contains(currentFileName, 'All'))
        All_files{end+1} = imFiles(i);
    end


end

both_CD31 = [CD31_files,All_files];
% total_CD31 = length(CD31_files) + length(All_files);


%%

if not(isfolder('Plots/Plots_I_W'))
    mkdir('Plots/Plots_I_W')
end
if not(isfolder('Plots/Plots_I_W/Eps_files'))
    mkdir('Plots/Plots_I_W/Eps_files')
end
if not(isfolder('Plots/Plots_I_W/Png_files'))
    mkdir('Plots/Plots_I_W/Png_files')
end

if not(isfolder('HetOutput'))
    mkdir('HetOutput')
end

%%
for j = 47% 1:length(both_CD31) % 12

    baseFileName = both_CD31{j}.name;
    [~, f_p] = fileparts(both_CD31{j}.name);
    fullFileName = fullfile(both_CD31{j}.folder, baseFileName);


    fprintf(1, 'Now reading %s\n', fullFileName);

    imRaw = ((imread(fullFileName)));


    imageCopy = imRaw;
    imageCopy(:,:,2:3) = 0;
    redChannel = imageCopy(:, :, 1);
    greenChannel = imageCopy(:, :, 2);
    blueChannel = imageCopy(:, :, 3);
    blackpixelsmask = redChannel < 50 & greenChannel < 50 & blueChannel < 50;

    % blackpixelsmask = redChannel < 50 & greenChannel <30 & blueChannel <30 ;

    redChannel(blackpixelsmask) = 255;
    greenChannel(blackpixelsmask) = 255;
    blueChannel(blackpixelsmask) = 255;
    rgbImage2 = cat(3, redChannel, greenChannel, blueChannel);


    %%
    imBV = imRaw(:,:,1)'; % only take red color for blood vessels
    % imBV(imBV<=25) = 0;


    % Set initial rectangle parameters
    x = 0; % Initial x-coordinate of the top-left corner of the rectangle
    y = 0; % Initial y-coordinate of the top-left corner of the rectangle
    noXDirection = 10;
    noYDirection = 10;
    width = floor(size(imBV,1)/noXDirection); % Width of the rectangle
    height = floor(size(imBV,2)/noYDirection); % Height of the rectangle

    numFrames = 100; % Number of frames
    stepSize = floor(width/10); % Number of pixels to move the rectangle horizontally in each frame


    imCrop = cell(1,noXDirection*noYDirection); % pre-allocate memory
    hetFullImage = zeros(2,noXDirection*noYDirection);
    hetPlotValues = zeros(size(imBV,2), size(imBV,1));
    count = 1;



    M = size(imBV,1);
    N = size(imBV,2);

    f = figure(1);
    f.Visible = 'off';
    imagesc(rgbImage2)
    set(gca,'YDir','normal')
    set(gca,'FontSize', 12);
    title(['Whole Tissue ',f_p], Interpreter="none", FontWeight="bold");
    ax = gca;
    ax.XAxis.Exponent = 4;
    ax.YAxis.Exponent = 4;




    hold on
    for k = 1:width:M
        y1 = [1 N];
        x1 = [k k];
        p = plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 2);
    end

    for k = 1:height:N
        y1 = [k k];
        x1 = [1 M];
        p = plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 2);
    end

    hold off
    saveas(f,strcat('Plots/Plots_I_W/Eps_files/LinesOnImage_', f_p),'epsc');
    saveas(f,strcat('Plots/Plots_I_W/Png_files/LinesOnImage_',f_p, '.png'));
    f = figure(2);
    f.Visible = 'off';
    %% the moving window

    % for frame = 1:numFrames
    while(y+height<=size(imBV,2))
        while(x+width<=size(imBV,1))

            % lines first-----------
            imageCopy = rgbImage2;
            M = size(imBV,1);
            N = size(imBV,2);
            imagesc(imageCopy)
            hold on
            for k = 1:width:M
                y1 = [1 N];
                x1 = [k k];
                p = plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 2);
                % plot(x1,y1,'Color','k','LineStyle',':');
            end

            for k = 1:height:N
                y1 = [k k];
                x1 = [1 M];
                p = plot(x1,y1,'Color','c','LineStyle','-', 'LineWidth', 2);
                % plot(x1,y1,'Color','k','LineStyle',':');
            end

            hold off



            % now rectangle ------------------
            hold on;

            rectangle('Position', [x, y, width, height], 'EdgeColor', 'k', 'LineWidth', 2); % Draw the rectangle


            hold off; % Turn off the "hold on" mode



            imCrop{count} = imcrop(imRaw,[x, y, width, height]);

            [hetFullImage(1,count),hetFullImage(2,count)] = compute_heterogeneity(imCrop{count});


            temp_msg = sprintf('The patch number %d is done!', count);
            disp(temp_msg);


            top_left_x = x + 1;
            top_left_y = y + 1;
            bottom_right_x = x + 1 + width;
            bottom_right_y = y + 1 + height;

            % Assign the het values
            hetPlotValues(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = hetFullImage(2,count);
            x = x + width;

            saveas(f, strcat('Plots/Plots_I_W/Eps_files/Together_zoom_', f_p, 'Patch_', num2str(count)), 'epsc');
            saveas(f, strcat('Plots/Plots_I_W/Png_files/Together_zoom_', f_p, 'Patch', num2str(count), '.png'));

            count = count + 1;
        end
        x = 0;
        y = y + height;
    end

    % hetFullImage(2,:) = hetFullImage(2,:)/(max(hetFullImage(2,:)));

    % hetPlotValues = hetPlotValues/(max(hetPlotValues(:)));


    f = figure(2);
    f.Visible = 'off';
    imagesc(hetPlotValues);
    colormap(flipud(hot))
    colorbar
    set(gca,'YDir','normal')
    set(gca,'FontSize',12,FontWeight = "bold");
    ax = gca;
    ax.XAxis.Exponent = 4;
    ax.YAxis.Exponent = 4;
    saveas(f,strcat('Plots/Plots_I_W/Eps_files/HetroPlot_', f_p),'epsc');
    saveas(f,strcat('Plots/Plots_I_W/Png_files/HetroPlot_',f_p, '.png'));


    savingFileName =  strcat('HetOutput/',f_p,'_Hetro.mat');
    save(savingFileName, 'hetFullImage');

    close all
end

toc
