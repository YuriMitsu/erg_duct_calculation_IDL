# %%
import numpy as np
# from sympy import integrate
import scipy.integrate as integrate


# 定数
myu_0 = 1.2
J = 3  # ?

# Magnetized bodyの中心位置
Mx, My, Mz = 0, 0, 200  # [m]

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


def F(X):

    x, y, z = X

    def Tb(a, b, c=0):

        # a, b, c = Xa

        A = a - x
        B = b - y
        C = c - z

        R = np.sqrt(A**2 + B**2 + C**2)

        Tb = alpha23/2*np.log((R-A)/(R+A)) \
            + alpha13/2*np.log((R-B)/(R+B)) \
            - alpha12*np.log(R+C) \
            - L*l*np.arctan(A*B / (A**2+R*C+C**2)) \
            - M*m*np.arctan(A*B / (B**2+R*C+C**2)) \
            - N*n*np.arctan(A*B / R*C)

        return Tb

    Tb_integrate, err = integrate.dblquad(
        Tb, -1000, 1000, lambda x: -1000, lambda x: 1000)

    F = (myu_0*J) / (4*np.pi) * Tb_integrate

    # return Tb_integrate, err
    return F


# %%
F([1, 2, 3])
# errorを吐く、、、0に近い値が出るのでそれっぽい値を使っていることろがあるって内容らしい

# %%
