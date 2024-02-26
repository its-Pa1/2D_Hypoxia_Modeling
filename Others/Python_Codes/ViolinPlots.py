# Figure 8a, 8b & S3
# This python scrips generates the violin plots to show the distribution of the trained paramters and 
# the sorted parameters for two patches.

import numpy as np
# import matplotlib
# matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns
import time

from sklearn import datasets, decomposition, manifold, preprocessing
from colorsys import hsv_to_rgb

import umap

import pandas as pd
from matplotlib.colors import LogNorm, to_hex, Normalize

import matplotlib.colors as mpl_colors
import matplotlib.cm as cm

from sklearn.cluster import KMeans

from scipy.stats import gaussian_kde # Import function for gaussian kernel density estimation
from scipy.stats import multivariate_normal

import glob
from pathlib import Path


# load the data
fileNames = ['selectedParams_IHC_patch2',    'All_Params','selectedParams38']

# Loop through each character in the array
for files in fileNames:
                fullFileName = files + '.csv'
                data = pd.read_csv(fullFileName) # 38 
                df = pd.DataFrame(data) 
                # get the head
                df.head()
                # export the file
                #df2.to_csv('All_Params_Sorted.csv', sep='\t')

                # drop the intervals

                df2 = df.drop(['SampleName','D_int_1', 'alpha_int_1','beta_int_1','gamma_int_2', 'Ol_int_1', 'Oh_int_1', 'k1_int_1',
                                'D_int_2', 'alpha_int_2','beta_int_2','gamma_int_1', 'Ol_int_2', 'Oh_int_2', 'k1_int_2','loss','loss_worst','dx','NumNonZeroPixels' ],axis=1)
                # for the violin plot

                # fontsize = 10
                labels = [r'$D$', r'$\alpha$', r'$\beta$', r'$\gamma$', r'$k_1$', r'$O_l$', r'$O_h$', r'$H_s$']
                colors = sns.color_palette("Set1", n_colors=len(labels))

                fig, axes = plt.subplots(figsize=(10,8))
                fig.suptitle('Parameter Variation',fontsize=20)
                fig.supxlabel('Parameters',fontsize=20)
                fig.supylabel('Values',fontsize=20)
                # plot violin. 'Scenario' is according to x axis, 
                # 
                sns.violinplot(data=df2.iloc[:,0:8], ax = axes, cut=0, scale="width", palette=colors, alpha=0.7)
                plt.yscale('log')
                #plt.yscale('symlog', linthresh=0.01)
                # axes.yaxis.grid(True)
                yticks_exponents = [-4, -2, 0, 2, 4, 6, 8, 10]
                yticks_values = [10**exp for exp in yticks_exponents]
                plt.yticks(yticks_values, [fr'$10^{{{exp}}}$' for exp in yticks_exponents])


                plt.tick_params(labelsize=20)
                plt.xticks(range(len(labels)), labels)


                plt.tight_layout()
                #

                plt.tight_layout()
                saveFileName = files + '.eps'
                plt.savefig(saveFileName,bbox_inches = 'tight')
                plt.show()





