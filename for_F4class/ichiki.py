# %%
from cmath import pi
import numpy as np
import math
import scipy.integrate as integrate
import matplotlib.pyplot as plt
import time

# %%

# 定数
myu_0 = 1.256637e-6
J = 3  # ?

# Magnetized bodyの中心位置
Mx, My, Mz = 0, 0, 0  # [m]

# %%

# Singe dipole moment source : Directive cosine
SD_theta = np.radians(50)  # degrees
SD_phi = np.radians(-8)  # degrees
L, M, N = np.sin(SD_theta)*np.cos(SD_phi), \
    np.sin(SD_theta)*np.sin(SD_phi), np.cos(SD_theta)


# Main field : Directive cosine
MD_theta = np.radians(50)  # degrees
MD_phi = np.radians(-8)  # degrees
l, m, n = np.sin(MD_theta)*np.cos(MD_phi), \
    np.sin(MD_theta)*np.sin(MD_phi), np.cos(MD_theta)


# %%
print(L, M, N)
print(l, m, n)
# %%
alpha11 = 2*L*l - M*m - N*n
alpha22 = 2*M*m - N*n - L*l
alpha33 = 2*N*n - L*l - M*m
alpha12 = M*l + L*m
alpha13 = N*l + L*n
alpha23 = N*m + M*n

# %%


# %%
# Tb([1, 2, 3], [2, 3, 4])


# %%

def F(x, y):

    def Tb(a, b, c):

        A = a - x
        B = b - y
        C = c

        R = np.sqrt(A**2 + B**2 + C**2)

        Tb = alpha23/2*np.log((R-A)/(R+A)) \
            + alpha13/2*np.log((R-B)/(R+B)) \
            - alpha12*np.log(R+C) \
            - L*l*np.arctan2(A*B, (A**2+R*C+C**2)) \
            - M*m*np.arctan2(A*B, (B**2+R*C+C**2)) \
            - N*n*np.arctan2(A*B, R*C)

        return Tb
    T = 0

    for c in range(100, 300, 4):

        for b in range(-int(np.sqrt(400*c-30000-c*c)), int(np.sqrt(400*c-30000-c*c)), 4):
            for a in range(-int(np.sqrt(400*c-30000-c*c-b*b)), int(np.sqrt(400*c-30000-c*c-b*b)), 4):
                T += Tb(a+4, b+4, c+4) - Tb(a, b+4, c+4) - Tb(a+4, b, c+1) - Tb(a+4,
                                                                                b+4, c) + Tb(a+4, b, c) + Tb(a, b+4, c) + Tb(a, b, c+4) - Tb(a, b, c)
    return T


# errorを吐く、、、0に近い値が出るのでそれっぽい値を使っていることろがあるって内容らしい

# %%

xx = np.arange(-10000, 10000, 100)
yy = np.arange(-10000, 10000, 100)
xxx, yyy = np.meshgrid(xx, yy)

F_all = F(xxx, yyy)

# %%
plt.pcolormesh(xxx, yyy, F_all)
plt.show()
