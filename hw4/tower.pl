tower(N, T, C) :- true.

values(L, MaxVal) :- fd_domain(Dom, 1, MaxVal), fd_dom(Dom, L).
row(R, MaxVal) :- values(M, MaxVal), permutation(M, R).
board([], _).
board(_, _).

noattack(Q,[],_).
noattack(Q1,[Q2|Rest],Diff):-
    Q1#\=#Q2,
    Diff#\=#Q1-Q2,
    Diff#\=#Q2-Q1,
    Diff2 is Diff-1,
    noattack(Q1,Rest,Diff2).
safe([]).
safe([Q|T]):-noattack(Q,T,1),safe(T).

eightqueens(Solution):-
    Solution = [_,_,_,_,_,_,_,_],
    fd_domain(Solution,1,8),
    safe(Solution),
    fd_labeling(Solution).


list_of_length(L, 0) :- L=[].
list_of_length(_, -1) :- !, fail.
list_of_length(L, N) :-
    Dec is N-1,
    L=[_|Tail],
    list_of_length(Tail, Dec).

board_of_size(B, 0, _) :- B=[].
board_of_size(_, -1, _) :- !, fail.
board_of_size(B, Row, Col) :-
    Dec is Row-1,
    list_of_length(L, Col),
    B=[L|Tail],
    board_of_size(Tail, Dec, Col).
board_of_size(B, N) :- board_of_size(B, N, N).

board_domain([], _).
board_domain([H|T], MaxVal) :-
    fd_domain(H, 1, MaxVal),
    fd_all_different(H),
    board_domain(T, MaxVal).

board_labeling([]).
board_labeling([H|T]) :-
    fd_labeling(H),
    board_labeling(T).

check_rows_differ([], []).
check_rows_differ([HL|TL], [HR|TR]) :-
    \+(HL=HR),
    check_rows_differ(TL, TR).

check_columns([_]).
check_columns([H,I|T]) :-
    check_rows_differ(H, I),
    check_columns([I|T]),
    check_columns([H|T]).

permutationsFD(Sol, MaxVal) :-
    board_of_size(Sol, MaxVal),
    board_domain(Sol, MaxVal),
    board_labeling(Sol),
    check_columns(Sol).
