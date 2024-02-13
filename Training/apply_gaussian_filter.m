function [V, hypoxia_data] = apply_gaussian_filter(V, hypoxia_data)
% APPLY_GAUSSIAN_FILTER applies a Gaussian filter to binary and hypoxia data.

% INPUT:
%   V: CD31 image data representing blood vessels.
%   hypoxia_data: CA9 image data.

% OUTPUT:
%   V: Binary image data after applying the Gaussian filter.
%   hypoxia_data: Hypoxia data after applying the Gaussian filter.

% Convert binary image to double
V = imbinarize(V, 0);
V = double(V);

% Convert hypoxia data to double
hypoxia_data = double(hypoxia_data);

% Apply Gaussian filter to binary image
hsize = [5, 5];
sigma = 10;
h1 = fspecial('gaussian', hsize, sigma);
V = imfilter(V, h1, 'replicate');

% Apply Gaussian filter to hypoxia data
hsize2 = [5, 5];
sigma2 = 10;
h2 = fspecial('gaussian', hsize2, sigma2);
hypoxia_data = imfilter(hypoxia_data, h2, 'replicate');

end
