function [G_CD31, G_CA9, I_CD31, I_CA9, G_DAPI] = apply_IR_density_mask(im_CD31,im_CA9, fun_str_CD31, fun_str_CA9, fun_str_DAPI, str1, str2)

% This function does the registration of the images and apply the gaussian
% filter on the obtained densities
% It is used for PDX scans

% Input : im_CD31, matrix obtained using the imread("...tif") for CD31 scans
%       : im_CA9, matrix obtained using the imread("...tif") for CA9 scans
%       : fun_str_CD31, function name for the mask of CD31 scan
%       : fun_str_CA9, function name for the mask of CA9 scan
%       : str1, string to get the registration points for a patch or full
%       : str2, string to get the scan number

% Output:
%       : G_CA9, normalized density of CA9 in the selected patch
%       : G_CD31, normalized density of CD31 in the selecred patch

I_CD31 = (im_CD31);
I_CA9 = (im_CA9);


fixed = I_CD31;
moving = I_CA9;


filename1 = strcat('t_form', str2);


load(filename1);


% registration of images
% tform = fitgeotrans(movingPoints,fixedPoints,'affine');
Rfixed = imref2d(size(fixed));
registered = imwarp(moving,tform,'OutputView',Rfixed);

% figure(2) % to show the registed images
% imshowpair(fixed, registered,'Scaling','independent','ColorChannels','red-cyan');


% Now use the createmask functions (obtained the names from fun_str_) to
% get the densities from the RGB  images

fun_CD31 = str2func(fun_str_CD31);
fun_CA9 = str2func(fun_str_CA9);
fun_DAPI = str2func(fun_str_DAPI);
[BW_CA9,maskedRGBImage_CA9] = fun_CA9(registered);
[BW_CD31,maskedRGBImage_CD31] = fun_CD31(fixed);
[BW_DAPI,maskedRGBImage_DAPI] = fun_DAPI(registered);


maskedRGBImage_CD31 = imbinarize(maskedRGBImage_CD31,0);
G_CD31 = double(maskedRGBImage_CD31);

G_CA9 = double(rgb2gray(maskedRGBImage_CA9));
% G_CD31 = double(rgb2gray(maskedRGBImage_CD31));
G_DAPI = double(rgb2gray(maskedRGBImage_DAPI));

% gaussian filter
hsize=[5 5];sigma=10;
h1 = fspecial('gaussian',hsize,sigma);
G_CA9 = imfilter(G_CA9,h1,'replicate');

hsize2=[5 5];sigma2 = 10;
h2 = fspecial('gaussian',hsize2,sigma2);
G_CD31 = imfilter(G_CD31,h2,'replicate');

% normalize the densities

% G_CA9 = G_CA9/(max(max(G_CA9)));
% G_CD31 = G_CD31/(max(max(G_CD31)));

I_CD31 = fixed;
I_CA9 = registered;


end
