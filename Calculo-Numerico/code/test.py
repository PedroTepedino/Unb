from secant import secant
from newton import newton_raphson

import numpy as np

f = lambda x: (np.power(x, 3)) - (6 * x)  + 2
ff = lambda x: (3 * np.power(x, 2)) - 6

e = 0.00001
k = 100

x0 = -3
x1 = 0

print ('Newton-Raphson')
n = newton_raphson(f, ff, x1, e, k= k)
# print('\nSecant')
# s = secant(f, x0, x1, e, k = k)

print()
print(f'newton -> {n}')
# print(f'secant -> {s}')
