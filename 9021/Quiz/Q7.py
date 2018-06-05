# Written by Jt Li for COMP9021

from linked_list import *

class ExtendedLinkedList(LinkedList):
    def __init__(self, L = None):
        super().__init__(L)

    def rearrange(self):
        length = 0
        node = self.head
        while node:
            length += 1
            node = node.next_node
        if length == 0:
            return
        if length == 1:
            return self
        if length == 2:
            return self.reverse()
        i = int(length /2)
        k = i-1
        y = i+1
        t = 3
        ll=LinkedList()
        ll.append(self.value_at(i))
        ll.append(self.value_at(k))
        ll.append(self.value_at(y))
        while t < length:
            if self.value_at(k-1):
                ll.append(self.value_at(k-1))
            if self.value_at(y+1):
                ll.append(self.value_at(y+1))
            k -=1
            y +=1
            t +=2
        current_node = self.head
        change_node = ll.head
        for i in range(length):
            current_node.value = change_node.value
            current_node = current_node.next_node
            change_node = change_node.next_node
            
            
            
            
       
    
    
    
