function [sol_O, hypoxia_calculated] = solve_with_obtained_param(X,V, param, eq_type_str,dx)
% This function solve the equations with the estimated parameters.

% Input : str, the sample name
%       : param, the estimated parameter vales
%       : eq_type_str, model type

% Output :
%       : X, x-interval of the domain,
%       : Y, y-interval of the domain,
%       : V, the blood vessel density obtained from the images of CD31 scan
%       : O2, the oxygen concentration obtained from the model
%       : hypoxia_data, the density obtained from the images of CA9 scan
%       : hypoxia_calculated, the density obtained from the model


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

   
        % hypoxia_calculated = hypoxia_calculated/(max(max(hypoxia_calculated)));
        hypoxia_calculated = hypoxia_calculated/(max(eps, max(hypoxia_calculated(:))));

     
end




%% Plots

