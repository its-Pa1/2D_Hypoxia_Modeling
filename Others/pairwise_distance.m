function d = pairwise_distance(varargin)

%---------------------------------------------------------------------
% intra distances
if nargin==1
    X = varargin{1};

    % lenInteriorDist = size(X,1);
    %
    %
    %
    % if ((lenInteriorDist == 0 )|| (lenInteriorDist == 1 ))
    %     d = 0;
    % else
    %     nPossiblePoints = nchoosek(1:size(X,1),2);
    %     dist_all = zeros(1,size(nPossiblePoints,1));
    %
    %     for i = 1:size(nPossiblePoints,1)
    %         Coord_1st = X(nPossiblePoints(i,1),:);  % The first coordinate
    %         Coord_2nd = X(nPossiblePoints(i,2),:);  % The second coordinate
    %         pair_all = [Coord_1st;Coord_2nd];
    %         dist_all(i) = pdist(pair_all,'euclidean');
    %
    %     end
    %
    %     d = dist_all;
    % end
    if (size(X,1)<=1)
        d = 0;
    else

        d = pdist2(X,X);
        d = d(~triu(ones(size(d))));
    end
    %---------------------------------------------------------------------
    % extra/ inter distances
elseif nargin==2
    X = varargin{1}; % inner points
    Y = varargin{2}; % outer points

    % lenInteriorDist = size(X,1);
    % lenExteriorDist = size(Y,1);

    % if (lenInteriorDist == 0 || lenExteriorDist ==0)
    %     d = 1;
    % else
    %
    %     nPossibleOuters = (size(Y,1))*( size(X,1));   % all points =  outers_points*inner_points
    %
    %     dist_in_out = zeros(1,nPossibleOuters);
    %
    %     count = 1;
    %     for i = 1:size(X,1)
    %         for j = 1:size(Y,1)
    %             Coord_in = X(i,:);  % The first coordinate
    %             Coord_out = Y(j,:);  % The second coordinate
    %             pair_in_out = [Coord_in; Coord_out];
    %             dist_in_out(count) = pdist(pair_in_out,'euclidean');
    %             count = count+1;
    %
    %         end
    %     end
    %
    %     d = dist_in_out;
    % end

    if isempty(X) || isempty(Y)
        d = 1;
    else
        d = pdist2(X,Y);
        d = d(:);
    end

end

end