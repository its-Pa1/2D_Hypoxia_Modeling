function dx = chooseDisznStep(X, numPts)
% Calculate dx from the chosen number of points for the domain discretization

% Input:
%   X: It contains the domain length and width
%   numPts: Number of desired points for discretization

% Output:
%   dx: The spatial step length

minSize = min(size(X, 1), size(X, 2));

% Create a linearly spaced vector with the desired number of points
temp = linspace(1, minSize, numPts);

% Calculate the initial estimate of dx
dx = temp(2) - temp(1);

% Ensure that dx is an even integer
dx = max(1, 2 * floor(dx / 2));
end
