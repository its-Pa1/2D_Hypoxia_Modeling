clear all
clc;
close all;

% figure 19
%addpath("../Param/Image_Data");
addpath("T_forms/");
addpath("ColorMaskFunctions/");


f_p = '_patch_4_1087_IHC_';
I_CD31_full = imread('../Image_data/Validating_data/Pancreas_1087_CD31.tif');
I_CD31_cropped = I_CD31_full(100:end,900:6500,:);

I_CA9_full = imread('../Image_data/Validating_data/Pancreas_1087_CA9.tif');
I_CA9_cropped = I_CA9_full(100:end,700:6300,:);


[G_CD31, G_CA9, R_CD31, R_CA9,G_DAPI] ...
    = apply_IR_density_mask_II(I_CD31_cropped,I_CA9_cropped, 'createMask_1087_CD31',...
    'createMask_1087_CA9','createMask_1087_DAPI', '_full','_1087');

% 
% G_CA9 = G_CA9(1500:3500,500:2500);
% G_CD31 = G_CD31(1500:3500,500:2500);
% G_DAPI = G_DAPI(1500:3500,500:2500);
% G_DAPI = double(imbinarize(G_DAPI,0));

% 
% G_CA9 = G_CA9(500:1500,1500:2500);
% G_CD31 = G_CD31(500:1500,1500:2500);
% G_DAPI = G_DAPI(500:1500,1500:2500);
% G_DAPI = double(imbinarize(G_DAPI,0));
% 
% I_CD31_P = I_CA9_cropped(500:1500,1500:2500,:);

% G_CA9 = G_CA9(3500:end,2000:4000);
% G_CD31 = G_CD31(3500:end,2000:4000);
% G_DAPI = G_DAPI(3500:end,2000:4000);
% G_DAPI = double(imbinarize(G_DAPI,0));
% I_CD31_P = I_CD31_cropped(3500:end,2000:4000);



G_CA9 = G_CA9(500:1500,4500:5600);
G_CD31 = G_CD31(500:1500,4500:5600);
testIm_BV = R_CD31(500:1500,4500:5600);
G_DAPI = G_DAPI(500:1500,4500:5600);
G_DAPI = double(imbinarize(G_DAPI,0));
I_CD31_P = I_CD31_cropped(500:1500,4500:5600);

n = size(G_CA9);
Y = repmat((1:n(1))',1,n(2));
X = repmat((1:n(2)),n(1),1);



if not(isfolder('Plots/Plots_Valid_1087_IHC'))
    mkdir('Plots/Plots_Valid_1087_IHC')
end

if not(isfolder('Plots/Plots_Valid_1087_IHC/Eps_files'))
    mkdir('Plots/Plots_Valid_1087_IHC/Eps_files')
end

if not(isfolder('Plots/Plots_Valid_1087_IHC/Png_files'))
    mkdir('Plots/Plots_Valid_1087_IHC/Png_files')
end

%%

[numNonZero, hscore] = compute_heterogeneity_IHC(testIm_BV);


%%

trainedParams = readtable("../Training/All_Params.csv");

%%

patchNumber = '_IHC_patch3';

filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams);

%%
dx = 5;
eq_type_str = 'linear_expo';


param(1) = filtered_hs.alpha(3,1);
param(2) = filtered_hs.beta(3,1);
param(3) = filtered_hs.gamma(3,1);
param(4) = filtered_hs.Ol(3,1);
param(5) = filtered_hs.Oh(3,1);
param(6) = filtered_hs.k1(3,1);
param(7) = filtered_hs.D(3,1);



testIm_DAPI = double(im2gray(I_CD31_P));
testIm_DAPI(testIm_DAPI>230) = 0;
testIm_DAPI = imbinarize(testIm_DAPI,0);
cell_den = get_nuclei_density(testIm_DAPI,dx);
cell_den2 = cell_den';

[sol_O, hypoxia_calculated] = solve_with_obtained_param(X,...
    G_CD31, param, eq_type_str,dx);


%%




hypoxia_calculated = hypoxia_calculated.*cell_den2;
hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));

sz1 = size(X,1);
sz2 = size(X,2);



x = 1:dx:sz1;
y = 1:dx:sz2;

G_CA9 = G_CA9(1:dx:end,1:dx:end); 
G_CA9 = G_CA9/max(G_CA9(:));

G_CD31 = G_CD31(1:dx:end,1:dx:end); 
G_CD31 = G_CD31/max(G_CD31(:));

%%
f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,hypoxia_calculated');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('Predicted Hypoxia', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Eps_files/Hypoxia', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Png_files/Hypoxia',f_p, '.png'));

%%
f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,G_CA9');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('CA9 Marker Density', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Eps_files/CA9', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Png_files/CA9',f_p, '.png'));

f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,cell_den2');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('DAPI Density', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Eps_files/DAPI', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Png_files/DAPI',f_p, '.png'));

f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,sol_O');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('Oxygen', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Eps_files/O2', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Png_files/O2',f_p, '.png'));


%%
f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,G_CD31');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('Blood vessels', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Eps_files/BV', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_1087_IHC/Png_files/BV',f_p, '.png'));


%%
Validation_error = ((norm(hypoxia_calculated - G_CA9))^2)/sqrt(sz1*sz2)
