clear all;
clc
close all


load('Breast_0520_4_2_All_Patch_55_linear_expo.mat');
x= zeros(1,sz1);
y = zeros(1,sz2);
X = meshgrid(x,y);
y = plot_fval(all_minimums,'0520_4_2_patch55',X);


load('Breast_0520_4_1_All_Patch_25_linear_expo.mat');
x= zeros(1,sz1);
y = zeros(1,sz2);
X = meshgrid(x,y);
y = plot_fval(all_minimums,'0520_4_1_patch25',X);


load('Breast_0520_2_1_All_Patch_66_linear_expo.mat');
x= zeros(1,sz1);
y = zeros(1,sz2);
X = meshgrid(x,y);
y = plot_fval(all_minimums,'0520_2_1_patch66',X);

load('Breast_0520_25_1_All_Patch_4_linear_expo.mat');
x= zeros(1,sz1);
y = zeros(1,sz2);
X = meshgrid(x,y);
y = plot_fval(all_minimums,'0520_25_1_patch4',X);