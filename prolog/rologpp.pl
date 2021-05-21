:- module(rologpp, 
  [
    r_init/2,
    r_done/0,
    r_call/1,
    op(800, xfx, <-),
    op(800, fx, <-),
    '<-'/2,
    '<-'/1
  ]).

:- op(800, xfx, <-).
:- op(800, fx, <-).

r_init(_Argc, _Argv) :-
    writeln(r_init).
    
r_done().

r_call(Expr) :-
    writeln(Expr).
    
<-(Call) :-
    format('<- ~w~n', [Call]).
    
<-(Var, Expr) :-
    format('~w <- ~w~n', [Var, Expr]).
