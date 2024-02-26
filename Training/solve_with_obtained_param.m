function [sol_O, hypoxia_calculated] = solve_with_obtained_param(X,V,hypoxia_data,  str, param, eq_type_str,dx)
% SOLVE_WITH_OBTAINED_PARAM solves equations with estimated parameters.

% INPUT:
%   X: x-interval of the domain.
%   V: Blood vessel density obtained from the images of CD31 scan.
%   hypoxia_data: Density obtained from the images of CA9 scan.
%   str: Sample name.
%   param: Estimated parameter values.
%   eq_type_str: Model type.
%   dx: Spatial step length.

% OUTPUT:
%   sol_O: Solution for O2 on the discretized points.
%   hypoxia_calculated: Hypoxia calculated using the model.


sample_name = str;
% corr_r = zeros(1,size(sample_str,2));

% sample_name2 = strcat(sample_str,'_I'); % for image saving,  II for validation
sample_name2 = strcat(sample_name,'_I'); % for image saving,  II for validation





x = 1:dx:size(X,1);
y = 1:dx:size(X,2);
Lx = length(x);
Ly = length(y);
N = Lx*Ly;






V = V(1:dx:end,1:dx:end);
V = V/(max(eps, max(V(:))));


alpha = param(1);
beta = param(2);
gamma = param(3);
O_l = param(4);
O_h = param(5);
k1 = param(6);
D_h = param(7);

% source
temp_rhs = reshape(V,N,1);
RHS_O = -beta*temp_rhs./(1 + temp_rhs);

switch eq_type_str

    case 'linear_expo'

        A_O = set_const_diff(x,y,D_h,alpha); % diff matrix for O2
        % [sol_O,flag] = bicgstab(A_H,RHS_H); % solution for O2
        sol_O = A_O\RHS_O;

        sol_O = reshape(sol_O,Lx,Ly);
        sol_O = sol_O/(max(eps, max(sol_O(:))));

        hypoxia_calculated = gamma*(exp(-k1* sol_O) ) ;
        % hypoxia_calculated = gamma* (k1./ (k1 + exp(k2*(O2 - k3))));
        %
        mask = sol_O<=O_l | sol_O>=O_h; %O2>=O_h;%
        hypoxia_calculated(mask) = 0;

        hypoxia_data = hypoxia_data(1:dx:end,1:dx:end);

        hypoxia_data = hypoxia_data/(max(eps, max(hypoxia_data(:))));

        % hypoxia_calculated(V<=1e-12 & hypoxia_data<=1e-12) = 0;
        hypoxia_calculated(hypoxia_data<=1e-12) = 0;


        % hypoxia_calculated = hypoxia_calculated/(max(max(hypoxia_calculated)));
        hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));

    case 'linear_gen'
        k2 = param(8);
        k3 = param(9);





        A_O = set_const_diff(x,y,D_h,alpha); % diff matrix for O2
        % [sol_O,flag] = bicgstab(A_H,RHS_H); % solution for O2
        [sol_O,flag] = bicgstab(A_O,RHS_O); % solution for O2
        % sol_O = A_O\RHS_O;



        sol_O = reshape(sol_O,Lx,Ly);
        sol_O = sol_O/(max(eps, max(sol_O(:))));

        %hypoxia_calculated = gamma*(exp(-k1* O2) ) ;
        hypoxia_calculated = gamma* (k1./ (k1 + exp(k2*(sol_O - k3))));
        %
        mask = sol_O<=O_l | sol_O>=O_h; %O2>=O_h;%
        hypoxia_calculated(mask) = 0;

        hypoxia_data = hypoxia_data(1:dx:end,1:dx:end);
        hypoxia_data = hypoxia_data/(max(eps, max(hypoxia_data(:))));

        % hypoxia_calculated(V<=1e-12 & hypoxia_data<=1e-12) = 0;
        hypoxia_calculated(hypoxia_data<=1e-12) = 0;


        % hypoxia_calculated = hypoxia_calculated/(max(max(hypoxia_calculated)));
        hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));

    case 'nonlinear'
        k2 = param(8);
        k3 = param(9);
        data.x = x;
        data.y = y;
        data.D_s = D_h;
        data.alpha = alpha;
        data.RHS_O = RHS_O;
        ini_sol = zeros(size(RHS_O));
        options = optimoptions('fsolve','Display', 'Off','SpecifyObjectiveGradient',true);
        % options = optimoptions('fsolve','SpecifyObjectiveGradient',true);
        fun = @(sol)obj_fun_PDE(sol,data);
        [sol_O,obj_fun_val,exitflag,output] = fsolve(fun,ini_sol,options);
        sol_O = reshape(sol_O,Lx,Ly);
        sol_O = sol_O/(max(max(sol_O)));

        %hypoxia_calculated = gamma*(exp(-k1* O2) ) ;
        hypoxia_calculated = gamma* (k1./ (k1 + exp(k2*(sol_O - k3))));
        %
        mask = sol_O<=O_l | sol_O>=O_h; %O2>=O_h;%
        hypoxia_calculated(mask) = 0;

        hypoxia_data = hypoxia_data(1:dx:end,1:dx:end);
        hypoxia_data = hypoxia_data/(max(max(hypoxia_data)));

        hypoxia_calculated(V<=1e-12 & hypoxia_data<=1e-12) = 0;


        % hypoxia_calculated = hypoxia_calculated/(max(max(hypoxia_calculated)));
        hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));


end




%% Plots

