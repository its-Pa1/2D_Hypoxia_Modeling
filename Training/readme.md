# Main Files/Scripts

## `main.m`
The primary MATLAB script that orchestrates the simulation of the 2-D model in dimensional form with no flux boundary conditions for O_2.

## Functions
The functions utilized are listed below, presented in the sequence of their application.

### setup_image_files
It identifies and organizes image files for CD31, CA9 and DAPI markers.

### get_each_image_file
It reads and loads marker images for a specific index.

### get_density_patches
It extracts patches from CD31 and CA9 images for analysis.

### apply_gaussian_filter
It applies a Gaussian filter to blood vessels and hypoxia data.

### get_optimization
Calls the chosen MATLAB optimizer, yielding parameters for the global minimum
of the loss function. It also stores other minima and their corresponding function values.

### linear_PDE_loss_fun_expo
Loss function for the linear model with exponential form for hypoxia.

### linear_PDE_loss_fun_gen
Loss function for the linear model with sigmoidal form for hypoxia.

### non_linear_PDE_loss_fun.m
Loss function for the nonlinear model.

### chooseDisznStep
It calculate the step length from the chosen number of points for the domain discretization

### set_const_diff
Generates a discretized matrix of linear Partial Differential Equation (PDE) for oxygen distribution


### obj_fun_PDE.m
Stores the nonlinear system obtained from spatial discretization.


### solve_with_obtained_param
Solves the PDE for O2 and the algebraic equation of hypoxia with the obtained parameters.

### post_processing
It performs post-processing for each patch simulation.

### monitor_memory_whos
It uses the WHOS command to evaluate the memory usage inside the base workspace.

## Methods Applied
For comprehensive information on methods, encompassing data processing, quantification of blood vessel diversity, mathematical modeling of oxygen and hypoxia, numerical simulation of PDE, parameter estimation, and validation, please consult the "Methods" section in this paper.


## Requirement
To execute the scripts, MATLAB with the Global Optimization Toolbox, Image Processing Toolbox, and Parallel Computing Toolbox is required. Additionally, violin plots have been generated using the seaborn library in Python.


## Other Files and Folders
Archive: It includes a function designed to visualize the outcomes of training by utilizing the trained parameters.

EstiParams: The folder where the trained parameters are saved in .mat file format.

All_Params.csv: A table storing the trained parameters for all samples.
