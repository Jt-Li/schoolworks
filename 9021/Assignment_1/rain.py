import sys
try:
    f = open(input("Which data file do you want to use?"), 'r')
    rain =int(input("How many decilitres of water do you want to pour down?"))
    if rain < 0:
        raise FileNotFoundError
    
except FileNotFoundError:
    print('Incorrect input, giving up.')
    sys.exit()
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
    

num_list=[]
for line in f:
    line=line.strip()
    for item in line.split():
        num_list.append(int(item))
num_list.sort()
num_dict={}
for i in num_list:
    num_dict[i]=num_list.count(i)



key_list=list(num_dict.keys())
value_list=list(num_dict.values())

while rain >= (key_list[1]-key_list[0])*value_list[0]:
    num_dict[key_list[1]] +=value_list[0]
    del num_dict[key_list[0]]
    rain -=(key_list[1]-key_list[0])*value_list[0]
    key_list=list(num_dict.keys())
    value_list=list(num_dict.values())
    if len(key_list) == 1:
        break

left = 0
if rain>0:
    left = rain/value_list[0]


print("The water raise to ", round(key_list[0]+left,2),  " centimetres.")




