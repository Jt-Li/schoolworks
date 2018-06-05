##Assignment 3
##Jt Li
import re
import copy


##Read TXT
##Add all words into list
all_word=[ ]
with open(input('Which text file do you want to use for the puzzle?'),'r') as f:
    for line in f:
        line = line.strip()
        for char in line.split():
            all_word.append(char)


##Add sentence by sentence into a list
temp=''
sentences=[ ]
for word in all_word:
    if word[-1] in ('.!?') or (word[-1] == '"' and word[-2] in ('.!?')):
        temp +=word
        sentences.append(temp)
        temp=''
    else:
        temp +=word
        temp +=' '

##Find all Sirs and sort it 
all_sir=set()
for i in  range(len(all_word)):
    if 'Sir' in all_word[i] and 'Sirs' not in all_word[i]:
        if not all_word[i+1][-1].isalpha():
            all_sir.add(all_word[i+1][:-1])
        else:
            all_sir.add(all_word[i+1])
            
    elif 'Sirs' in all_word[i]:
        k = i+1
        while all_word[k] != 'and' and all_word[k] != 'or':
            if not all_word[k][-1].isalpha() :
                all_sir.add(all_word[k][:-1])
                k +=1
            else:
                all_sir.add(all_word[k])
                k +=1
        if not all_word[k+1][-1].isalpha():
            all_sir.add(all_word[k+1][:-1])
        else:
            all_sir.add(all_word[k+1])
sirs=[ ]            
for sir in all_sir:
    sirs.append(sir)
sirs.sort()

##Find All double quote sentences
quote=[ ]
for sen in sentences:
    if '"' in sen:
        quote.append(sen)

##Put quotes into dict(Key:person,Value:what he/she is saying) 
quote_dict={}
for sen in quote:
    value=re.findall(r'\"(.*)\"',sen)[0]
    c=sen.replace(value,'')
    for i in range(len(c.split())):
        if c.split()[i] == 'Sir':
            key = c.split()[i+1]
    if not key[-1].isalpha():
        key = key[:-1]
    if key not in quote_dict:
        quote_dict[key]=[value]
    else:
        quote_dict[key].append(value) 
    
   
##Transfer the content of quote into computing language
## least one of,or:1,most one of:2, exactly one of:3,all of,I am or someone is,and:4
##knight:1 knave:0
quote_dict_2={ }
keys=list(quote_dict.keys())
for person in keys:
    person_no=sirs.index(person)+1
    for quote in quote_dict[person]:
        _quote=copy.deepcopy(quote.split())
        for i in range(len(_quote)):
            for char in _quote[i]:
                if not char.isalpha():
                    _quote[i] = _quote[i].replace(char,'')
        cont=[ ]
        if 'Knight' in quote:
            _id= 1
        else:
            _id =0
        if 'least one of' in quote:
            cont.append(1)
            if 'us' not in _quote:
                for sir in sirs:
                    if sir in _quote:
                        cont.append(_id)
                    else:
                        cont.append(None)
            else:
                for i in range(len(sirs)):
                    cont.append(_id)
            if 'I' in _quote:
                cont[person_no] = _id
        elif 'most one of' in quote:
            cont.append(2)
            if 'us' not in _quote:
                for sir in sirs:
                    if sir in _quote:
                        cont.append(_id)
                    else:
                        cont.append(None)
            else:
                for i in range(len(sirs)):
                    cont.append(_id)
            if 'I' in _quote:
                cont[person_no] = _id
        elif 'one of' in quote:
            cont.append(3)
            if 'us' not in _quote:
                for sir in sirs:
                    if sir in _quote:
                        cont.append(_id)
                    else:
                        cont.append(None)
            else:
                for i in range(len(sirs)):
                    cont.append(_id)
            if 'I' in _quote:
                cont[person_no] = _id
        elif 'All' in _quote or 'all' in _quote:
            cont.append(4)
            for i in range(len(sirs)):
                cont.append(_id)
        elif 'I am' in quote:
            cont.append(4)
            for i in range(len(sirs)):
                cont.append(None)
            cont[person_no] = _id
        elif 'or' not in _quote and 'and' not in _quote:
            cont.append(4)
            for sir in sirs:
                if sir in _quote:
                    cont.append(_id)
                else:
                    cont.append(None)
        elif 'or' in _quote and 'is' in _quote:
            cont.append(1)
            for sir in sirs:
                if sir in _quote:
                    cont.append(_id)
                else:
                    cont.append(None)
            if 'I' in _quote:
                cont[person_no] = _id
        elif 'and' in _quote and 'are' in _quote:
            cont.append(4)
            for sir in sirs:
                if sir in _quote:
                    cont.append(_id)
                else:
                    cont.append(None)
            if 'I' in _quote:
                cont[person_no] = _id
        add=tuple(cont)
        if person_no not in quote_dict_2:
            quote_dict_2[person_no]=[add]
        else:
            quote_dict_2[person_no].append(add)


