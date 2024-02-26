function [G_CD31, G_CA9, I_CD31, I_CA9, G_DAPI] = apply_IR_density_mask(im_CD31,im_CA9, fun_str_CD31, fun_str_CA9, fun_str_DAPI, str1, str2)

% APPLY_IR_DENSITY_MASK performs image registration and density extraction for CD31 and CA9 images o IHC types.
%
% INPUT:
%   im_CD31: CD31 image matrix obtained using imread("...tif")
%   im_CA9: CA9 image matrix obtained using imread("...tif")
%   fun_str_CD31: Function name for the mask of CD31 scan
%   fun_str_CA9: Function name for the mask of CA9 scan
%   fun_str_DAPI: Function name for the mask of DAPI scan
%   str1: String to get the registration points for a patch or full
%   str2: String to get the scan number
%
% OUTPUT:
%   G_CA9: Normalized density of CA9 in the selected patch
%   G_CD31: Normalized density of CD31 in the selected patch
%   I_CD31: Registered CD31 image
%   I_CA9: Registered CA9 image
%   G_DAPI: Normalized density of DAPI in the selected patch

I_CD31 = (im_CD31);
I_CA9 = (im_CA9);


fixed = I_CD31;
moving = I_CA9;

% Load transformation matrix
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


% Convert to binary then double for density calculation
maskedRGBImage_CD31 = imbinarize(maskedRGBImage_CD31,0);
G_CD31 = double(maskedRGBImage_CD31);

G_CA9 = double(rgb2gray(maskedRGBImage_CA9));
% G_CD31 = double(rgb2gray(maskedRGBImage_CD31));
G_DAPI = double(rgb2gray(maskedRGBImage_DAPI));

% Gaussian filter
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

