# Randomly fills an array of size 10x10 with 0s and 1s, and outputs the number of blocks
# in the largest block construction, determined by rows of 1s that can be stacked
# on top of each other. 
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


def size_of_largest_construction():
    lis = grid[::-1]
    block_list = [ ]
    for i in range(len(lis)):
        for k in range(len(lis[i])):
            if lis[i][k]>0:
                b_n = 0
                y = i 
                while lis[y][k] >0:
                    b_n +=1
                    y +=1
                    if y == 10:
                        break
                if k!=0:
                    if lis[i][k-1] >0:
                        block_list[-1] +=b_n
                    else:
                        block_list.append(b_n)
                else:
                    block_list.append(b_n)
                    
                
            else:
                block_list.append(0)
                
            
            
    return max(block_list)
                
        
   

try:
    for_seed, n = [int(i) for i in
                           input('Enter two integers, the second one being strictly positive: ').split()]
    if n <= 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(for_seed)
grid = [[randrange(n) for _ in range(dim)] for _ in range(dim)]

print('Here is the grid that has been generated:')
display_grid()
print('The largest block construction has {} blocks.'.format(size_of_largest_construction()))  
