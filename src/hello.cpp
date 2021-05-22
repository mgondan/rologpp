#include "SWI-cpp.h"

#include <Rcpp.h>
using namespace Rcpp;

PREDICATE(add, 3)
{ 
  return A3 = (long)A1 + (long)A2;
}

SEXP pl2r(PlTerm arg) ;

SEXP pl2r_null()
{
  return R_NilValue ;
}

DoubleVector pl2r_real(PlTerm arg)
{
  DoubleVector r(1) ;
  r(0) = arg ;
  return r ;
}

IntegerVector pl2r_integer(PlTerm arg)
{
  IntegerVector r(1) ;
  r(0) = arg ;
  return r ;
}

CharacterVector pl2r_char(PlTerm arg)
{
  CharacterVector r(1) ;
  r(0) = (char*) arg ;
  return r ;
}

Symbol pl2r_symbol(PlTerm arg)
{
  return Symbol((char*) arg) ;
}

List pl2r_list(PlTerm arg)
{
  List r ;
  
  PlTail tail(arg) ;
  PlTerm e ;
  while(tail.next(e))
    r.push_back(pl2r(e)) ;
  
  return r ;
}

Language pl2r_compound(PlTerm term)
{
  Language r(term.name()) ;
  
  for(unsigned int i=1 ; i<=term.arity() ; i++)
  {
    /*
     * // compounds like '='(x, y) are named arguments
     if(PL_is_compound(t[i]) && t[i].name() == std::string("=") && t[i].arity() == 2)
     {
     PlTerm u = t[i] ;
     l.push_back(Named(u[1].name()) = pl2r_leaf(u[2])) ;
     continue ;
     }
     */
    
    r.push_back(pl2r(term[i])) ;
  }
  
  return r ;
}

SEXP pl2r(PlTerm arg)
{
  if(PL_term_type(arg) == PL_NIL)
    return pl2r_null() ;
  
  if(PL_is_integer(arg))
    return pl2r_integer(arg) ;
  
  if(PL_is_float(arg))
    return pl2r_real(arg) ;
  
  if(PL_is_string(arg))
    return pl2r_char(arg) ;
  
  if(PL_is_atom(arg))
    return pl2r_symbol(arg) ;
  
  if(PL_is_list(arg))
    return pl2r_list(arg) ;
  
  if(PL_is_compound(arg))
    return pl2r_compound(arg) ;
  
  Rcout << "pl2r: Cannot convert " << (char*) arg << std::endl ;
  return R_NilValue ;
}

PlTerm r2pl(SEXP arg) ;

PlTerm r2pl_real(NumericVector arg)
{
  return PlTerm(arg(0)) ;
}

PlTerm r2pl_logical(LogicalVector arg)
{
  if(arg(0))
    return PlAtom("TRUE") ;
  
  return PlAtom("FALSE") ;
}

PlTerm r2pl_integer(IntegerVector arg)
{
  return PlTerm((long) arg(0)) ;
}

PlTerm r2pl_atom(Symbol arg)
{
  return PlAtom(as<Symbol>(arg).c_str()) ;
}

PlTerm r2pl_string(CharacterVector arg)
{
  return PlString(arg(0)) ;
}

PlTerm r2pl_null()
{
  PlTerm r ;
  PlTail(r).close() ;
  return r ;
}

PlTerm r2pl_na()
{
  return PlTerm("NA") ;
}

PlTerm r2pl_compound(Language arg)
{
  PlTermv args(arg.size() - 1) ;
  
  R_xlen_t i=0 ;
  for(SEXP cons=CDR(arg) ; cons != R_NilValue ; cons = CDR(cons))
    args[i++] = r2pl(CAR(cons)) ;

  return PlCompound(as<Symbol>(CAR(arg)).c_str(), args) ;
}

PlTerm r2pl_list(List arg)
{
  PlTerm r ;
  PlTail l(r);
  for(R_xlen_t i=0; i<arg.size() ; i++)
    l.append(r2pl(arg(i))) ;
  l.close() ;
  
  return r ;
}

PlTerm r2pl(SEXP arg)
{
  if(TYPEOF(arg) == LANGSXP)
    return r2pl_compound(arg) ;

  if(TYPEOF(arg) == REALSXP)
    return r2pl_real(arg) ;
  
  if(TYPEOF(arg) == LGLSXP)
    return r2pl_logical(arg) ;
  
  if(TYPEOF(arg) == INTSXP)
    return r2pl_integer(arg) ;
  
  if(TYPEOF(arg) == SYMSXP)
    return r2pl_atom(arg) ;

  if(TYPEOF(arg) == STRSXP)
    return r2pl_string(arg) ;

  if(TYPEOF(arg) == VECSXP)
    return r2pl_list(arg) ;
  
  if(TYPEOF(arg) == NILSXP)
    return r2pl_null() ;
  
  return r2pl_na() ;
}

PREDICATE(r_eval, 2)
{
  SEXP Expr = pl2r(A1) ;
  return A2 = r2pl(Expr.eval()) ;
}
