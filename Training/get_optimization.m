function [estimated_para, all_minimums, nxp] = get_optimization(X, V, hypoxia_data, opt_solver, eq_type_str, numOptiPoint, nworkers, numPts)
% GET_OPTIMIZATION calls the chosen MATLAB optimizer and provides the estimated parameters.

% INPUT:
%   X: Independent variable matrix.
%   V: Blood vessel density matrix.
%   hypoxia_data: Hypoxia density matrix.
%   opt_solver: Choice of optimizer.
%   eq_type_str: Model type ('linear_expo', 'linear_gen', 'nonlinear').
%   numOptiPoint: Number of optimization points for MultiStart.
%   nworkers: Number of workers for parallel processing.
%   numPts: Number of discretization points.

% OUTPUT:
%   estimated_para: The optimized parameters.
%   all_minimums: GlobalOptimSolution object storing optimization results.
%   nxp: Discretization step.

% Choose discretization step
nxp = chooseDisznStep(X, numPts);

% Set initial, lower, and upper bounds of the parameters
Seps = 1e-5;
switch eq_type_str
    case 'linear_expo'
        % % para = [  alpha  beta  gamma  O_l   O_h   k1    D      k2      k3
        p0 =       [   10     10    1    0.2   0.8   1    1e+6  ];    % Initial guess
        ub =       [  100    100    5    0.3    1    10   1e+8  ];    % Upper bounds
        lb =       [  1        1  Seps   Seps  0.8  Seps 1e+2  ];    % Lower bounds

        F = @(p) linear_PDE_loss_fun_expo(p,X, hypoxia_data,V,nxp);

    case 'linear_gen'
        % % para = [  alpha  beta  gamma  O_l   O_h   k1    D      k2      k3
        p0 =       [   10     10    1     0.2   0.8   1    1e+6     1      0.25   ];    % Initial guess
        ub =       [  100    100    5     0.3   1     10   1e+8     10      0.5    ];    % Upper bounds
        lb =       [   1       1  Seps   Seps  0.8  Seps  1e+2      1      Seps   ];    % Lower bounds
        F = @(p) linear_PDE_loss_fun_gen(p,X, hypoxia_data,V,nxp);

    case 'nonlinear'
        % % % para = [  alpha  beta  gamma  O_l   O_h   k1    D      k2      k3
        p0 =       [   12     10    10    0.2   0.8   1    1e+6    0.5      1   ];    % Initial guess
        ub =       [  200    200   300    0.5    1    50   1e+8    20      20   ];    % Upper bounds
        lb =       [  Seps   Seps  Seps   Seps  0.5  Seps  1e+5   Seps   Seps   ];    % Lower bounds
        F = @(p) non_linear_PDE_loss_fun(p,X,Y, hypoxia_data,V,nxp);


end


% Optimization solver
rng default; % For reproducibility
switch opt_solver
    case 'matlab_gs'
        opts = optimoptions(@fmincon, 'UseParallel', 'never', 'Algorithm', 'sqp', 'Display', 'off');
        problem = createOptimProblem('fmincon', 'x0', p0, 'objective', F, 'lb', lb, 'ub', ub, 'options', opts);
        gs = GlobalSearch;
        gs = GlobalSearch(gs, 'TolX', 1e-12);
        [xout, ~, ~, ~, allmins] = run(gs, problem);

    case 'matlab_ms'
        opts = optimoptions(@fmincon, 'Algorithm', 'sqp', 'MaxIter', 3000, 'Display', 'off');
        problem = createOptimProblem('fmincon', 'x0', p0, 'objective', F, 'lb', lb, 'ub', ub, 'options', opts);
        ms = MultiStart('UseParallel', true);
        npoints = numOptiPoint;
        randcol = rand(npoints, length(ub));
        tpoints = CustomStartPointSet(exp((log(lb)) + (log(ub) - log(lb)) .* (randcol)));
        rpts = RandomStartPointSet('NumStartPoints', npoints);
        allpts = {tpoints, rpts};
        mycluster = parcluster; % Create a cluster
        set(mycluster, 'NumWorkers', nworkers);
        parpool(mycluster, nworkers);
        [xout, ~, ~, ~, allmins] = run(ms, problem, allpts);
        delete(gcp);

    case 'matlab_ms_with_lsqnonlin'
        opts = optimoptions(@lsqnonlin, 'Display', 'iter');
        problem = createOptimProblem('lsqnonlin', 'x0', p0, 'objective', F, 'lb', lb, 'ub', ub, 'options', opts);
        ms = MultiStart('UseParallel', 'never');
        [xout, ~, ~, ~, allmins] = run(ms, problem, 500);
end

estimated_para = xout;
all_minimums = allmins;
end
