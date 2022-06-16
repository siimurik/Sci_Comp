# Amdahl's law
#
# Siim Erik Pugal
#===============================================================================
import numpy as np
import matplotlib.pyplot as plt

def S(p,n):
    S = 1.0/( (1.0-p) + (p/n) )
    return S

n = np.arange(1,4096,1)
p = np.array([0.1, 0.25, 0.5, 0.75, 0.95])
labels = ['10%', '25%', '50', '75%', '95%']

fig = plt.figure()
ax = fig.add_subplot(111)
for i in range(len(p)):
    #ax.plot(n, S(p[i],n), label=labels[i])
    ax.semilogy(n, S(p[i],n), label=labels[i])

ax.set_title("Amdahl's law")
ax.set_xlabel('Number of processors')
ax.set_ylabel('Speedup')
plt.grid()
plt.legend()
plt.show()
