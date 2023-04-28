import numpy as np
import pandas as pd
from typing import Callable 

def secant(f : Callable, 
                   x0: float,
                   x1: float, 
                   e1: float = -1, 
                   e2: float = -1,
                   k: int = -1):
    if e1 < 0:
        e1 = 1/100
    if e2 < 0:
        e2 = e1
    if k < 0:
        k = 100
    x = 0

    data = pd.DataFrame({'xk' : [x0, x1], 'f(xk)': [f(x0), f(x1)], '|xk - xk-1|': [abs(x0), abs(x0 - x1)] })
    
    for i in range(2, k) :
        xk = data['xk'][i - 1]
        xkk = data ['xk'][i - 2]
        x = ((xkk * f(xk)) - (xk * f(xkk))) /  (f(xk) - f(xkk))
        newRow = {'xk' : x, 'f(xk)': f(x), '|xk - xk-1|': abs( x - xk ) }
        data = data._append(newRow, ignore_index = True)
        if abs(f(x)) < e1 or abs(x - xk) < e2:
            break
    
    print (data)

    return x

# F = lambda x: np.power(x, 3) - np.cos(x)

# X0 = 0
# X1 = 1
# E = 1/np.power(10, 2)

# print (newton_raphson(F, X0, X1, E))

