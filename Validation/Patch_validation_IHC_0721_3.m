clear all
clc;
close all;
%figure 18

addpath("T_forms/");
addpath("ColorMaskFunctions/");
%load("0721_IHC_full_sample_validation.mat")


I_CD31_full = imread('../../../Image_Data/Validating_data/Ovarian_0721_CD31.tif');
I_CD31_cropped = I_CD31_full(100:end,1300:6650,:);

I_CA9_full = imread('../../../Image_Data/Validating_data/Ovarian_0721_CA9.tif');
I_CA9_cropped = I_CA9_full(100:end,1450:6800,:);



[G_CD31, G_CA9, R_CD31, R_CA9,G_DAPI] ...
    = apply_IR_density_mask_II(I_CD31_cropped,I_CA9_cropped, 'createMask_0721_CD31',...
    'createMask_0721_CA9','createMask_0721_DAPI', '_full','_0721');


% G_CA9 = G_CA9(300:1100,1500:2900);
% G_CD31 = G_CD31(300:1100,1500:2900);
% 
% testIm_BV = R_CD31(300:1100,1500:2900);
% DAPI_cropped = I_CD31_cropped(300:1100,1500:2900);

% G_CA9 = G_CA9(300:1100,3200:4200);
% G_CD31 = G_CD31(300:1100,3200:4200);
% testIm_BV = R_CD31(300:1100,3200:4200);
% DAPI_cropped = I_CD31_cropped(300:1100,3200:4200);
% 
G_CA9 = G_CA9(3100:4100,900:2600);
G_CD31 = G_CD31(3100:4100,900:2600);
testIm_BV = R_CD31(3100:4100,900:2600);
DAPI_cropped = I_CD31_cropped(3100:4100,900:2600);



n = size(G_CA9);
Y = repmat((1:n(1))',1,n(2));
X = repmat((1:n(2)),n(1),1);


if not(isfolder('Plots/Plots_Valid_0721_IHC'))
    mkdir('Plots/Plots_Valid_0721_IHC')
end

if not(isfolder('Plots/Plots_Valid_0721_IHC/Eps_files'))
    mkdir('Plots/Plots_Valid_0721_IHC/Eps_files')
end

if not(isfolder('Plots/Plots_Valid_0721_IHC/Png_files'))
    mkdir('Plots/Plots_Valid_0721_IHC/Png_files')
end

%%

[numNonZero, hscore] = compute_heterogeneity_IHC(testIm_BV);


%%

trainedParams = readtable("../Training/All_Params.csv");

%%

f_p = '_0721_patch3_mean';

filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams);


%%
dx = 5;
eq_type_str = 'linear_expo';

alpha = mean(filtered_hs.alpha);
beta = mean(filtered_hs.beta);
gamma = mean(filtered_hs.gamma);
Ol = mean(filtered_hs.Ol);
Oh = mean(filtered_hs.Oh);
k1 = mean(filtered_hs.k1);
D = mean(filtered_hs.D);
%
param(1) = alpha;
param(2) = beta;
param(3) = gamma;
param(4) = Ol;
param(5) = Oh;
param(6) = k1;
param(7) = D;

% param(1) = filtered_hs.alpha(3,1);
% param(2) = filtered_hs.beta(3,1);
% param(3) = filtered_hs.gamma(3,1);
% param(4) = filtered_hs.Ol(3,1);
% param(5) = filtered_hs.Oh(3,1);
% param(6) = filtered_hs.k1(3,1);
% param(7) = filtered_hs.D(3,1);


sz1 = size(X,1);
sz2 = size(X,2);



x = 1:dx:sz1;
y = 1:dx:sz2;

% cell_den = get_nuclei_density(G_DAPI,dx);


[sol_O, hypoxia_calculated] = solve_with_obtained_param(X,...
    G_CD31, param, eq_type_str,dx);


G_CD31 = G_CD31(1:dx:end,1:dx:end);
G_CD31 = G_CD31/max(G_CD31(:));

% R_CD31 = double(imbinarize(R_CD31,0));
% 
% R_CD31 = R_CD31(900:1500,3600:4800);
% R_CD31 = R_CD31(1:dx:end,1:dx:end);
% R_CD31 = R_CD31/max(R_CD31(:));


testIm_DAPI = double(im2gray(DAPI_cropped));
testIm_DAPI(testIm_DAPI>230) = 0;
testIm_DAPI = imbinarize(testIm_DAPI,0);
cell_den = get_nuclei_density(testIm_DAPI,dx);
cell_den2 = cell_den';

% cell_den3 = imbinarize(cell_den2,0);


%%



hypoxia_calculated = hypoxia_calculated.*cell_den2;
hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));



G_CA9 = G_CA9(1:dx:end,1:dx:end);
hypoxia_data = G_CA9/max(G_CA9(:));

%%
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
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Eps_files/O2', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Png_files/O2',f_p, '.png'));




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
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Eps_files/BV', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Png_files/BV',f_p, '.png'));



f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,hypoxia_calculated');
view(0,90)
shading interp
colormap(flipud(hot))
clim([0,1])
colorbar
axis tight
title('Predicted Hypoxia', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Eps_files/Hypoxia', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Png_files/Hypoxia',f_p, '.png'));

%%
f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,hypoxia_data');
view(0,90)
shading interp
colormap(flipud(hot))
colorbar
axis tight
title('CA9 Marker Density', FontSize = 15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Eps_files/CA9', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Png_files/CA9',f_p, '.png'));

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
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Eps_files/DAPI', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid_0721_IHC/Png_files/DAPI',f_p, '.png'));

%%
Validation_error = ((norm(hypoxia_calculated - hypoxia_data))^2)/sqrt(sz1*sz2)

