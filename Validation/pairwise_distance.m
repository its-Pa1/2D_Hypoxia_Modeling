function distances = pairwise_distance(varargin)
% Calculate pairwise distances between points.
%
% Input:
% - If nargin == 1: X - Matrix of points for intra distances.
% - If nargin == 2: X - Matrix of inner points, Y - Matrix of outer points for inter distances.
%
% Output:
% - distances: Pairwise distances between points.

if nargin == 1
    % Intra distances
    X = varargin{1};
    if size(X, 1) <= 1
        distances = 0;
    else
        distances = pdist2(X, X);
        distances = distances(~triu(ones(size(distances))));
    end
elseif nargin == 2
    % Inter distances
    X = varargin{1}; % Inner points
    Y = varargin{2}; % Outer points
    if isempty(X) || isempty(Y)
        distances = 1;
    else
        distances = pdist2(X, Y);
        distances = distances(:);
    end
end

end
