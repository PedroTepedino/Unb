numbers = [1,1]

def fib(n : int):
    if len(numbers) <= n:
        numbers.append(fib(n - 1) + fib (n - 2))
    return numbers[n]
    

print(numbers)
for i in range(0, 2000):
        print (fib (i))
