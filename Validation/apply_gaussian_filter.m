function [V, hypoxia_data] = apply_gaussian_filter(V, hypoxia_data)
% APPLY_GAUSSIAN_FILTER applies a Gaussian filter to binary and double-valued images.
%
% INPUT:
%   V: Binary image (blood vessel mask)
%   hypoxia_data: Double-valued image (hypoxia marker density)
%
% OUTPUT:
%   V: Binary image after applying Gaussian filter
%   hypoxia_data: Double-valued image after applying Gaussian filter

% make binary image of CD31, then convert to double
V = imbinarize(V, 0);
V = double(V);

% Gaussian filter parameters
hsize = [5 5];
sigma = 10;

% Apply Gaussian filter to binary image (blood vessel mask)
h1 = fspecial('gaussian', hsize, sigma);
V = imfilter(V, h1, 'replicate');

% Gaussian filter parameters for hypoxia data
hsize2 = [5 5];
sigma2 = 10;

% Apply Gaussian filter to double-valued image (hypoxia marker density)
h2 = fspecial('gaussian', hsize2, sigma2);
hypoxia_data = imfilter(hypoxia_data, h2, 'replicate');

end
