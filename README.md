# Access R from SWI-Prolog

1. Please start R and install the two packages `Rcpp` and `RInside`.

R> `install.packages('Rcpp', 'RInside')`

2. Please start SWI-Prolog and then install the pack rologpp

SWI> `assert(prolog_pack:environment('R_LIBS_USER', X) :- getenv('R_LIBS_USER', X)).` (This is needed if you installed the R packages in a local "user" directory)

SWI> `pack_install(rologp).` (Please note that rologp is written with only one p)

SWI> `r_eval(2+2, X).`
