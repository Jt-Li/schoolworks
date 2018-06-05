import copy
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
        tem_con.append(int(item))
    content.append(tem_con)
total = 0
for i in content:
    total +=i[1]
maxi=int(total/len(content))
mini = 0
mid = int((maxi+mini)/2)




while True:
    content1 = copy.deepcopy(content)
    for i in range(len(content1)-1):
        if content1[i][1] > mid:
            rest =content1[i][1]-mid
            content1[i][1] -= rest
            trans = rest-(content1[i+1][0]-content1[i][0])
            if trans >0:
                content1[i+1][1] +=trans
            else:
                content1[i+1][1] +=0
        else:
            need = mid -content1[i][1]
            content1[i][1] += need
            content1[i+1][1] -=need+(content1[i+1][0]-content1[i][0])
    if content1[-1][-1] == mid:
        print("The maximun quantity of fish that each town can have is ", mid)
        break
    elif content1[-1][-1] > mid:
        mini = mid
        mid = int((maxi+mini)/2)
    else:
        maxi= mid
        mid = int((maxi+mini)/2)
    if maxi - mini ==1:
        print("The maximun quantity of fish that each town can have is ",mid)
        break
    
        
   


            
    
    
    


            
            
    
        

        
