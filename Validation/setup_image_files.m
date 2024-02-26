function [both_CD31, both_CA9] = setup_image_files()


%image folder
imFolder = '../Image_data/Validating_data';

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(imFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', imFolder);
    uiwait(warndlg(errorMessage));
    return;
end

% List all files in the folder
imFiles = dir(fullfile(imFolder, '/**/*.tif'));

% Warn user if it there are no files
if ~exist("imFiles","var")
    errorMessage = sprintf('Error: There is no such files');
    disp(errorMessage);
    return
end

% Initialize an empty cell array to store filenames containing the markers
CD31_files = {};
CA9_files = {};
All_files = {};


% Loop through the list of files and check for the keywords for markers
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

    % Sample_Name{end+1} = f_p;
end


% all the image files for CD31 nad CA9
both_CD31 = [CD31_files,All_files];
both_CA9 = [CA9_files,All_files];


%% Create directories to save plots

if not(isfolder('Plots'))
    mkdir('Plots')
end
if not(isfolder('Plots/Eps_files'))
    mkdir('Plots/Eps_files')
end
if not(isfolder('Plots/Png_files'))
    mkdir('Plots/Png_files')
end


end

