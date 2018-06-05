# Creates 3 classes, Point, Line and Parallelogram.
# A point is determined by 2 coordinates (int or float).
# A line is determined by 2 distinct points.
# A parallelogram is determined by 4 distint lines,
# two of which having the same slope, the other two having the same slope too.
# The Parallelogram has a method, divides_into_two_parallelograms(), that determines
# where a line, provide as arguments, can split the object into two smaller parallelograms.
#
# Written by Jt Li for COMP9021


from collections import defaultdict


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def __eq__(self,other):
        return self.x == other.x and self.y == other.y
        

class Line:
    def __init__(self, pt_1, pt_2):
        self.pt_1 = Point(pt_1.x, pt_1.y)
        self.pt_2 = Point(pt_2.x, pt_2.y)
        if self.pt_1 == self.pt_2:
            print('Cannot create line')
            self.exist = False
        else:
            self.exist = True 
            if not self.pt_1.x == self.pt_2.x:
                self.k =(self.pt_1.y-self.pt_2.y)/(self.pt_1.x-self.pt_2.x)
                self.line = (self.k, self.pt_2.y-self.k*self.pt_2.x)
                
            else:
                self.k = float('inf')
                self.line = (self.k,self.pt_1.x)
               
class Parallelogram:
    def __init__(self,line1,line2,line3,line4):
        self.line1 = Line(line1.pt_1,line1.pt_2)
        self.line2 = Line(line2.pt_1,line2.pt_2)
        self.line3 = Line(line3.pt_1,line3.pt_2)
        self.line4 = Line(line4.pt_1,line4.pt_2)
        if self.line1.exist and self.line2.exist and self.line3.exist and self.line4.exist:
            k2 = []
            k1 = []
            line=set()
            line.add(self.line1.line), k1.append(self.line1.k),k2.append(self.line1.line)
            line.add(self.line2.line), k1.append(self.line2.k),k2.append(self.line2.line)
            line.add(self.line3.line), k1.append(self.line3.k),k2.append(self.line3.line)
            line.add(self.line4.line), k1.append(self.line4.k),k2.append(self.line4.line)
            self.k = sorted(k2)
        else:
            print('Cannot create parallelogram')
            self.exist = False
        if len(line) == 4:
            for i in k1:
                if k1.count(i) != 2:
                    print('Cannot create parallelogram') 
                    self.exist = False
                    break
                else:
                    self.exist = True 
        else:
            print('Cannot create parallelogram')
            self.exist = False 
    def divides_into_two_parallelograms(self, line):
        if self.exist:
            if line.k == self.k[0][0]:
                if line.line[1] > self.k[0][1] and line.line[1] < self.k[1][1]:
                    return True 
            elif line.k == self.k[2][0]:
                if line.line[1] > self.k[2][1] and line.line[1] < self.k[3][1]:
                    return True
        return False 
        
        
        
    
