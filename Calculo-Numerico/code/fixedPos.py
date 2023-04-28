
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

for i in range(0, 100):
    x0 = ((a * f(b)) - (b * f(a))) / (f(b) - f(a))

    fx = f(x0)

    if fa < 0:
        if fx < 0 :
            a = x0
            fa = fx
        elif fx > 0 :
            b = x0
            fb = fx 
    elif fa > 0:
        if fx < 0 :
            b = x0
            fb = fx
        elif fx > 0 :
            a = x0
            fa = fx
    else:
        print("Erro")

    # print(f"{x0}")
    print(f"{i + 1} : [{a}, {b}] ==> {(a + b) / 2} ==> f: {f(x0)} ==> e: {b - a}")
    if abs(b - a) < e1 or abs(f(x0)) < e2:
        break