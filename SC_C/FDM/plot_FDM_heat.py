import csv
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv("Temp_data.csv",header = None)
xydf = pd.read_csv("xy.csv", header = None)
#print('\n Initial data\n',data.head())
origin = 'lower'
dim = len(data)
#print("dim =", dim)
T = data.drop(data.columns[[dim]], axis=1)
#print('\n Initial data\n',T.head())
x = np.linspace(0, 6, dim)
y = np.linspace(0, 4, dim)
#print(x_feat.head())
#print(x_feat.tail())
Z = T.values
#print(Z)
nx = len(T)
#print(nx)
# Creating 2-D grid of features
[X, Y] = np.meshgrid(x, y)
# Implementation of matplotlib function
fig1, ax2 = plt.subplots(constrained_layout=True)
CS = ax2.contourf(X, Y, Z, 10, origin=origin)

CS2 = ax2.contour(CS, levels=CS.levels[::1], colors='k', origin=origin, linewidths = 0.75)
ax2.clabel(CS2, fmt='%2.1f', colors='k', fontsize=10)

ax2.set_title('Temperature distribution')
ax2.set_xlabel('X (m)')
ax2.set_ylabel('Y (m)')

# Make a colorbar for the ContourSet returned by the contourf call.
cbar = fig1.colorbar(CS)
cbar.ax.set_ylabel('Temperature (K)')
# Add the contour line levels to the colorbar
cbar.add_lines(CS2)

plt.show()
