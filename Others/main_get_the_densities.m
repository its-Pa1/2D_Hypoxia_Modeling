clear all;
clc;
close all;

% figure 3

tic

I_BV = imread('../../Image_Data/Training_data/Breast_1090_CD31.tif');
I_Hy = imread('../../Image_Data/Training_data/Breast_1090_CA9.tif');
DAPI_image = imread('../../Image_Data/Training_data/Breast_1090_DAPI.tif');

sample_str = 'Breast_1090_';

DAPI_image_cropped = DAPI_image(9500:11500,9500:11500,:); % check the nuclei also here(11500:12000,7000:7500,:);

redChannel = DAPI_image_cropped(:, :, 1);
greenChannel = DAPI_image_cropped(:, :, 2);
blueChannel = DAPI_image_cropped(:, :, 3);
% blackpixelsmask = redChannel < 25 & greenChannel < 25 & blueChannel < 25;

blackpixelsmask = redChannel <50 & greenChannel <50 & blueChannel <50 ;

redChannel(blackpixelsmask) = 255;
greenChannel(blackpixelsmask) = 255;
blueChannel(blackpixelsmask) = 255;
rgbImage_DAPI = cat(3, redChannel, greenChannel, blueChannel);

DAPI_image = double(DAPI_image_cropped(:,:,3));



I_BV_cropped = I_BV(9500:11500,9500:11500,:);


redChannel = I_BV_cropped(:, :, 1);
greenChannel = I_BV_cropped(:, :, 2);
blueChannel = I_BV_cropped(:, :, 3);
% blackpixelsmask = redChannel < 25 & greenChannel < 25 & blueChannel < 25;

blackpixelsmask = redChannel < 50 & greenChannel <50 & blueChannel <50 ;

redChannel(blackpixelsmask) = 255;
greenChannel(blackpixelsmask) = 255;
blueChannel(blackpixelsmask) = 255;
rgbImage_BV = cat(3, redChannel, greenChannel, blueChannel);

I_BV = double(I_BV_cropped(:,:,1));


I_Hy_cropped = I_Hy(9500:11500,9500:11500,:); % check the nuclei also here



redChannel = I_Hy_cropped(:, :, 1);
greenChannel = I_Hy_cropped(:, :, 2);
blueChannel = I_Hy_cropped(:, :, 3);
% blackpixelsmask = redChannel < 25 & greenChannel < 25 & blueChannel < 25;

blackpixelsmask = redChannel < 50 & greenChannel <50 & blueChannel <50 ;

redChannel(blackpixelsmask) = 255;
greenChannel(blackpixelsmask) = 255;
blueChannel(blackpixelsmask) = 255;
rgbImage_HY = cat(3, redChannel, greenChannel, blueChannel);


I_Hy = double(I_Hy_cropped(:,:,2));


dx = 2;

I_Hy = I_Hy(1:dx:end, 1:dx:end);
I_BV = I_BV(1:dx:end, 1:dx:end);


x = 1:dx:size(DAPI_image,1);
y = 1:dx:size(DAPI_image,2);
cell_den = get_nuclei_density(DAPI_image,dx);

% gaussian filter
hsize=[5 5];sigma=10;
h1 = fspecial('gaussian',hsize,sigma);
hy_den = imfilter(I_Hy,h1,'replicate');

% direct filter
hy_den2 = imgaussfilt(I_Hy,5);

% gaussian filter
hsize=[5 5];sigma=10;
h1 = fspecial('gaussian',hsize,sigma);
BV_den = imfilter(I_BV,h1,'replicate');
BV_den = BV_den/max(BV_den(:));

% direct filter
BV_den2 = imgaussfilt(I_BV,2);


hy_den = hy_den/max(hy_den(:));
BV_den = BV_den/max(BV_den(:));


%%

if not(isfolder('Plots/Plots_den'))
    mkdir('Plots/Plots_den')
end

if not(isfolder('Plots/Plots_den/Eps_files'))
    mkdir('Plots/Plots_den/Eps_files')
end

if not(isfolder('Plots/Plots_den/Png_files'))
    mkdir('Plots/Plots_den/Png_files')
end
%%
% figure
% imshow(rgbImage_DAPI)
% 
% %%
% figure
% imagesc(cell_den');
% colormap(flipud(hot))
% colorbar
% set(gca,'YDir','normal');
% 
% 


%%
f = figure(1);
% f.Visible = 'off';
surf(x,y,cell_den');
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
ax = gca;
ax.XAxis.Exponent = 3;
ax.YAxis.Exponent = 3;
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/cell_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/cell_den_', sample_str,'.png'));

%%
f = figure(2);
% f.Visible = 'off';
surf(x,y,hy_den);
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
ax = gca;
ax.XAxis.Exponent = 3;
ax.YAxis.Exponent = 3;
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/hy_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/hy_den_', sample_str,'.png'));
%% 
f = figure(3);
% f.Visible = 'off';
surf(x,y,BV_den);
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
ax = gca;
ax.XAxis.Exponent = 3;
ax.YAxis.Exponent = 3;
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/BV_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/BV_den_', sample_str,'.png'));



%%
f = figure(4);
imshow(rgbImage_BV);
set(gca,'YDir','normal');
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/BV_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/BV_den_', sample_str,'.png'));

f = figure(5);
imshow(rgbImage_HY);
set(gca,'YDir','normal');
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/BV_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/BV_den_', sample_str,'.png'));

f = figure(6);
imshow(rgbImage_DAPI);
set(gca,'YDir','normal');
set(gca,'FontSize',12,FontWeight = "bold");
axis tight
saveas(f,strcat('Plots/Plots_den/Eps_files/BV_den_', sample_str),'epsc');
saveas(f,strcat('Plots/Plots_den/Png_files/BV_den_', sample_str,'.png'));


toc