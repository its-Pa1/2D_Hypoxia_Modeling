function filtered_hs = get_the_sorted_params(hscore,numNonZero,trainedParams)
temp = [];
threshold = 0.1;
while(isempty(temp))
    % run a loop for a h-score +-10%
                min_hs = max(0, hscore - hscore*threshold);
                max_hs = min(1, hscore + hscore*threshold);


                min_NN = max(0, numNonZero - numNonZero*threshold);
                max_NN = min(1, numNonZero + numNonZero*threshold);

                %get the set of parameters and find their mean for each patch
               
                data_NN = trainedParams.NumNonZeroPixels;


                mask  = data_NN<=max_NN & data_NN>=min_NN;

                tempFiltered = trainedParams(mask,:);
                data_hs2 = tempFiltered.HeteroScore;

                mask1 = data_hs2<=max_hs & data_hs2>=min_hs;
                temp = tempFiltered(mask1,:);

                threshold = threshold + 0.01;


end

filtered_hs = temp;