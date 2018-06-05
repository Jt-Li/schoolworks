# Randomly fills an array of size 10x10 with 0s and 1s, and
# outputs the number chess knights needed to jump from 1s to 1s
# and visit all 1s (they can jump back to locations previously visited).
#
# Written by Jt Li and Eric Martin for COMP9021


from random import seed, randrange
import sys


dim = 10


def display_grid():
    for i in range(dim):
        print('    ', end = '')
        for j in range(dim):
            print(' 1', end = '') if grid[i][j] else print(' 0', end = '')
        print()
    print()


def explore_board():
    position_1=[]
    result=[]
    out = 0
    for i in range(10):
        for j in range(10):
            if grid[i][j]:
                position_1.append([i,j])
    def fun(position_1):
        for i in position_1:
            add = []
            for j in position_1:
                          if (abs(i[0]-j[0])==2 and abs(i[1]-j[1])==1):
                              add.append(j)
                              position_1.remove(j)
                          elif (abs(i[0]-j[0])==1 and abs(i[1]-j[1])==2):
                              add.append(j)
                              position_1.remove(j)
            if add:
                for i in range(2):
                    for k in add:
                       for y in position_1:
                              if (abs(k[0]-y[0])==2 and abs(k[1]-y[1])==1):
                                  add.append(y)
                                  position_1.remove(y)
                              elif (abs(k[0]-y[0])==1 and abs(k[1]-y[1])==2):
                                  add.append(y)
                                  position_1.remove(y)
             
                result.append(add)
            else:
                result.append(i)
                position_1.remove(i)
        return len(result)
    while position_1:
        out = fun(position_1)
  
    return out
                              
                                           
                               
try:
    for_seed, n = [int(i) for i in
                           input('Enter two integers: ').split()]
    if not n:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(for_seed)
grid = [[None] * dim for _ in range(dim)]
if n > 0:
    for i in range(dim):
        for j in range(dim):
            grid[i][j] = randrange(n) > 0
else:
    for i in range(dim):
        for j in range(dim):
            grid[i][j] = randrange(-n) == 0
print('Here is the grid that has been generated:')
display_grid()
nb_of_knights = explore_board()
if not nb_of_knights:
    print('No chess knight has explored this board.')
else:
    print('At least {} chess'.format(nb_of_knights), end = ' ')
    print('knight has', end = ' ') if nb_of_knights == 1 else print('knights have', end = ' ')
    print('explored this board.')

