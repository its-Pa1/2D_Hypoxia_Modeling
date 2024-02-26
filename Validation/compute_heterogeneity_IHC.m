function [numNonZero, het_index] = compute_heterogeneity_IHC(BVimage)
% COMPUTE_HETEROGENEITY_IHC computes heterogeneity indices for IHC images.
%
% INPUT:
%   BVimage: IHC image matrix
%
% OUTPUT:
%   numNonZero: Ratio of non-zero elements to total pixels
%   het_index: Claramunt heterogeneity index


%%
% BVimage = BVimage(:,:,1);
% BVimage(BVimage<50) = 0;
grayscale = im2gray(BVimage);
mask22 = grayscale <= 50; % MAY be increase this
grayscale(mask22) = 0;
grayscale = medfilt2((grayscale));

test_bw = (imbinarize(grayscale,0));

totalPixels = (numel(im2gray(BVimage)));
%%


ConnectedComponent = bwconncomp(test_bw);
ROI_prop = regionprops(test_bw,'centroid','Area'); % ConnectedComponent or test_bw?
numPixels = cat(1,ROI_prop.Area);
centroids = cat(1,ROI_prop.Centroid);




%%


mask_cen1 = numPixels>5 & numPixels<50 ; % & numPixels2<50; % & numPixels2<200;
test_cen1 = centroids(mask_cen1,:);
test_out1 = centroids(~mask_cen1,:);



mask_cen2 = numPixels>=50 & numPixels<=100;
test_cen2 = centroids(mask_cen2,:);
test_out2 = centroids(~mask_cen2,:);

mask_cen3= numPixels>100 & numPixels<250;
test_cen3 = centroids(mask_cen3,:);
test_out3 = centroids(~mask_cen3,:);

mask_cen4= numPixels>=250 & numPixels<500;
test_cen4 = centroids(mask_cen4,:);
test_out4 = centroids(~mask_cen4,:);

mask_cen5= numPixels>=500;
test_cen5 = centroids(mask_cen5,:);
test_out5 = centroids(~mask_cen5,:);

%% intra-distances

dist_intra1 = pairwise_distance(test_cen1);
dist_intra2 = pairwise_distance(test_cen2);
dist_intra3 = pairwise_distance(test_cen3);
dist_intra4 = pairwise_distance(test_cen4);
dist_intra5 = pairwise_distance(test_cen5);


meanDist_intra1 = mean(dist_intra1);
meanDist_intra2 = mean(dist_intra2);
meanDist_intra3 = mean(dist_intra3);
meanDist_intra4 = mean(dist_intra4);
meanDist_intra5 = mean(dist_intra5);

%% extra-distance

dist_inter1 =  pairwise_distance(test_cen1,test_out1);
dist_inter2 =  pairwise_distance(test_cen2,test_out2);
dist_inter3 =  pairwise_distance(test_cen3,test_out3);
dist_inter4 =  pairwise_distance(test_cen4,test_out4);
dist_inter5 =  pairwise_distance(test_cen5,test_out5);

meanDist_inter1 = mean(dist_inter1);
meanDist_inter2 = mean(dist_inter2);
meanDist_inter3 = mean(dist_inter3);
meanDist_inter4 = mean(dist_inter4);
meanDist_inter5 = mean(dist_inter5);

%% number of non-zero elements


numNonZero = nnz(BVimage)/totalPixels;

%% 

sum_area1 = sum(numPixels(mask_cen1));
percentage_area1 = sum_area1/totalPixels;

sum_area2 = sum(numPixels(mask_cen2));
percentage_area2 = sum_area2/totalPixels;

sum_area3 = sum(numPixels(mask_cen3));
percentage_area3 = sum_area3/totalPixels;

sum_area4 = sum(numPixels(mask_cen4));
percentage_area4 = sum_area4/totalPixels;

sum_area5 = sum(numPixels(mask_cen5));
percentage_area5 = sum_area5/totalPixels;

%% Claramunt heterogenity
temp = ((meanDist_intra1/meanDist_inter1)*percentage_area1*log2(max(percentage_area1,1e-100)))...
    +  ((meanDist_intra2/meanDist_inter2)*percentage_area2*log2(max(percentage_area2,1e-100)))...
    +  ((meanDist_intra3/meanDist_inter3)*percentage_area3*log2(max(percentage_area3,1e-100)))...
    +  ((meanDist_intra4/meanDist_inter4)*percentage_area4*log2(max(percentage_area4,1e-100)))...
    +  ((meanDist_intra5/meanDist_inter5)*percentage_area5*log2(max(percentage_area5,1e-100)));

het_index = -temp;

end