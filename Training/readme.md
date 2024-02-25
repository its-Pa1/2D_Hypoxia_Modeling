# Main Files/Scripts

## `main.m`
The primary MATLAB script that orchestrates the simulation of the 2-D model in dimensional form with no flux boundary conditions for O_2.

## Functions

### `createMask_i(i = sample name)`
Thresholds an image to select the CD31 OR CA9 staining using auto-generated code
from the colorThresholder app in MATLAB.

### find_density_mask
Function for finding density masks.

### get_density_patches
Reads the TIFF image and calculates marker densities for chosen patches.

### get_density_patchesII
Reads the TIFF image and calculates marker densities for a second set of patches

### set_const_diff
Generates a discretized matrix of linear Partial Differential Equation (PDE) for O2.

### linear_PDE_loss_fun
Loss function for the linear model.
### non_linear_PDE_loss_fun.m
Loss function for the nonlinear model.

### obj_fun_PDE.m
Stores the nonlinear system obtained from spatial discretization.
### get_optimization
Calls the chosen MATLAB optimizer, yielding parameters for the global minimum
of the loss function. It also stores other minima and their corresponding function values.

### solve_with_obtained_param
Solves the PDE for O2 and the algebraic equation of hypoxia with the obtained parameters.

### plot_fval.m
Plots the function value (fval) and other stored parameters.

## Method
The method employs a five-point stencil discretization for diffusion. The resulting system of equations is solved using the built-in function fsolve for nonlinear equations.

## Requirement
MATLAB with the Global Optimization Toolbox and Parallel Computing Toolbox is necessary to run the scripts.

