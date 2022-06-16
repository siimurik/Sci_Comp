import csv
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

data    = pd.read_csv("instat_temps.csv",header = None)
xydf    = pd.read_csv("instat_xy.csv", header = None)
Tmid_t_df  = pd.read_csv("Tmid_t.csv", header = None)
#print('\nAlgandmed\n',data.head())
origin = 'lower'
dim = len(data)
T = data.drop(data.columns[[dim]], axis=1)
#print('\nAlgandmed\n',T.head())
x_feat = xydf.drop(data.columns[[1]], axis=1).values
y_feat = xydf.drop(data.columns[[0]], axis=1).values
#print(x_feat.head())
Tmid = Tmid_t_df.drop(data.columns[[1]], axis=1).values
t    = Tmid_t_df.drop(data.columns[[0]], axis=1).values
#print(Tmid.tail().values)
#print(t.tail().values)
# Implementation of matplotlib function
Z = T.values
nx = len(T)
#print(Z)
#print(nx)
feature_x = np.linspace(0, 6, nx)
feature_y = np.linspace(0, 4, nx)
#print(feature_x)

# Creating 2-D grid of features
#[X, Y] = np.meshgrid(feature_x, feature_y)
[X, Y] = np.meshgrid(x_feat, y_feat)

fig1, ax1 = plt.subplots()
ax1.grid(True, which ="both")
ax1.semilogy(t, Tmid)
ax1.plot(t, Tmid)
ax1.set_title('Temperature variation with time at central node Implicit method')
ax1.set_xlabel('Time iterations')
ax1.set_ylabel('Temperature (K)')

fig2, ax2 = plt.subplots(constrained_layout=True)
CS = ax2.contourf(X, Y, Z, 10, origin=origin)

# Note that in the following, we explicitly pass in a subset of the contour
# levels used for the filled contours.  Alternatively, we could pass in
# additional levels to provide extra resolution, or leave out the *levels*
# keyword argument to use all of the original levels.

CS2 = ax2.contour(CS, levels=CS.levels[::1], colors='k', origin=origin, linewidths = 0.75)
ax2.clabel(CS2, fmt='%2.1f', colors='k', fontsize=10)

ax2.set_title('Temperature distribution')
ax2.set_xlabel('X (m)')
ax2.set_ylabel('Y (m)')

# Make a colorbar for the ContourSet returned by the contourf call.
cbar = fig2.colorbar(CS)
cbar.ax.set_ylabel('Temperature (K)')
# Add the contour line levels to the colorbar
cbar.add_lines(CS2)

plt.show()
