% Clear workspace, command window, and close all figures
clear all;
clc;
close all;
addpath('../');

% Start timer
tic;

% Set up paths for image files (CD31 and CA9)
[both_CD31, both_CA9] = setup_image_files();

% Check for video file format support (MP4 or AVI)
profiles = VideoWriter.getProfiles();
check_mp4_support = find(ismember({profiles.Name}, 'MPEG-4'));

if isempty(check_mp4_support)
    video_ext = '.avi';
    v_pro  = 'Motion JPEG AVI';
else
    video_ext = '.mp4';
    v_pro = 'MPEG-4';
end

% Create directories to save plots
if ~isfolder('PlotsPatches')
    mkdir('PlotsPatches');
end

if ~isfolder('PlotsPatches/Eps_files')
    mkdir('PlotsPatches/Eps_files');
end

if ~isfolder('PlotsPatches/Png_files')
    mkdir('PlotsPatches/Png_files');
end

% Create directories to save plots
if ~isfolder('Videos')
    mkdir('Videos')
end


% Process selected samples 
for j = 1
    baseFileName = both_CD31{j}.name;
    [~, f_p] = fileparts(both_CD31{j}.name);
    fullFileName = fullfile(both_CD31{j}.folder, baseFileName);
    f_p = strcat(f_p(1:end-4), '_CD31');

    baseFileName2 = both_CA9{j}.name;
    [~, f_p2] = fileparts(both_CA9{j}.name);
    fullFileName2 = fullfile(both_CA9{j}.folder, baseFileName2);
    f_p2 = strcat(f_p2(1:end-3), '_CA9');

    % Read CD31 image and extract red channel for blood vessels
    imRaw = imread(fullFileName);
    imBV = imRaw(:, :, 1)'; % Only take red color for blood vessels

    % Generate separate videos and plots for each image category
    index = 1; % Specify the color index (r=1 g=2, b=3) for the makeZoomVideo function
    makeZoomVideo(f_p, video_ext, v_pro, imBV, imRaw, index);
end

% Display elapsed time
toc;
