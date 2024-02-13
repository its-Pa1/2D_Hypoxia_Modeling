# Figure 7
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd



def pyramid_plot(arr1, arr2):
    """
    Create a pyramid plot for two arrays of any size based on their values.

    Parameters:
    - arr1: NumPy array or list, first array to be compared.
    - arr2: NumPy array or list, second array to be compared.
    """

    # Convert lists to NumPy arrays if needed
    arr1 = np.array(arr1)
    arr2 = np.array(arr2)

    # Check if arrays have the same length
    if len(arr1) != len(arr2):
        raise ValueError("Arrays must have the same length for comparison.")
    

    plt.rcParams.update({'font.size': 16})


    # Plotting
    plt.figure(figsize=(18, 10))

    # Pyramid chart with color differentiation
    plt.barh(
        y=np.arange(1, len(arr1) + 1),
        width=arr1,
        color='blue',  # Color for Array A
        label='Loss Worst'
    )
    plt.barh(
        y=np.arange(1, len(arr2) + 1),
        width=arr2,
        color='orange',  # Color for Array B
        label='Loss'
    )

    # Style the plot
    plt.title('Comparison of Loss Function Values')
    plt.xlabel('Values')
    plt.ylabel('Patch Number')
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.5)

    # Set x-axis to log scale
    plt.xscale('symlog', linthresh=0.01)

    # Adjust x-axis and y-axis limits to make the plot more compact
    plt.xlim(left=0.01)
    plt.ylim(bottom=0.5, top=len(arr1) + 0.5)

    #plt.show()
    plt.tight_layout

    plt.savefig('loss_compare.eps')
    
    





# Generate random arrays A and B
np.random.seed(42)  # For reproducibility
n = 50
arrA = np.random.uniform(1, 50, size=n)
arrB = np.abs(np.random.uniform(1, 10, size=n))  # Ensure positive values for Array B

# Create pyramid plot
pyramid_plot(arrA, arrB)




myData = pd.read_csv('All_Params.csv')




loss = myData.loss
loss_w = myData.loss_worst

myarr1 = loss
myarr2 = loss_w

pyramid_plot(myarr2, myarr1)