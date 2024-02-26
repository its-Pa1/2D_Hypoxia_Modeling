# Main Files/Scripts

### main_get_the_densities.m
This script plots the densities of involved markers

### main_hetro_plot.m
This script plots the hetrogenity score (H_s) for sample patch-wise

### main_hypoxia_fun_plot.m
This script plots the hypoxia-oxygen relationship in 1D

### main_make_videos.m
This script makes video to visualize the zoomed patches in a image sample

### main_misc.m
This script performs call various functions in this directory to generate plots included in the article.

### main_param_deivation.m
This script generates the predicted O2 and hypoxia profile for various ranges of parameters.

## Functions
The functions utilized are listed below, presented in the sequence of their application.

### compute_heterogeneity
It computes heterogeneity indices for IFC images.

### compute_heterogeneity_IHC
It computes heterogeneity indices for IHC images.

### pairwise_distance
% Calculate pairwise distances between points.

### get_nuclei_density
It applies kernel density estimate to binarized DAPI stained image

### makeSeparateConnectComColoring
This function generates separate colors for each categories of blood vessesl C_i, as defined in the article

### makeSeparateImage_RW
This function generates separate plot for each patch shwoing blood vessels in red with white background

### makeSeparateImage_RW_NoAx
This function generates separate plot for each patch shwoing blood vessels in red with white background and no axis

### makeZoomVideo
It generates a zooming video of image patches and saves it.


## Requirement
To execute the scripts, MATLAB with the Global Optimization Toolbox, Image Processing Toolbox, and Parallel Computing Toolbox is required.


## Other Files and Folders
Pytho_Codes: It includes the  pythons files to generates violin plots and the plot for loss & loss_worst comparison

Plots: To save the plots.

HetOutput: Saves the heterogenity scane (H_s) for whole samples in .mat files.


