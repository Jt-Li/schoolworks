# Code for insertion into a priority queue
# implemented as a binary tree
#
# Written by Jt for COMP9021


from binary_tree import *
from math import log
import copy

orders=[None]
i=0

class PriorityQueue(BinaryTree):
    def __init__(self):
        super().__init__()

    def insert(self, value):
        global i
        global orders
        i +=1
        temp=PriorityQueue()
        temp.value=value
        temp.left_node=PriorityQueue()
        temp.right_node=PriorityQueue()
        orders.append(temp)
        position = i 
        while position >1 and orders[position].value < orders[position//2].value:
            orders[position//2],orders[position] = orders[position], orders[position//2]
            position //= 2
        for k in orders[1:]:
            k.left_node=PriorityQueue()
            k.right_node=PriorityQueue()
            
        for k in range(1,len(orders)):
            if k*2 < len(orders):
                orders[k].left_node = orders[k*2]
            if k*2+1 < len(orders):
                orders[k].right_node = orders[k*2+1]
        self.right_node=PriorityQueue()
        self.left_node=PriorityQueue()
        self.value = 100
        self.left_node= copy.deepcopy(orders[1])
        self.delete_in_bst(100)
      
        
       


 




                

            
        
        



























        
