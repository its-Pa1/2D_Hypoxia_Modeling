function cell_den = get_nuclei_density(DAPI_image,dx)
% This function apply the kernel density estimate to the binaraized images to
% obtained nucluei density

% Input : DAPI_image, binarised DAPI stained image

% Output : cell_den, density if cell nuleui


testIm = DAPI_image(1:dx:end,1:dx:end);
x = 1:dx:size(DAPI_image,1);
y = 1:dx:size(DAPI_image,2);

[X,Y] = meshgrid(x, y);
x1 = X(:);
x2 = Y(:);
xi_2D = [x1 x2];


[nzx,nzy] = find(testIm);

nzx = x(nzx);
nzy = y(nzy);

x_2D = [nzx',nzy'];
% 
% x_2D = gpuArray(x_2D);
% xi_2D = gpuArray(xi_2D);


[dist,xval,bw] = ksdensity(x_2D,xi_2D, Bandwidth=10); % 'Bandwidth',100

% dist = gather(dist);
%%
dist = reshape(dist,length(y),length(x));

cell_den = dist/max(max(dist));

