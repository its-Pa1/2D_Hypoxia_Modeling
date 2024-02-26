clear all
clc
close all

% figure 8 and 9
% 
% fullFileName = '../EstiParams/Breast_0520_4_2_All_Patch_55_linear_expo.mat';
% load(fullFileName,"sample_str", 'V',"O2", "hypoxia_data", "hypoxia_calculated","all_minimums","dx", "sz1", "sz2");


fullFileName = '../EstiParams/1087_patch1_sol.mat';
load(fullFileName);
sz1 = size(X,1);
sz2 = size(X,2);



x = 1:dx:sz1;
y = 1:dx:sz2;



if not(isfolder('Plots_colorHot'))
    mkdir('Plots_colorHot')
end

if not(isfolder('Plots_colorHot/Eps_files'))
    mkdir('Plots_colorHot/Eps_files')
end

if not(isfolder('Plots_colorHot/Png_files'))
    mkdir('Plots_colorHot/Png_files')
end

f = figure(1);
% f.Visible = 'off';
% ax1 = axes;
surf(y,x,O2);
view(0,90)
shading interp
% cmap = parula(8000);    %calculate parula colormap with 256 entries
% colormap(cmap);        %activate given colormap
colormap(flipud(hot))
colorbar
% colorbar(ax1,'Ticks', 0:0.1*temp_max_sol:temp_max_sol );
axis tight
title('Oxygen ', 'Fontsize', 15);
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',14,FontWeight = "bold");
xlabel('X (in pixels)' , 'Fontsize', 15);
ylabel('Y (in pixels)' , 'Fontsize', 15);
saveas(f,strcat('Plots_colorHot/Eps_files/Oxygen', sample_str),'epsc');
saveas(f,strcat('Plots_colorHot/Png_files/Oxygen', sample_str,'.png'));

%%

f = figure(2);
% f.Visible = 'off';
surf(y,x,V);
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
% cmap = parula(256);    %calculate parula colormap with 256 entries
% colormap(cmap);        %activate given colormap
axis tight
title('CD31 Marker Density', 'Fontsize', 15);
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',14,FontWeight = "bold");

xlabel('X (in pixels)' , 'Fontsize', 15);
ylabel('Y (in pixels)' , 'Fontsize', 15);

saveas(f,strcat('Plots_colorHot/Eps_files/Blood_Vessels', sample_str),'epsc');
saveas(f,strcat('Plots_colorHot/Png_files/Blood_Vessels', sample_str,'.png'));


f = figure(3);
% f.Visible = 'off';
surf(y,x,hypoxia_data);
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
% cmap = parula(256);    %calculate parula colormap with 256 entries
% colormap(cmap);        %activate given colormap
axis tight
title('CA9 Marker Density ', 'Fontsize', 15);
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',14,FontWeight = "bold");
xlabel('X (in pixels)' , 'Fontsize', 15);
ylabel('Y (in pixels)' , 'Fontsize', 15);

saveas(f,strcat('Plots_colorHot/Eps_files/Hypoxia', sample_str),'epsc');
saveas(f,strcat('Plots_colorHot/Png_files/Hypoxia', sample_str,'.png'));



%%
f = figure(4);
% f.Visible = 'off';
surf(y,x,hypoxia_calculated);
view(0,90)
colormap(flipud(hot))
colorbar
shading interp
% cmap = parula(256);    %calculate parula colormap with 256 entries
% colormap(cmap);        %activate given colormap
axis tight
title('Predicted Hypoxia ', 'Fontsize', 15);
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 4;
set(gca,'FontSize',14,FontWeight = "bold");
xlabel('X (in pixels)' , 'Fontsize', 15);
ylabel('Y (in pixels)' , 'Fontsize', 15);

saveas(f,strcat('Plots_colorHot/Eps_files/Computed_Hypo', sample_str),'epsc');
saveas(f,strcat('Plots_colorHot/Png_files/Computed_Hypo', sample_str,'.png'));

close all;
% end
