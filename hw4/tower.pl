tower(N, T, C) :- true.
unique_row(R) :- R=[];
                 R=[_];
                 R=[First,Second|Tail], \+(First=Second), unique_row([Second|Tail]), unique_row([First|Tail]).
