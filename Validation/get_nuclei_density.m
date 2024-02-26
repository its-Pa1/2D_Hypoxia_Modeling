function cell_den = get_nuclei_density(DAPI_image,dx)
% GET_NUCLEI_DENSITY applies kernel density estimate to binarized DAPI stained image
%
% INPUT:
%   DAPI_image: Binarized DAPI stained image
%   dx: Sampling interval for density calculation
%
% OUTPUT:
%   cell_den: Density of cell nuclei

% Downsample the DAPI image
testIm = DAPI_image(1:dx:end,1:dx:end);
x = 1:dx:size(DAPI_image,1);
y = 1:dx:size(DAPI_image,2);

% Generate 2D grid
[X,Y] = meshgrid(x, y);
x1 = X(:);
x2 = Y(:);
xi_2D = [x1 x2];

% Find non-zero indices in the downsampled image
[nzx,nzy] = find(testIm);

nzx = x(nzx);
nzy = y(nzy);

x_2D = [nzx',nzy'];
% 
% x_2D = gpuArray(x_2D);
% xi_2D = gpuArray(xi_2D);

% Apply kernel density estimation
[dist,xval,bw] = ksdensity(x_2D,xi_2D, Bandwidth=10); % 'Bandwidth',100

% dist = gather(dist);
%%
% Reshape the density vector to a 2D matrix
dist = reshape(dist,length(y),length(x));

% Normalize the density
cell_den = dist/max(max(dist));

