
import numpy as np

def f(x):
    # return (x * np.exp(x)) -1 
    # return ( x * x * x ) - ( 2 * x * x ) - ( 20 * x ) + 30
    # return (x * x) - 7
    return np.exp(x) - (3 * x)

e1 = 1 / 100
e2 = 1 / 1000000
a = 0
b = 1.0

fa = f(a)
fb = f(b)

# loop de iteracao
for i in range(0, 100):
    x_0 = ((a * f(b)) - (b * f(a))) / (f(b) - f(a))

    f_x = f(x_0)

    if fa < 0:
        if f_x < 0 :
            a = x_0
            fa = f_x
        elif f_x > 0 :
            b = x_0
            fb = f_x
    else:
        if f_x < 0 :
            b = x_0
            fb = f_x
        elif f_x > 0 :
            a = x_0
            fa = f_x

    # print(f"{x_0}")
    print(f"{i + 1} : [{a}, {b}] ==> {(a + b) / 2} ==> f: {f(x_0)} ==> e: {b - a}")
    if abs(b - a) < e1 or abs(f(x_0)) < e2:
        break