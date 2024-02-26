function [both_CD31, both_CA9] = setup_image_files()
% SETUP_IMAGE_FILES identifies and organizes image files for CD31 and CA9 markers.
%   [both_CD31, both_CA9] = SETUP_IMAGE_FILES() scans the specified image folder
%   for files containing CD31 and CA9 markers. The function then categorizes
%   these files and creates directories to save plots.

% Specify the image folder
imFolder = '../Image_data/Training_data';

% Check if the specified folder exists
if ~isfolder(imFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', imFolder);
    uiwait(warndlg(errorMessage));
    return;
end

% List all files in the folder and warn if there are no files
imFiles = dir(fullfile(imFolder, '/**/*.tif'));
if ~exist("imFiles","var")
    errorMessage = sprintf('Error: There are no image files in the specified folder');
    fprintf(errorMessage);
    return
end

% Initialize cell arrays to store filenames containing the markers
CD31_files = {};
CA9_files = {};
All_files = {};

% Loop through the list of files and categorize them based on markers
for i = 1:length(imFiles)
    currentFile = imFiles(i);
    currentFileName = currentFile.name;

    % Check if the current item is a file and if the filename contains 'CD31'
    if (currentFile.isdir == 0 && contains(currentFileName, 'CD31'))
        CD31_files{end+1} = currentFile;
    % Check if the filename contains 'CA9'
    elseif (currentFile.isdir == 0 && contains(currentFileName, 'CA9'))
        CA9_files{end+1} = currentFile;
    % Check if the filename contains 'All'
    elseif (currentFile.isdir == 0 && contains(currentFileName, 'All'))
        All_files{end+1} = currentFile;
    end
end

% Combine CD31 and All files, and CA9 and All files
both_CD31 = [CD31_files, All_files];
both_CA9 = [CA9_files, All_files];

% Create directories to save plots
if ~isfolder('Plots')
    mkdir('Plots')
end
if ~isfolder('Plots/Eps_files')
    mkdir('Plots/Eps_files')
end
if ~isfolder('Plots/Png_files')
    mkdir('Plots/Png_files')
end

end
