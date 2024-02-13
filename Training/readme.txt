Main files/scripts:

The file "main.m" is the main matlab script which calls all the functions and simulates the 2-D model(dimensional form) for no flux BC for O_2;


Functions:
createMask_i(i = sample name): thresholds image to select the CD31 OR CA9 staining using auto-generated code from the colorThresholder app in MALTAB
find_density_mask_short: 
get_density_patches: reads the tiff image and get the densitites of the markers for the choosen pathches
get_density_patchesII: it also reads the tiff image and get the densitites of the markers for the choosen pathches (these are second set of patches for validation)
set_const_diff: discretized matrix of linear PDE for O2
linear_PDE_loss_fun: the loss function for linear model
non_linear_PDE_loss_fun.m:  the loss function for nonlinear model
obj_fun_PDE.m: stores the non linear system obtianed from spatial discretization
get_optimization: calls the chosen matlab optimizer and yields the parameters for the global minimum of the loss function as well as it stores the other minima and the function values therby also.
solve_with_obtained_param: Solution of PDE for O2 and algebric equation of hypoxia with the obtained paramerters
plot_fval.m: plots the fval and other parameters stored


Method: five point stencil discretization for the diffusion. The resultant system of equations have been solved using in built function (fsolve for nonlinear);


Requirement: Matlab with gliobal optimization and parallel computing toolbox.