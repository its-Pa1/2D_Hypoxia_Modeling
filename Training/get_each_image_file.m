function [imBV, imHypo, sample_name] = get_each_image_file(both_CD31, both_CA9, j)
% GET_EACH_IMAGE_FILE reads and loads CD31 and CA9 images for a specific index.
%   [imBV, imHypo, sample_name] = GET_EACH_IMAGE_FILE(both_CD31, both_CA9, j)
%   reads and returns CD31 and CA9 images along with the sample name for the
%   specified index 'j' from the input file paths.

% Extract file names and paths
baseFileName_CD31 = both_CD31{j}.name;
baseFileName_CA9 = both_CA9{j}.name;

% Generate full file paths
fullFileName_CD31 = fullfile(both_CD31{j}.folder, baseFileName_CD31);
fullFileName_CA9 = fullfile(both_CA9{j}.folder, baseFileName_CA9);

% Read and load CD31 and CA9 images
imBV = imread(fullFileName_CD31);
imHypo = imread(fullFileName_CA9);

% Extract sample name from CD31 file name
[~, sample_name, ~] = fileparts(baseFileName_CD31);

end
