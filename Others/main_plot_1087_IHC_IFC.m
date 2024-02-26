clear all
clc
close all

% figure 1

fullFileName_IFC = '../../../Image_Data/TileScan 3_Pancreas_20-3-1087_Merged.tif';
imRaw_IFC = ((imread(fullFileName_IFC)));

redChannel = imRaw_IFC(:, :, 1);
greenChannel = imRaw_IFC(:, :, 2);
blueChannel = imRaw_IFC(:, :, 3);
blackpixelsmask = redChannel < 50 & greenChannel < 50 & blueChannel < 50;

% blackpixelsmask = redChannel < 50 & greenChannel <30 & blueChannel <30 ;

redChannel(blackpixelsmask) = 255;
greenChannel(blackpixelsmask) = 255;
blueChannel(blackpixelsmask) = 255;
rgbImage2 = cat(3, redChannel, greenChannel, blueChannel);

%%
if not(isfolder('Plots/Plots_Misc'))
    mkdir('Plots/Plots_Misc')
end

if not(isfolder('Plots/Plots_Misc/Eps_files'))
    mkdir('Plots/Plots_Misc/Eps_files')
end
if not(isfolder('Plots/Plots_Misc/Png_files'))
    mkdir('Plots/Plots_Misc/Png_files')
end

%%
final_image_IFC = imrotate(rgbImage2, 90);
f = figure;
imshow(final_image_IFC);
saveas(f,strcat('Plots/Plots_Misc/Eps_files/1087_IFC_all'),'epsc');
saveas(f,strcat('Plots/Plots_Misc/Png_files/1087_IFC_all', '.png'));


% set(gca, 'YDir', 'normal')


%%
fullFileName_IHC_CD31 = '../../../Image_Data/Validating_data/Pancreas_1087_CD31.tif';
fullFileName_IHC_CA9 = '../../../Image_Data/Validating_data/Pancreas_1087_CA9.tif';

CD31_raw = imread(fullFileName_IHC_CD31);
CA9_raw = imread(fullFileName_IHC_CA9);

CD31_cropped = CD31_raw(100:end,900:6500,:);

CA9_cropped = CA9_raw(100:end,700:6300,:);

%%
CD31_final = imrotate(CD31_cropped,180);
CA9_final = imrotate(CA9_cropped,180);


f = figure;
imshow(CD31_final);
saveas(f,strcat('Plots/Plots_Misc/Eps_files/1087_IHC_CD31'),'epsc');
saveas(f,strcat('Plots/Plots_Misc/Png_files/1087_IHC_CD31','.png'));


f = figure;
imshow(CA9_final);
saveas(f,strcat('Plots/Plots_Misc/Eps_files/1087_IHC_CA9'),'epsc');
saveas(f,strcat('Plots/Plots_Misc/Png_files/1087_IHC_CA9','.png'));