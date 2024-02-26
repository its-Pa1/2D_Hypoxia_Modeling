clear all;
clc
close all;
% figure 2, 4a, 4b, 5a, 5b

tic

%image folder
imFolder = "../../../Image_Data/Training_data";

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
both_CA9 = [CA9_files,All_files];



%%
for j = 47 %?? why not mtching

    baseFileName = both_CD31{j}.name;
    [~, f_p] = fileparts(both_CD31{j}.name);
    fullFileName = fullfile(both_CD31{j}.folder, baseFileName);
    f_p = strcat(f_p(1:end-4),'_CD31');

    baseFileName2 = both_CA9{j}.name;
    [~, f_p2] = fileparts(both_CA9{j}.name);
    fullFileName2 = fullfile(both_CA9{j}.folder, baseFileName2);
    f_p2 = strcat(f_p2(1:end-3),'_CA9');



    imRaw = ((imread(fullFileName)));
    imBV = imRaw(:,:,1)';

    % figure 4b

    % fprintf(1, 'Now working on %s\n', fullFileName);
    % makeSeparateConnectComColoring(f_p,imBV,imRaw,1) ;


    % figure 4a
    % fprintf(1, 'Now working on %s\n', fullFileName);
    % makeSeparateImage_RW_NoAx(f_p,imBV,imRaw,1) ; % 1 for red color


    % figure 5a 5b and figure 2
    fprintf(1, 'Now working on %s\n', fullFileName);
    makeSeparateImage_RW(f_p,imBV,imRaw,1) ; % 1 for red color

end
toc
