:- module(rologpp, 
  [
    r_call/1,
    r_eval/2,
    op(600, xfy, ::),
    op(800, xfx, <-),
    op(800, fx, <-),
    '<-'/2,
    '<-'/1
  ]).

:- use_foreign_library(foreign(rologpp)).
:- initialization(r_init).

r_init :-
    current_prolog_flag(os_argv, [Argv0 | _]),
    r_init(Argv0).

:- op(800, xfx, <-).
:- op(800, fx, <-).

r_call(Expr) :-
    writeln(Expr).

r_eval(X, Y) :-
    pl2r_(X, R),
    eval_(R, Y).

pl2r_('::'(Namespace, Compound), X)
 => term_string(Namespace, Ns),
    compound_name_arguments(Compound, Name, Arguments),
    X = 'do.call'('$'(getNamespace(Ns), Name), Arguments).

pl2r_(A, X),
    compound(A)
 => mapargs(pl2r_, A, X).

pl2r_(A, X)
 => A = X.

    
<-(Call) :-
    format('<- ~w~n', [Call]).
    
<-(Var, Expr) :-
    format('~w <- ~w~n', [Var, Expr]).
