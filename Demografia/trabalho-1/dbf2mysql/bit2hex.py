#!/usr/bin/python

# import sys

# for i in range(1, len(sys.argv)):
#     print (hex(int(f'{sys.argv[i]}', 2)))

bits = list(range(0x00, 0x100))

for i in bits:
    # print(f'{i:#0{4}X}, {int((format(i, "b").zfill(8))[::-1], 2):#0{4}X}')
    # print(f'{int((format(i, "b").zfill(8))[::-1], 2):#0{4}X}', end = ", ")
    print(f'\"{format(i, "b").zfill(8)}\"', end = ", ")
    if (i + 1) % 8 == 0:
        print()
