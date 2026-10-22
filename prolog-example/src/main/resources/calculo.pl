% Derivada de una constante
d(Var, Func, 0) :-
    atomic(Var), number(Func).

% Derivada de una variable con respecto a si misma
d(Var, Func, 1) :-
    Var == Func.

% Derivada de una variable por una constante
d(Var, N*Var, N) :-
    atomic(Var), number(N).

% Derivada de una variable elevada a la N
d(Var, Var^N, N*Var^Nm1) :-
    number(N), is(Nm1, N - 1).

% Derivada de una variable elevada a la N por una constante
d(Var, K*Var^N, C*Var^Nm1) :-
    atomic(Var), number(K), number(N), is(C, K*N), is(Nm1, N-1).

% Derivada de un logaritmo natural
d(Var, log(Var), 1/Var) :-
    atomic(Var).

% Integral de una constante
s(Var, K, K*Var) :-
    number(K), atomic(Var).

% Integral de una variable con respecto a si misma
s(Var, Var, 1/2*Var^2) :-
    atomic(Var).

%% Integral de una constante por una variable elevada a la N
s(Var, K*Var^N, K/M*Var^M) :-
    atomic(Var), number(K), number(N), is(M, N+1).

% Extrae el coeficiente y el exponente de un termino
% Termino con coeficiente y exponente: K*x^N
termino(Var, K*Var^N, K, N) :-
    atomic(Var), number(K), number(N).

% Termino con coeficiente: K*x
termino(Var, K*Var, K, 1) :-
    atomic(Var), number(K).

% Variable elevada a la N: x^N
termino(Var, Var^N, 1, N) :-
    atomic(Var), number(N).

% Variable sola: x
termino(Var, Var, 1, 1) :-
    atomic(Var).

% Constante: K
termino(Var, K, K, 0) :-
    atomic(Var), number(K).

% Arma el termino final de forma limpia (sin 1*x, sin x^1, sin 0*x)
armar(_, C, _, 0) :-
    C =:= 0, !.
armar(_, C, E, C) :-
    E =:= 0, !.
armar(Var, C, E, Var) :-
    C =:= 1, E =:= 1, !.
armar(Var, C, E, C*Var) :-
    E =:= 1, !.
armar(Var, C, E, Var^E) :-
    C =:= 1, !.
armar(Var, C, E, C*Var^E).

% Suma de terminos semejantes (mismo exponente)
sumar(Var, A + B, R) :-
    termino(Var, A, C1, E1),
    termino(Var, B, C2, E2),
    E1 =:= E2, !,
    is(C, C1 + C2),
    armar(Var, C, E1, R).

% Suma de terminos no semejantes: no se pueden juntar
sumar(Var, A + B, A + B) :-
    termino(Var, A, _, E1),
    termino(Var, B, _, E2),
    E1 =\= E2.

% Resta de terminos semejantes (mismo exponente)
restar(Var, A - B, R) :-
    termino(Var, A, C1, E1),
    termino(Var, B, C2, E2),
    E1 =:= E2, !,
    is(C, C1 - C2),
    armar(Var, C, E1, R).

% Resta de terminos no semejantes: no se pueden juntar
restar(Var, A - B, A - B) :-
    termino(Var, A, _, E1),
    termino(Var, B, _, E2),
    E1 =\= E2.