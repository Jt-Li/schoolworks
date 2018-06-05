# Prompts the user for two nonnegative integers, generates a list L of random numbers
# between 0 and 19, of length the second input, outputs L, and outputs L again where
# all elements have been rearranged so that L is now of the form L_1 L_2 ... L_k and:
# - * L_1 starts with the first element of L,
#   * L_2 starts with the first element of L with all elements of L_1 removed,
#   ...
#   * L_k starts with the first element of L with all elements of L_1, ..., L_{k-1} removed;
# - * L_1 is a stricly increasing subsequence of L of longest possible length,
#   * L_1 is a stricly increasing subsequences of L with all elements of L_1 removed
#     of longest possible length,
#   ...
#   * L_k is a stricly increasing subsequences of L with all elements of L_1, ..., L_{k-1} removed
#     of longest possible length.
#
# Written by *** and Eric Martin for COMP9021


import sys
from random import seed, randint


max_value = 19

try:
    arg_for_seed, length = input('Enter two nonnegative integers: ').split()
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
try:
    arg_for_seed, length = int(arg_for_seed), int(length)
    if arg_for_seed < 0 or length < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(arg_for_seed)
L = [randint(0, max_value) for _ in range(length)]
print('The generated list is:')
print('  ', L)

nl=[ ]
nl.append(L.pop(0))
i = 0
length = len(L)
while L != [ ]:
    if nl[i]<L[0]:
        nl.append(L.pop(0))
    else:
        x = 1
        while L[x] < nl[i] and nl[i] <= max(L):
            x +=1
        if L[x] != nl[i]:
            nl.append(L.pop(x))
        elif L[x] == nl[i] :
            nl.append(L.pop(0))
    i +=1
    if nl[i] >max(L):
        nl.append(L.pop(0))
        i +=1
    if i == length-1:
        nl.append(L.pop(0))
    print("l", L)
    print("nl", nl)
        
    


        
        
        
    
##nl.append(L.pop(0))
##k = i+1
##while max(L) > nl[k]:
##    if nl[k]<L[0]:
##        nl.append(L.pop(0))
##    else:
##        x = 1
##        while L[x] < nl[k] :
##            x +=1
##        nl.append(L.pop(x))
##    k +=1
##print(nl)
    
    
    

##
##print('The transformed list is:')
##print('  ', L)
