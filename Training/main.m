%% Clear Workspace
clear all;
clc;
close all;

% Start Timer
tic

% Ask the user if they want to proceed with training on the entire data set
responseUser = questdlg('The training on the entire data set will need a few days. Would you like to start?', ...
    'Start Menu', ...
    'Yes', 'No', 'No');

switch responseUser
    case 'Yes'
        disp('OK, Here we go!')
        checkResponse = 1;
    case 'No'
        disp(' OK, Thanks!')
        checkResponse = 0;
end

if checkResponse
    % First, set up paths for image files (CD31 and CA9)
    [both_CD31, both_CA9] = setup_image_files();

    % Monitor initial memory usage
    [memory_in_use] = monitor_memory_whos();
    fprintf('Memory in use before the main loop: %d GB \n', memory_in_use);

    % Loop through each image file
    for j = 1: length(both_CD31) % 

        % Read and load the jth image (both CD31 & CA9)
        [imCD31, imCA9, sample_name] = get_each_image_file(both_CD31, both_CA9, j);
        fprintf(1, 'Now reading and working on sample %s\n', sample_name);

        % Process density patches for the current image pair
        [imCD31, imCA9] = get_density_patches(imCD31, imCA9);

        % Monitor memory usage after loading density
        [memory_in_use] = monitor_memory_whos();
        fprintf('Memory in use after loading density is %d GB \n', memory_in_use);

        % Loop through each patch in the current image pair
        for k = 1:length(imCD31)
            tStart = tic;

            % Close all figures
            close all;

            % Monitor memory usage before working on patches
            [memory_in_use] = monitor_memory_whos();
            fprintf('Memory in use before working on patches is %d GB \n', memory_in_use);

            % Extract maximum values from CD31 and CA9 images
            V_max = max(imCD31{k}(:));
            Hypo_max = max(imCA9{k}(:));

            % Check for empty or negligible patches
            if isempty(V_max) || isempty(Hypo_max) || V_max < 1e-20 || Hypo_max < 1e-20
                temp_msg1 = sprintf('There is no Patch %d of sample %s \n', k, sample_name);
                fprintf(temp_msg1);
                continue
            else
                % Apply Gaussian filter to CD31 and CA9 images
                [V, hypoxia_data] = apply_gaussian_filter(imCD31{k}, imCA9{k});

                % Normalize data
                hypoxia_data = hypoxia_data / max(eps, max(hypoxia_data(:)));
                V = V / max(eps, max(V(:)));

                % Display patch information
                temp_msg = sprintf('Training on Patch %d of sample %s \n', k, sample_name);
                fprintf(temp_msg);

                % Set up X matrix for optimization
                n = size(hypoxia_data);
                X = repmat((1:n(2)), n(1), 1);

                % Set optimization parameters
                opt_solver = 'matlab_ms'; % 'matlab_ms_with_lsqnonlin'; % 'matlab_gs'; % 'matlab_ms'; % 'matlab_ms_with_lsqnonlin';
                eq_type_str = 'linear_expo'; % 'linear_expo'; %linear_gen %nonlinear
                additionStr = '_Binary';
                numOptiPoint = 50;
                nworkers = 4;
                numPts = 350;

                % Obtain optimized parameters
                [estimated_param, all_minimums, DiscritizationLen] = get_optimization(X, V, hypoxia_data, opt_solver, eq_type_str, numOptiPoint, nworkers, numPts);

                % Generate sample string
                sample_str = convertCharsToStrings(strcat(sample_name, '_Patch_', num2str(k)));

                % Solve with obtained parameters
                [O2, hypoxia_calculated] = solve_with_obtained_param(X, V, hypoxia_data, sample_str, estimated_param, eq_type_str, DiscritizationLen);

                % Post-processing and loss calculation
                [loss, loss_worst, EstimatedParamTable] = post_processing(X, all_minimums, sample_str, DiscritizationLen, hypoxia_data, V, O2, hypoxia_calculated, eq_type_str, additionStr);

                % Monitor memory usage at the end
                [memory_in_use] = monitor_memory_whos();
                fprintf('Memory in use at the end: %d GB \n', memory_in_use);
            end

            % Display elapsed time for the current patch
            tEnd = toc(tStart);
            fprintf('Elapsed time for this patch is %8.3f seconds \n', tEnd);
        end
    end

  
end
  % Display total elapsed time for the entire process
toc
