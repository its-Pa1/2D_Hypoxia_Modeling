function A_s = set_variable_params_diff_(x,y,D_s, source)
% This function computes the diffusion matrix for constant diffusion
% here usual 5 point stencils has been used for central 
% difference discretization

% Input : D_s = diffusion coefficient
%       : source = decay rate
%       : x = x-interval of the domain
%       : y = y-interval of the domain
% Output : A_s = sparse matrix obtained from the discretization

del_x = x(2) - x(1);
del_y = y(2) - y(1);

Lx = length(x);
Ly = length(y);
N = Lx*Ly; % total number of unknowns in the square grid

a = 1/(del_x*del_x);% the elements of the matrix
b = 1/(del_y*del_y);% the elements of the matrix
gamma = 2*(a + b);


% upper most diagonal
temp = b*ones(N,1);
temp(Lx:2*Lx) = 2*b;
temp = temp.*D_s;

% lower most diagonal
temp0 = b*ones(N,1);
temp0(N-2*Lx+1:N) = 2*b;
temp0 = temp0.*D_s;


%sub- diagonal
temp1 = a*ones(N,1);
temp1(Lx-1:Lx:end) = 2*a;
temp1(Lx:Lx:end) = 0;
temp1 = temp1.*D_s;

% super-diagonal
temp2 = a*ones(N,1);
temp2(2:Lx:end) = 2*a;
temp2(Lx+1:Lx:end) = 0;
temp2 = temp2.*D_s;

% main diagonal
% diag_s = (-gamma)*ones(N,1) - b1;
diag_s = (-gamma)*ones(N,1);
diag_s = (diag_s.*D_s) - source;



% the matrix
A_s = spdiags([temp0, temp1, diag_s , temp2, temp],[-(Lx),-1,0,1,Lx],N,N);

end