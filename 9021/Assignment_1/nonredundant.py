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
    content.append(line)

dic={}
for i in content:
    k,y=i.split(",")
    num1=int(k.split("(")[1])
    num2=int(y.split(")")[0])
    if num2 not in dic:
        dic[num2] =[num1]
    else:
        dic[num2].append(num1)

key = list(dic.keys())


for i in key:
    if len(dic[i]) >1:
        for e in dic[i]:
            if e in dic:
                path = copy.deepcopy(dic[e])
                for k in range(len(path)):
                    if path[k] in dic:
                        path += dic[path[k]]
                for t in path:
                    if t in dic[i]:
                        dic[i].remove(t)
                        

out_list=[]
for i in key:
    for k in dic[i]:
        text ='R('+str(k)+","+str(i)+")"
        out_list.append(text)


print("The nonredundant facts are:")    
for i in content:
    if i in out_list:
        print(i)
     
        
    
        
    
            
                
                
                    
                    

    
