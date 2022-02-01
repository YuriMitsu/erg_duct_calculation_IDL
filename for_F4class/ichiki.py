# %%
from cmath import pi
import numpy as np
import math
import scipy.integrate as integrate
import matplotlib.pyplot as plt
import time

# %%

# 定数
myu_0 = 1.256637e-6  # [m kg s-2 A-2]
J = 3  # [A/m]
V = 4 / 3 * np.pi * 100**3  # Magnetized body の体積 [m3]
p = V * J  # [m3]*[A/m]=[m2A]

# Magnetized bodyの中心位置
Mx, My, Mz = 0, 0, 200  # [m]

# Singe dipole moment source : Directive cosine
SD_theta = np.radians(50)  # degrees 50 or 50+180
SD_phi = np.radians(-8)  # degrees -8 or -8+180
L, M, N = np.sin(SD_theta)*np.cos(SD_phi), \
    np.sin(SD_theta)*np.sin(SD_phi), np.cos(SD_theta)


# Main field : Directive cosine
MD_theta = np.radians(50)  # degrees
MD_phi = np.radians(-8)  # degrees
l, m, n = np.sin(MD_theta)*np.cos(MD_phi), \
    np.sin(MD_theta)*np.sin(MD_phi), np.cos(MD_theta)

# %%

# total magnetic field


def F(x, y, z=0):  # [nT]で出力

    a, b, c = Mx, My, Mz

    r = np.sqrt((x-a)**2 + (y-b)**2 + (z-c)**2)

    alpha11 = 2*L*l - M*m - N*n
    alpha22 = 2*M*m - N*n - L*l
    alpha33 = 2*N*n - L*l - M*m
    alpha12 = M*l + L*m
    alpha13 = N*l + L*n
    alpha23 = N*m + M*n

    # [m kg s-2 A-2]*[m2 A]/[m5]=[kg s-2 A-1 m-2]
    F1 = (myu_0 * p) / (4 * np.pi * r**5)
    F2 = (alpha11*(x-a)**2 + alpha22*(y-b)**2 + alpha33 + 3*alpha12*(x-a)*(y-b)
          + 3*alpha13*(x-a)*(z-c) + 3*alpha23*(y-b)*(z-c))  # [m2]
    F = F1 * F2  # [kg s-2 A-1 m-2]*[m2]=[kg s-2 A-1]
    F /= 1e-9

    return F


# %%
# plot figure
xx = np.arange(-1000, 1000, 10)
yy = np.arange(-1000, 1000, 10)
xxx, yyy = np.meshgrid(xx, yy)

F_all = F(xxx, yyy)

# %%
plt.figure(figsize=(6, 5))
plt.pcolormesh(xxx, yyy, F_all, cmap="jet") # cmap名を変えるとカラーが変わるよ！
plt.xlabel('x [m]')
plt.ylabel('y [m]')
cbar = plt.colorbar()
cbar.set_label('Total magnetic field [nT]', rotation=270)

plt.contour(xxx, yyy, F_all, colors=['white'], levels=20, linewidths=1)

plt.savefig('IchikiHomework_Ampuku.png')  # 図を保存したい名前を記入
plt.show()

# %%
