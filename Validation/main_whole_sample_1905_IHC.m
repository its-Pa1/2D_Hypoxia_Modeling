clear all
clc;
close all;
% figure 20 
load('1905_IHC_full_sample_Validation.mat')
%addpath("../Param/Image_Data");
addpath("T_forms/");
addpath("ColorMaskFunctions/");

sample_name = '1905_IHC';

trainedParams = readtable("../Training/All_Params.csv");
I_CD31_full = imread('../../../Image_Data/Validating_data/Pancreas_1905_CD31.tif');
I_CD31_cropped = I_CD31_full(200:4300,1300:6400,:);

I_CA9_full = imread('../../../Image_Data/Validating_data/Pancreas_1905_CA9.tif');
I_CA9_cropped = I_CA9_full(200:4300,1200:6300,:);

f_p = '_Pancreas_1905_full_';

[G_CD31, G_CA9, R_CD31, R_CA9,G_DAPI] ...
    = apply_IR_density_mask_II(I_CD31_cropped,I_CA9_cropped, 'createMask_1905_CD31',...
    'createMask_1905_CA9','createMask_1905_DAPI', '_full','_1905');


n = size(G_CA9);
Y = repmat((1:n(1))',1,n(2));
X = repmat((1:n(2)),n(1),1);

if not(isfolder('Plots/Plots_Valid'))
    mkdir('Plots/Plots_Valid')
end
if not(isfolder('Plots/Plots_Valid/Eps_files'))
    mkdir('Plots/Plots_Valid/Eps_files')
end
if not(isfolder('Plots/Plots_Valid/Png_files'))
    mkdir('Plots/Plots_Valid/Png_files')
end

%%
sz1  = size(X,2);
sz2  = size(X,1);

x = 0; % Initial x-coordinate of the top-left corner of the rectangle
y = 0; % Initial y-coordinate of the top-left corner of the rectangle
noXDirection = 5;
noYDirection = 5;
width = floor(sz1/noXDirection); % Width of the rectangle
height = floor(sz2/noYDirection); % Height of the rectangle

imCrop_CD31 = cell(1,noXDirection*noYDirection); % pre-allocate memory
imCrop_CA9 = cell(1,noXDirection*noYDirection); % pre-allocate memory
% im_Hypo_Crop = cell(1,noXDirection*noYDirection); % pre-allocate memory
count = 1;

alpha_full = zeros(sz2, sz1);
beta_full = zeros(sz2, sz1);
gamma_full = zeros(sz2, sz1);
k1_full = zeros(sz2, sz1);
Ol_full = zeros(sz2, sz1);
Oh_full = zeros(sz2, sz1);
D_full = 1e-8 + zeros(sz2, sz1);
hetFullImage = zeros(2, noXDirection*noYDirection);
G_DAPI = double(imbinarize(G_DAPI));



[ memory_in_use ] = monitor_memory_whos();
fprintf('Memory in use after loading density is %d: GB \n', memory_in_use);

while(y+height<=sz2)
    while(x+width<=sz1)


        imCrop_CD31{count} = imcrop(R_CD31,[x, y, width, height]);
        imCrop_CA9{count} = imcrop(R_CA9,[x, y, width, height]);
        % testIm = imCrop{count}; % 53. 55, 25,44
        testIm_BV = imCrop_CD31{count};
        testIm_Hy = imCrop_CA9{count} ;




        [ memory_in_use ] = monitor_memory_whos();
        fprintf('Memory in use before working on patches is %d GB: \n', memory_in_use);


        V_max = max(testIm_BV(:));
        Hypo_max = max(testIm_Hy(:));


        if (isempty(V_max) ||isempty(Hypo_max) )
            temp_msg1 = sprintf('There is no Patch %d of sample %s  \n', count,sample_name);
            fprintf(temp_msg1);

            x = x + width;

            count = count + 1;


        elseif (V_max<1e-20 )
            temp_msg1 = sprintf('Patch %d of sample %s has no staining \n', count,sample_name);
            fprintf(temp_msg1);


            x = x + width;

            count = count + 1;


        else


            % testIm_BV = testIm(:,:,1);
            % testIm_BV(testIm_BV<=50) = 0;

            [numNonZero, hscore] = compute_heterogeneity_IHC(testIm_BV);

            hetFullImage(1,count) = numNonZero;
            hetFullImage(2,count) = hscore;


            top_left_x = x + 1;
            top_left_y = y + 1;
            bottom_right_x = x + 1 + width;
            bottom_right_y = y + 1 + height;



            filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams);



            alpha_patch = mean(filtered_hs.alpha);
            beta_patch = mean(filtered_hs.beta);
            gamma_patch = mean(filtered_hs.gamma);
            Ol_patch = mean(filtered_hs.Ol);
            Oh_patch = mean(filtered_hs.Oh);
            k1_patch = mean(filtered_hs.k1);
            D_patch = mean(filtered_hs.D);

            if(isnan(alpha_patch))
                return;
            end

            % Assign the het values
            hetPlotValues(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = hetFullImage(2,count);

            alpha_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = alpha_patch;
            beta_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = beta_patch;
            gamma_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = gamma_patch;
            k1_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = k1_patch;
            Ol_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = Ol_patch;
            Oh_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = Oh_patch;
            D_full(top_left_y:bottom_right_y, top_left_x:bottom_right_x) = D_patch;


            temp_msg = sprintf('The patch number %d is done! \n', count);
            fprintf(temp_msg);
            x = x + width;

            count = count + 1;
        end


    end

    x = 0;
    y = y + height;



end










%%
% clearvars -except  imCD31 imCA9 trainedParams sz1 sz2 hetPlotValues
% alpha_full = mean(trainedParams.alpha) + zeros(sz2, sz1);
% beta_full = mean(trainedParams.beta) + zeros(sz2, sz1);
% gamma_full = mean(trainedParams.gamma) + zeros(sz2, sz1);
% Ol_full = mean(trainedParams.Ol) + zeros(sz2, sz1);
% Oh_full = mean(trainedParams.Oh) + zeros(sz2, sz1);
% k1_full = mean(trainedParams.k1) + zeros(sz2, sz1);
% D_full = mean(trainedParams.D) + zeros(sz2, sz1);
%%


figure
imagesc(D_full);
colormap(flipud(hot))
colorbar
set(gca,'YDir','normal')
set(gca,'FontSize',12,FontWeight = "bold");
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
title('Diffusion Coeff', FontSize=16);

figure
imagesc(alpha_full);
colormap(flipud(hot))
colorbar
set(gca,'YDir','normal')
set(gca,'FontSize',12,FontWeight = "bold");
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
title('Alpha', FontSize=16);


%%
Im_BV = R_CD31;
% Im_BV(Im_BV<=50) = 0;

Im_Hy = R_CA9;
% Im_Hy(Im_Hy<=50) = 0;



%%


dx = 5;

x = 1:dx:sz2;
y = 1:dx:sz1;
Lx = length(x);
Ly = length(y);
N = Lx*Ly;

Im_BV = Im_BV(1:dx:end,1:dx:end);
Im_Hy = Im_Hy(1:dx:end,1:dx:end);

[V,hypoxia_data] = apply_gaussian_filter(Im_BV, Im_Hy);


D = D_full(1:dx:end,1:dx:end);
alpha = alpha_full(1:dx:end,1:dx:end);
beta = beta_full(1:dx:end,1:dx:end);
gamma = gamma_full(1:dx:end,1:dx:end);
k1 = k1_full(1:dx:end,1:dx:end);
Ol = Ol_full(1:dx:end,1:dx:end);
Oh = Oh_full(1:dx:end,1:dx:end);


D = reshape(D,N,1);
alpha = reshape(alpha,N,1);
beta = reshape(beta,N,1);
gamma = reshape(gamma,N,1);
k1 = reshape(k1,N,1);
Ol = reshape(Ol,N,1);
Oh = reshape(Oh,N,1);


V = V/(max(eps, max(V(:))));
hypoxia_data = hypoxia_data/(max(eps, max(hypoxia_data(:))));

temp_rhs = reshape(V,N,1);
RHS_O = -beta.*(temp_rhs./(1 + temp_rhs));


%%


A_O = set_variable_params_diff_(x,y,D,alpha); % diff matrix for O2


tf = canUseGPU();
if tf
    A_O = gpuArray(A_O);
end


[H_O1,flag] = bicgstab(A_O,RHS_O); % solution for O2
% H_O1 = A_O\RHS_O; % solution for O2
H_O1 = reshape(H_O1,Lx,Ly);

% normalization
%H_O1 = H_O1/(max(eps, max(H_O1(:))));

sol_O = gather(H_O1);

% sol_O = A_O\RHS_O;
% sol_O = reshape(sol_O,Lx,Ly);
sol_O = sol_O/(max(eps, max(sol_O(:))));

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
saveas(f,strcat('Plots/Plots_Valid/Eps_files/O2', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid/Png_files/O2',f_p, '.png'));


%%
f = figure;
% f.Visible = 'off';
% ax1 = axes;
surf(x,y,V');
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
saveas(f,strcat('Plots/Plots_Valid/Eps_files/BV', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid/Png_files/BV',f_p, '.png'));


%%

% AA = [1,2,3,0.1,4];
% th1 = [1,2,3,0.1,5];
% mask11 = AA>=th1;
% BB = AA;
% BB(mask11) = 0;

hypoxia_calculated = gamma.*(exp(-k1.* sol_O(:)) ) ;
% hypoxia_calculated = gamma* (k1./ (k1 + exp(k2*(O2 - k3))));
%
mask = sol_O(:)<=Ol | sol_O(:)>=Oh; %O2>=O_h;%
hypoxia_calculated(mask) = 0;


%
% hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));
%%
hypoxia_calculated = reshape(hypoxia_calculated,Lx,Ly);

%%

% f = figure;
% % f.Visible = 'off';
% % ax1 = axes;
% surf(x,y,hypoxia_calculated');
% view(0,90)
% shading interp
% colormap(flipud(hot))
% colorbar
% axis tight
% title('Predicted Hypoxia without cell', FontSize=16);


%%
%
% %testIm_DAPI = G_DAPI;

% %testIm_DAPI(testIm_DAPI<25) = 0;
%
% testIm_DAPI = double(im2gray(I_CD31_cropped));
% testIm_DAPI(testIm_DAPI>230) = 0;
% testIm_DAPI = imbinarize(testIm_DAPI,0);
% cell_den = get_nuclei_density(testIm_DAPI,dx);
% cell_den2 = cell_den';

%%
hypoxia_calculated = hypoxia_calculated.*cell_den2;
hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));


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
saveas(f,strcat('Plots/Plots_Valid/Eps_files/Hypoxia', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid/Png_files/Hypoxia',f_p, '.png'));

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
title('CA9 Marker Density', FontSize=15);
xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',12,FontWeight = "bold");
saveas(f,strcat('Plots/Plots_Valid/Eps_files/CA9', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid/Png_files/CA9',f_p, '.png'));
%%
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
saveas(f,strcat('Plots/Plots_Valid/Eps_files/DAPI', f_p),'epsc');
saveas(f,strcat('Plots/Plots_Valid/Png_files/DAPI',f_p, '.png'));


%%
Validation_error = ((norm(hypoxia_calculated - hypoxia_data))^2)/sqrt(sz1*sz2)

toc