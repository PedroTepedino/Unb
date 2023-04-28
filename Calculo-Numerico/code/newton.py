import numpy as np
import pandas as pd
from typing import Callable 

def newton_raphson(f : Callable, 
                   ff: Callable, 
                   x0 : float, 
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

    data = pd.DataFrame({'xk' : [x0], 'f(xk)': [f(x0)], '|xk - xk-1|': [abs(x0)] })
    for i in range(1, k) :
        aux = data['xk'][i - 1]
        x = aux - (f(aux) / ff(aux))
        newRow = {'xk' : x, 'f(xk)': f(x), '|xk - xk-1|': abs( x - aux ) }
        data = data._append(newRow, ignore_index = True)
        if abs(f(x)) < e1 or abs(x - aux) < e2:
            break
    
    print (data)

    return x

# F = lambda x: np.power(x, 3) - np.cos(x)
# FF = lambda x: 3 * np.power(x, 2) + np.sin(x)

# X = 0.5
# E = 1/np.power(10, 2)

# print (newton_raphson(F, FF, X, E))

