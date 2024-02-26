function [] = save_plot_figues_all()
% Script to generate and save surface plots for simulation results.

% Define the folder containing simulation parameter files
paraFolder = 'EstiParams_without_cells';

% Check if the specified folder exists
if ~isfolder(paraFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', imFolder);
    uiwait(warndlg(errorMessage));
    return;
end

% List all files in the folder
paraFiles = dir(fullfile(paraFolder, '/*.mat'));

% Check if there are any .mat files
if ~exist("paraFiles","var")
    errorMessage = sprintf('Error: There is no such files');
    fprintf(errorMessage);
    return
end

% Loop through each file
for i = 1:length(paraFiles)


    fullFileName = fullfile(paraFiles(i).folder, paraFiles(i).name);
    load(fullFileName,"sample_str", 'V',"O2", "hypoxia_data", "hypoxia_calculated","all_minimums","dx", "sz1", "sz2");

    x = 1:dx:sz1;
    y = 1:dx:sz2;


    if not(isfolder('Plots'))
        mkdir('Plots')
    end

    if not(isfolder('Plots/Eps_files'))
        mkdir('Plots/Eps_files')
    end

    if not(isfolder('Plots/Png_files'))
        mkdir('Plots/Png_files')
    end

    f = figure(1);
    % f.Visible = 'off';
    % ax1 = axes;
    surf(y,x,O2);
    view(0,90)
    shading interp
    % cmap = parula(8000);    %calculate parula colormap with 256 entries
    % colormap(cmap);        %activate given colormap
    colorbar
    % colorbar(ax1,'Ticks', 0:0.1*temp_max_sol:temp_max_sol );
    axis tight
    drawnow
    title('Oxygen ', 'Fontsize', 15);
    xlabel('X (in $\mu m$) ' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y(in $\mu m$)' , 'Fontsize', 15, 'interpreter','latex');
    saveas(f,strcat('Plots/Eps_files/Oxygen', sample_str),'epsc');
    saveas(f,strcat('Plots/Png_files/Oxygen', sample_str,'.png'));

    %%

    f = figure(2);
    % f.Visible = 'off';
    surf(y,x,V);
    view(0,90)
    colorbar
    shading interp
    % cmap = parula(256);    %calculate parula colormap with 256 entries
    % colormap(cmap);        %activate given colormap
    axis tight
    title('CD31 Marker Density', 'Fontsize', 15);

    xlabel('X (in $\mu m$) ' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y(in $\mu m$)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Eps_files/Blood_Vessels', sample_str),'epsc');
    saveas(f,strcat('Plots/Png_files/Blood_Vessels', sample_str,'.png'));


    f = figure(3);
    % f.Visible = 'off';
    surf(y,x,hypoxia_data);
    view(0,90)
    colorbar
    shading interp
    % cmap = parula(256);    %calculate parula colormap with 256 entries
    % colormap(cmap);        %activate given colormap
    axis tight
    title('CA9 Marker Density ', 'Fontsize', 15);
    xlabel('X (in $\mu m$) ' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y(in $\mu m$)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Eps_files/Hypoxia', sample_str),'epsc');
    saveas(f,strcat('Plots/Png_files/Hypoxia', sample_str,'.png'));



    %%
    f = figure(4);
    % f.Visible = 'off';
    surf(y,x,hypoxia_calculated);
    view(0,90)
    colorbar
    shading interp
    % cmap = parula(256);    %calculate parula colormap with 256 entries
    % colormap(cmap);        %activate given colormap
    axis tight
    title('Predicted Hypoxia ', 'Fontsize', 15);

    xlabel('X (in $\mu m$) ' , 'Fontsize', 15, 'interpreter','latex');
    ylabel('Y(in $\mu m$)' , 'Fontsize', 15, 'interpreter','latex');

    saveas(f,strcat('Plots/Eps_files/Computed_Hypo', sample_str),'epsc');
    saveas(f,strcat('Plots/Png_files/Computed_Hypo', sample_str,'.png'));

    close all;
end
