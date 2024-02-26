function filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams)
% GET_THE_SORTED_PARAMS filters parameters based on heterogeneity score and number of non-zero elements
%
% INPUT:
%   hscore: Heterogeneity score
%   numNonZero: Number of non-zero elements
%   trainedParams: Set of trained parameters
%
% OUTPUT:
%   filtered_hs: Filtered parameters based on hscore and numNonZero


temp = [];
% start with a 10% interval
threshold = 0.1;

while(isempty(temp))

    % Het score interval
    min_hs = max(0, hscore - hscore*threshold);
    max_hs = min(1, hscore + hscore*threshold);


    % Non-zero pixel interval
    min_NN = max(0, numNonZero - numNonZero*threshold);
    max_NN = min(1, numNonZero + numNonZero*threshold);

    % retrive the non zero pixels of all trained data
    data_NN = trainedParams.NumNonZeroPixels;


    % the mask for non-zero pixels
    mask  = data_NN<=max_NN & data_NN>=min_NN;


    % Filter on the basis of non-zero mask
    tempFiltered = trainedParams(mask,:);

    % retrive the het score for all trained dataset
    data_hs2 = tempFiltered.HeteroScore;

    % the mask for hetro score
    mask1 = data_hs2<=max_hs & data_hs2>=min_hs;

    % Filter on the basis of hetro mask
    temp = tempFiltered(mask1,:);

    % increment in threshold by 1%
    threshold = threshold + 0.01;


end

filtered_hs = temp;