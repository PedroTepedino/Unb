import numpy as np

def f(x):
    # return (x * np.exp(x)) -1 
    return ( x * x * x ) - ( 2 * x * x ) - ( 20 * x ) + 30

e = 0.000001
a = 1.3
b = 4.8

fa = f(a)
fb = f(b)

for i in range(0, 100):
    x0 = (a + b) / 2.0

    fx = f(x0)

    if fa < 0:
        if fx < 0 :
            a = x0
            fa = fx
        elif fx > 0 :
            b = x0
            fb = fx
    else:
        if fx < 0 :
            b = x0
            fb = fx
        elif fx > 0 :
            a = x0
            fa = fx

    print(f"{x0}")
    # print(f"{i} : [{a}, {b}] ==> {(a + b) / 2} ==> e: {b - a} ==> {b - a < e}")
    # if b - a < e:
        # break
