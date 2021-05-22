:- module(rologpp, 
  [
    r_init/0,
    r_init/1,
    r_done/0,
    r_call/1,
    r_eval/2,
    op(800, xfx, <-),
    op(800, fx, <-),
    '<-'/2,
    '<-'/1
  ]).

:- use_foreign_library(foreign(rologpp)).

:- op(800, xfx, <-).
:- op(800, fx, <-).

r_init :-
    current_prolog_flag(argv, [Argv0 | _]),
    r_init(Argv0).
    
r_call(Expr) :-
    writeln(Expr).
    
<-(Call) :-
    format('<- ~w~n', [Call]).
    
<-(Var, Expr) :-
    format('~w <- ~w~n', [Var, Expr]).

