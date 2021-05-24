:- module(rologpp, 
  [
    r_init/0,
    r_init/1,
    r_done/0,
    r_call/1,
    r_eval/2,
    op(600, xfy, ::),
    op(800, xfx, <-),
    op(800, fx, <-),
    '<-'/2,
    '<-'/1
  ]).

:- use_foreign_library(foreign(rologpp)).

:- op(800, xfx, <-).
:- op(800, fx, <-).

r_init :-
    current_prolog_flag(os_argv, [Argv0 | _]),
    r_init(Argv0).
    
r_call(Expr) :-
    writeln(Expr).

r_eval(X, Y) :-
    pl2r_(X, R),
    eval_(R, Y).

pl2r_('::'(Namespace, Compound), X)
 => term_string(Namespace, Ns),
    compound_name_arguments(Compound, Name, Arguments),
    X = 'do.call'('$'(getNamespace(Ns), Name), Arguments).

pl2r(A, X),
    compound(A)
 => mapargs(pl2r, A, X).

pl2r(A, X)
 => A = X.

    
<-(Call) :-
    format('<- ~w~n', [Call]).
    
<-(Var, Expr) :-
    format('~w <- ~w~n', [Var, Expr]).
