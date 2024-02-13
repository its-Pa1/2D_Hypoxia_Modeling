function [V,hypoxia_data] = apply_gaussian_filter(V,hypoxia_data)


% net = denoisingNetwork('DnCNN');
% V = denoiseImage(V,net);
% hypoxia_data = denoiseImage(hypoxia_data,net);




V = imbinarize(V,0);
V = double(V);

hypoxia_data = double(hypoxia_data);


% gaussian filter
hsize = [5 5]; sigma = 10;
h1 = fspecial('gaussian',hsize,sigma);
V = imfilter(V,h1,'replicate');

hsize2=[5 5]; sigma2 = 10;
h2 = fspecial('gaussian',hsize2,sigma2);
hypoxia_data = imfilter(hypoxia_data,h2,'replicate');


end