##Creat all possible cases
result=[[0],[1]]
for i in range(len(sirs)-1):
    add=copy.deepcopy(result)
    for k in result:
            k.append(1)
    for y in add:
            y.append(0)
    result +=add

                               
##Go through the cases
##if cases fails remove it from all possible cases

remove=set()
for case in result:
    record=[]
    for key in quote_dict_2:
        for case_2 in quote_dict_2[key]:
            if case_2[0] == 1:
                final= 0
                for i in range(1,len(case_2)):
                    if case_2[i] != None:
                        if case_2[i] == case[i-1]:
                            final +=1
                if final >=1:
                    if case[key-1] == 1:
                        final = True
                    else:
                        final= False
                else:
                    if case[key-1] == 0:
                        final = True
                    else:
                        final = False
                record.append(final)
                                
            elif case_2[0] == 2:
                final = 0
                for i in range(1,len(case_2)):
                    if case_2[i] !=None:
                        if case_2[i] == case[i-1]:
                            final +=1
                if final <= 1:
                    if case[key-1] == 1:
                        final = True
                    else:
                        final = False
                else:
                    if case[key-1] == 0:
                        final = True
                    else:
                        final = False
                record.append(final)
            elif case_2[0] == 3:
                final = 0
                for i in range(1,len(case_2)):
                    if case_2[i] !=None:
                        if case_2[i] == case[i-1]:
                            final +=1
                if final == 1:
                    if case[key-1] ==1:
                        final = True
                    else:
                        final = False
                else:
                    if case[key-1]==0:
                        final = True
                    else:
                        final = False
                record.append(final)
            elif case_2[0] == 4:
                num = 0
                nb = 0
                for i in range(1,len(case_2)):
                    if case_2[i] !=None:
                        nb +=1
                        if case_2[i] == case[i-1]:
                            num +=1
                if num == nb:
                    if case[key-1] == 1:
                        final = True
                    else:
                        final = False
                else:
                    if case[key-1]==0:
                        final = True
                    else:
                        final = False
                record.append(final)
    if False in record:
        remove.add(tuple(case))
    
for case in remove:
    result.remove(list(case))

##Organize the output
if len(result) ==1:
    for i in range(len(result)):
        for d in range(len(result[i])):
            if result[i][d] == 1:
                result[i][d] ='Knight'
            else:
                result[i][d]='Knave'

print('The Sirs are: ', end='')
for sir in sirs:
    print(sir,end=' ')
print()
if len(result)>=2:
    print('There are',len(result),'solutions.')
elif len(result)==1:
    print('There is a unique solution:')
    for i in range(len(sirs)):
        print('Sir', sirs[i], 'is a',result[0][i]+'.')
else:
    print('There is no solution.')
    
    
        
            
        
                    
        
            
            
        




        
        
        
        






        
                
                
            
            
    
            
