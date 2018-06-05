%%%%COMP9414 Assignment3
%%%%Jiongtian Li	
%%%%z5099187
%%%%%%



%Question 1
%trigger(Events, Goals) takes a list of events contains
%truffles(X,Y,S) or restaurant(X,Y,S) then output Goals(two lists
%of goal(X,Y,S)) in the form goals(Goals_rest, Goals_truff).
%%%%


%%When the events are empty list.
%%%%%% 

trigger([], goals([],[])).

trigger([], ([], [])).


%%%Recursive go through the Event list, seperate them into
%%%Goals_rest and Goals_truff. 
%%%%%

trigger([truffle(X,Y,S)|Tail], goals(R,[goal(X,Y,S)|Tail2]) ) :-
	trigger(Tail, goals(R,Tail2)).
	
trigger([restaurant(X,Y,S)|Tail], goals([goal(X,Y,S)|Tail2], T) ) :-
    trigger(Tail, goals(Tail2, T)).
    


	
	

%%%Quesion2 update the intensions with new Goals only.
%%%Insert the Goals_rest and Goals_truff into Int_sell and Int_pick.
%%%%%% 


incorporate_goals(goals(Goals_rest, Goals_truff), beliefs(at(X,Y),stock(T)), intents(Int_sell,Int_pick), intents(Int_sell1, Int_pick1)) :-
	insert_1(Goals_rest, (at(X,Y),stock(T)), Int_sell, Int_sell1),
	insert_1(Goals_truff, (at(X,Y),stock(T)), Int_pick, Int_pick1).
	
	
%%Check if the goal inside the Intensions, 
%%if doesn't, do the insert, otherwise go through next goal.
%%Used 'greater' function to find out the postion to insert. 
%%%%%% 

insert_1([], _, Ints, Ints).

insert_1([Goal|Tail], Beliefs, Ints, Ints1) :-
	check_member(Goal, Ints),
	insert_1(Tail, Beliefs, Ints, Ints1).

insert_1([Goal|Tail], Beliefs, Ints, Ints1) :-
	not(check_member(Goal, Ints)),
	insert_2(Goal, Beliefs, Ints, Newints),
	insert_1(Tail, Beliefs, Newints, Ints1).


insert_2(Goal, Beliefs, [Int|Ints], [Int|Ints1]) :-
	not(greater(Goal, Beliefs, Int)), !,
	insert_2(Goal, Beliefs, Ints, Ints1).

insert_2(Goal, _, Ints, [[Goal,[]]|Ints]).


%%Determine the position of the goal based on values.
%%If values are same then compare the distance. 
%%%%%% 


greater(goal(_,_,S), _, [goal(_,_,S1)|_]) :-
	S> S1.

greater(goal(X1,Y1,S), (at(X,Y),_), [goal(X2,Y2,S1)|_]) :-
	S == S1,
	distance((X1,Y1),(X,Y), D),
	distance((X2,Y2),(X,Y),D1),
	D < D1.


%%Function check if the goal exist in the intension. 
%%%%%% 
	
check_member(Goal, [H|_]) :-
	member(Goal, H).
	
check_member(Goal, [H|T]) :-
	not(member(Goal, H)),
	check_member(Goal, T).
	

%%%Question 3
%%%Get the action from intensions, then updated the intensions.
%%%if Int_sell not empty and agent have enough truffles to sell,
%%%get the action from Int_sell. Otherwise, get the action from 
%%% Int_pick. If both Int_pick and Int_sell are empty, 
%%% stay at the postion. 
%%%%%


%%% Stay at the postion, when Int_pick and Int_sell are empty.
%%%%%%
         
get_action(beliefs(at(X,Y), _ ), intents([],[]),  intents([],[]), move(X,Y)).
		

%%%When stock are not enough and Inten_pick are empty, stay at same postion. 
%%%%%% 

get_action(beliefs(at(X,Y),stock(T)), intents(Inten_sell,[]), intents(Inten_sell,[]), move(X,Y)) :-
    [[goal(_,_,S1),_]|_] = Inten_sell,
	S1 > T.


%%%Agent have enough stock to sell. 
%%%%%% 

get_action(beliefs(at(X,Y),stock(T)), intents([[goal(X1,Y1,S),Plan]|Tail], Inten_pick), intents([[goal(X1,Y1,S),Plan2]|Tail],Inten_pick), Act) :-
	T >= S,
	new_plan(goal(X1,Y1,S), Plan, at(X,Y), Newplan),
	reverse_list([sell(X1, Y1)|Newplan], Plan3),
	next_act(Plan3, Plan2, Act). 

%%%Int_sell is empty, then get action from Int_pick.
%%%%%% 

get_action(beliefs(at(X,Y),_), intents([],[[goal(X1,Y1,S),Plan]|Tail]), intents([],[[goal(X1,Y1,S),Plan2]|Tail]), Act) :-
	new_plan(goal(X1,Y1,S), Plan, at(X,Y), Newplan),
	reverse_list([pick(X1,Y1)|Newplan], Plan3),
	next_act(Plan3, Plan2, Act).
	
