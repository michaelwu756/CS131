tower(N, T, C) :- true.

transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).

append([L], L).
append([H|T], L) :-
    append(T, LSub),
    append(H, LSub, L).

same_length([], []).
same_length([_|T1], [_|T2]) :- same_length(T1, T2).

towers(N, T) :-
    length(T, N),
    maplist(same_length(T), T),
    append(T, Vs),
    fd_domain(Vs, 1, N),
    maplist(fd_all_different, T),
    transpose(T, Trans),
    maplist(fd_all_different, Trans),
    fd_labeling(Vs).
