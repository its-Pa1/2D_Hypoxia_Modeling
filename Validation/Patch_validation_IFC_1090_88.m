clear all
clc;
close all;

% read the images
imBV = imread('../Image_data/Training_data/Breast_1090_CD31.tif');
imDAPI = imread('../Image_data/Training_data/Breast_1090_DAPI.tif');
imHy = imread('../Image_data/Training_data/Breast_1090_CA9.tif');




imBV2 = imBV(:,:,1)';

%%

% get the patches
croppedImages_BV = makeCropImage(imBV2,imBV, 1);
croppedImages_Hy = makeCropImage(imBV2,imHy, 2);
croppedImages_DAPI = makeCropImage(imBV2,imDAPI, 3);

% create folder to save plots
if not(isfolder('Plots/Plots_Valid_1090IFC'))
    mkdir('Plots/Plots_Valid_1090IFC')
end

if not(isfolder('Plots/Plots_Valid_1090IFC/Eps_files'))
    mkdir('Plots/Plots_Valid_1090IFC/Eps_files')
end

if not(isfolder('Plots/Plots_Valid_1090IFC/Png_files'))
    mkdir('Plots/Plots_Valid_1090IFC/Png_files')
end

%% Validation for index i, here selected one

for i = 88 % [78,88,89]
    testIm_BV = croppedImages_BV{i}; 
    testIm_Hy = croppedImages_Hy{i}; 
    testIm_DAPI = croppedImages_DAPI{i}; 

    sample_str = strcat('1090_IFC_patch_', num2str(i));

    testIm_BV = testIm_BV(:,:,1);
    testIm_Hy = testIm_Hy(:,:,2);
    testIm_DAPI = testIm_DAPI(:,:,3);

    %%
    testIm_BV(testIm_BV<=25) = 0;
    testIm_Hy(testIm_Hy<=25) = 0;


    [V,hypoxia_data] = apply_gaussian_filter(testIm_BV, testIm_Hy);



    %%
    n = size(hypoxia_data);
    X = repmat((1:n(2)),n(1),1);


    %%

    [numNonZero, hscore] = compute_heterogeneity_IHC(testIm_BV);


    %%

    trainedParams = readtable("../Training/All_Params.csv");

    %%

    patchNumber = '_IFC_patch25';

    filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams);

    %%

    dx = 5;
    eq_type_str = 'linear_expo';

    cell_den = get_nuclei_density(testIm_DAPI,dx);
    cell_den2 = cell_den';
    %%

    alpha = mean(filtered_hs.alpha);
    beta = mean(filtered_hs.beta);
    gamma = mean(filtered_hs.gamma);
    Ol = mean(filtered_hs.Ol);
    Oh = mean(filtered_hs.Oh);
    k1 = mean(filtered_hs.k1);
    D = mean(filtered_hs.D);

    param(1) = alpha;
    param(2) = beta;
    param(3) = gamma;
    param(4) = Ol;
    param(5) = Oh;
    param(6) = k1;
    param(7) = D;

 

    [sol_O, hypoxia_calculated] = solve_with_obtained_param(X,...
        V, param, eq_type_str,dx);


    hypoxia_calculated = hypoxia_calculated.*cell_den2;

    hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));

    sz1 = size(X,1);
    sz2 = size(X,2);



    x = 1:dx:sz1;
    y = 1:dx:sz2;


    G_CA9 = hypoxia_data(1:dx:end,1:dx:end);
    G_CA9 = G_CA9/max(G_CA9(:));

    BV = V(1:dx:end,1:dx:end);
    BV = BV/max(BV(:));

    loss = (norm(hypoxia_calculated - G_CA9))^2;
    loss = loss/sqrt(size(X,1)*size(X,2));



    f = figure(1);
    % f.Visible = 'off';
    % ax1 = axes;
    surf(y,x,BV);
    view(0,90)
    shading interp
    colormap(flipud(hot))
    colorbar
    axis tight
    title('CD31 Marker Density', 'Fontsize', 15);
    xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Eps_files/Blood_Vessels', sample_str),'epsc');
    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Png_files/Blood_Vessels', sample_str,'.png'));


    f = figure(2);
    % f.Visible = 'off';
    % ax1 = axes;
    surf(y,x,sol_O);
    view(0,90)
    shading interp
    colormap(flipud(hot))
    colorbar
    axis tight
    title('Oxygen ', 'Fontsize', 15);
    xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Eps_files/Oxygen', sample_str),'epsc');
    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Png_files/Oxygen', sample_str,'.png'));

    f = figure(3);
    % f.Visible = 'off';
    % ax1 = axes;
    surf(y,x,hypoxia_calculated);
    view(0,90)
    shading interp
    colormap(flipud(hot))
    colorbar
    axis tight
    title('Predicted Hypoxia ', 'Fontsize', 15);
    xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Eps_files/Computed_Hypo', sample_str),'epsc');
    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Png_files/Computed_Hypo', sample_str,'.png'));


    f = figure(4);
    % f.Visible = 'off';
    % ax1 = axes;
    surf(y,x,G_CA9);
    view(0,90)
    shading interp
    colormap(flipud(hot))
    colorbar
    axis tight
    title('CA9 Marker Density ', 'Fontsize', 15);
    xlabel('X (in pixels)' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y (in pixels)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Eps_files/Hypoxia', sample_str),'epsc');
    saveas(f,strcat('Plots/Plots_Valid_1090IFC/Png_files/Hypoxia', sample_str,'.png'));

end