%%%Stock not engouth, get action from Int_pick.
%%%%%% 
	
get_action(beliefs(at(X,Y),stock(T)), intents(Inten_sell,[[goal(X1,Y1,S),Plan]|Tail]), intents(Inten_sell,[[goal(X1,Y1,S),Plan2]|Tail]), Act) :-
	[[goal(_,_,S1),_]|_] = Inten_sell,
	S1 > T, 
	new_plan(goal(X1,Y1,S), Plan, at(X,Y), Newplan),
	reverse_list([pick(X1,Y1)|Newplan], Plan3),
	next_act(Plan3, Plan2, Act).
	
%%%Get next action from Plan and remove the action from plan. 
%%%%%% 
	
next_act([Act|Plans], Plans, Act). 
	

%%%If plan is empty, construct a new plan. 
%%%%%% 
	
new_plan(goal(X1,Y1,_), [], at(X,Y), Newplan) :-
	new_plan(goal(X1,Y1,_), [], at(X,Y), [], Newplan).
	
%%% If action is not applicable, construct a new plan. 
%%%%%% 

new_plan(goal(X1,Y1,_), Oldplan, at(X,Y), Newplan) :-
	next_act(Oldplan, _Plans, Act), 
	not(applicable(Act)),
	new_plan(goal(X1,Y1,_), Oldplan, at(X,Y), [], Newplan).
	
%%% Plan is good. Reverse the plan. 
%%%%%% 
	
new_plan(goal(_X1,_Y1,_), Oldplan, at(_X,_Y), Newplan) :-
	next_act(Oldplan, _Plans, Act), 
	applicable(Act), 
	remove_last(Oldplan, Plan1),
	reverse_list(Plan1, Newplan). 

%%%Process of constructing new plan
%%%%%% 


new_plan(goal(X1,Y1,_), _Oldplan, at(X1,Y1), PartPlan, PartPlan).


new_plan(Goal, _oldplan, at(X,Y), PartPlan,  Newplan) :-
	new_moves(X,Y, move(Nx, Ny)),
	check_move(move(Nx,Ny), Goal, at(X,Y)),
	new_plan(Goal, _oldplan, at(Nx,Ny), [move(Nx,Ny)|PartPlan], Newplan). 

%%% Check if next move is valid by checking the distance. 
%%%%%% 

check_move(move(X,Y), goal(X1,Y1,_), at(X2,Y2)) :-
	distance((X,Y), (X1,Y1), D1),
	distance((X2,Y2), (X1,Y1), D2),
	D1 < D2. 

%%%Find out all valid moves. 
%%%%%% 
	
new_moves(X,Y, Move) :-
	Nx is X + 1, Move = move(Nx, Y);
	Nx is X - 1, Move = move(Nx, Y); 
	Ny is Y + 1, Move = move(X, Ny);
	Ny is Y - 1, Move = move(X, Ny).

%%%Rever list function. 
%%%%%% 
	
reverse_list(List, Reverse) :-
	reverse_list(List, [], Reverse).
	
reverse_list([], Reverse, Reverse).


reverse_list([H|T], Partreverse, Reverse) :-
	reverse_list(T, [H|Partreverse], Reverse). 
	

%%%Remove the last element from the list.
%%%%%%  

	
remove_last([X|Xs], Ys) :-
	remove_last_p(Xs, Ys, X).

remove_last_p([],[], _).

remove_last_p([X1|Xs],[X0|Ys], X0) :-
	remove_last_p(Xs,Ys, X1). 
	
	
%%%%Question 4  update the beliefs based on observation. 
%%%%%% 


%%%Update beliefs when agent at(X, Y).
%%%%%% 

update_beliefs(at(X,Y), beliefs(_,Stock), beliefs(at(X,Y),Stock) ).


%%%Update beliefs when agent picked(X, Y, S).
%%%%%% 

update_beliefs(picked(_,_,S), beliefs(At,stock(T)), beliefs(At,stock(Newt)) ) :-
	Newt is T+S. 
	
%%%Update beliefs when agent sold(X, Y, S).
%%%%%% 

update_beliefs(sold(_,_,S), beliefs(At,stock(T)), beliefs(At,stock(Newt)) ) :-
	Newt is T-S.
	

%%%Quesion 5 update the intension based on oberservaton(picked and sold only)
%%%%%% 


%%%at(X,Y) doesn't affect intension. 
%%%%%% 

update_intentions(at(_,_), intents(In_sell, In_pick), intents(In_sell, In_pick)).

%%Update intension when agent picked(X, Y, S).
%%%%%% 

update_intentions(picked(X,Y,S), intents(Inten_sell,[[goal(X,Y,S),_]|T]), intents(Inten_sell,T)).

%%Update intension when agent sold(X, Y, S).
%%%%%% 

update_intentions(sold(X,Y,S), intents([[goal(X,Y,S),_]|T],Inten_pick), intents(T, Inten_pick)).
	
	 


	
	
	




	

	

	
	
	
	