% Full Name: Jiongtian Li
% Student_No: z5099187
% Assignment: Assignment_1


%weird_sum(List, Result): A function take a list then output sum of the squares of 
%the numbers in the list that are greater than or equal to 5, minus the sum of the 
%absolute values of the numbers that are less than or equal to 2. 

weird_sum([],0).

weird_sum([Head|Tail], Result) :-
		Head >= 5, 
		Temp is Head*Head, 
		weird_sum(Tail, Rest),
		Result is Temp + Rest. 
		

weird_sum([Head|Tail], Result) :-
		Head <5,
		Head >2,
		weird_sum(Tail, Temp),
		Result is Temp.  
		
weird_sum([Head|Tail], Result) :-
		Head =< 2, 
		Y is abs(Head),
		weird_sum(Tail, Temp),
		Result is Temp - Y.
		
%same_name(Person1,Person2): A function determine if person1 and person2 have same
%family name. 



same_name(Person1,Person2) :- 
		Person1 = Person2. 

same_name(Person1,Person2) :- 
		male(Person1),
		ancestor(Person2, Person1).
		
same_name(Person1,Person2) :- 
	    male(Person2),
		ancestor(Person1, Person2).
		
same_name(Person1,Person2) :- 
		parent(F1, Person1),
		male(F1),
		parent(F2, Person2),
		male(F2),
		same_name(F1, F2).

		
%ancestor(Person, Ancestor) : A function to find person's ancestors. 

ancestor(Person, Ancestor) :-
		parent(Ancestor, Person).

ancestor(Person, Ancestor) :-
		parent(P, Person),
		ancestor(P, Ancestor). 
		
%log_table(NumberList, ResultList): return ResultList to the list of pairs consisting 
%of a number and its log, for number in NumberList.

log_table([],[]).
		
log_table([Head|Tail], [[Head,X]|Rest]) :-
		X is log(Head),
		log_table(Tail,Rest).
		


%paruns(List, RunList) transfer a list of numbers into the corresponding 
% list of parity runs. 


paruns([],[]).

paruns([E],[[E]]).

paruns([Head|Tail], [NewHead|T]) :-
		paruns(Tail, R),
		[Head2|T] = R,
		[H|_] = Head2,
		Head mod 2 =:= H mod 2,
		append([Head],Head2, NewHead).
		
		
paruns([Head|Tail], [[Head]|Rest] ) :-
		[H|_]=Tail,
		Head mod 2 =\= H mod 2,
		paruns(Tail,Rest).


%tree(tree,root_value) return the root value of the tree. 

tree_value(tree(_, X, _), X). 

tree_value(empty, empty).


%is_heap(Tree) check if this tree satisfy the heap property.

is_heap(tree(empty, _, empty)).

is_heap(empty).

is_heap(tree(Left, Root, Right)) :-
		is_heap(Left),
		is_heap(Right),
		tree_value(Left, L),
		tree_value(Right, R),
		L \= empty,
		R \= empty,
		L >= Root,
		R >= Root.
		
is_heap(tree(Left, Root, Right)) :-
		is_heap(Left),
		is_heap(Right),
		tree_value(Left, L),
		tree_value(Right, R),
		L = empty,
		R \= empty,
		R >= Root.
		

is_heap(tree(Left, Root, Right)) :-
		is_heap(Left),
		is_heap(Right),
		tree_value(Left, L),
		tree_value(Right, R),
		L \= empty,
		L >= Root,
		R = empty.
				



		
		
		
		
		
		
		
		


	













		
		
		
		
		

		

		


		

		
		
		
		
		


		
		
		

		
		 	
		
