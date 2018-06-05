import sys
try:
    f = open(input("Which data file do you want to use?"),"r")

except FileNotFoundError:
    print('Incorrect input, giving up.')
    sys.exit()

content=[]
for line in f:
    line = line.strip()
    tem_con = [ ]
    for item in line.split():
        tem_con.append([[item],1])
    content.append(tem_con)
    

def summ(tu):
    cont = 0
    for i in tu:
        cont +=int(i)
    return cont
    
def solve(tri):
    
    while len(tri) > 1:
        t0 = tri.pop()
        t1 = tri.pop()
        t3 = [ ]
        for i in range(len(t1)):
            if summ(t0[i][0]) > summ(t0[i+1][0]):
                tu = t1[i][0] + t0[i][0]
                time = t0[i][1]
                out = [tu,time]
            elif summ(t0[i][0]) == summ(t0[i+1][0]):
                tu = t1[i][0] + t0[i][0]
                time = t0[i][1]+t0[i+1][1]
                out = [tu,time]
                
            else:
                tu = t1[i][0] + t0[i+1][0]
                time = t0[i+1][1]
                out = [tu,time]
            t3.append(out)
        tri.append(t3)
    largest = summ(tri[0][0][0])
    left_path = []
    num_path = tri[0][0][1]
    for i in tri:
        for k in i:
            for y in k[0]:
                left_path.append(int(y))
    
                
    return largest, num_path, left_path

largest, num_path, left_path=solve(content)
print("The largest sum is: ", largest)
print("The number of the paths yielding this sum is: ", num_path)
print("The leftmost path yielding this sum is: ", left_path)



