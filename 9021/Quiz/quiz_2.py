# Implements coding and decoding functions for pairs of integers.
# For coding, start at point (0, 0), move to point (1, 0), and turn
# around in an anticlockwise manner.
#
# Written by Jt Li for COMP9021


from math import sqrt

def encode(a, b):
    r = max(abs(a),abs(b))
    k =r-1
    rt = 0
    while k >0 :
        rt +=8*k
        k -=1
    if sqrt(a**2+b**2) == sqrt(2*(r**2)):
        if a>0 and b>0:
            return rt+2*r
        elif a<0 and b>0:
            return rt+4*r
        elif a<0 and b<0:
            return rt+6*r
        else:
            return rt+8*r
    else:
        if a == r and b>=0:
            return rt+2*r-(r-b)
        if a == r and b<0:
            return rt+2*r-r-abs(b)
        if b == r and a>=0:
            return rt+2*r+(r-a)
        if b == r and a<0:
            return rt+2*r+r+abs(a)
        if a == -r and b>=0:
            return rt+4*r+(r-b)
        if a == -r and b<0:
            return rt+4*r+r+abs(b)
        if b == -r and a<=0:
            return rt+6*r+(r+a)
        if b == -r and a>0:
            return rt+6*r+r+a
        
def decode(n):
    if n<0:
        return "Please enter a positive number!"
    elif n == 0:
        return (0,0)
    r = 0
    rt = 0
    while n>rt :
        rt +=8*r
        r +=1
    k = r-1
    if n == rt and n!=0:
        return (k,-k)
    elif n == 0:
        return (0,0)
    
    y = -k+1
    x = k 
    result = encode(x,y)
    while n > result and y < k:
        y +=1
        result = encode(x,y)
    while n > result:
        if x==-k:
            break 
        x -= 1
        result =encode(x,y)
        
    while n > result:
        if y ==-k:
            break
        y -=1
        result = encode(x,y)
    while n > result:
        if x == k:
            break
        x +=1
        result = encode(x,y)
    return (x, y) 


        
        
        
    
    
    
    
    
        
    



    

