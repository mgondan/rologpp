#include "SWI-cpp.h"

#include "Rcpp.h"
using namespace Rcpp;
#include "RInside.h"

RObject pl2r(PlTerm arg) ;

RObject pl2r_null()
{
  return R_NilValue ;
}

RObject pl2r_na()
{
  LogicalVector r(1) ;
  r(0) = NA_LOGICAL ;
  return r ;
}

RObject pl2r_real(PlTerm arg)
{
  NumericVector r(1) ;
  r(0) = arg ;
  return r ;
}

RObject pl2r_integer(PlTerm arg)
{
  IntegerVector r(1) ;
  r(0) = arg ;
  return r ;
}

RObject pl2r_char(PlTerm arg)
{
  CharacterVector r(1) ;
  r(0) = (char*) arg ;
  return r ;
}

RObject pl2r_symbol(PlTerm arg)
{
  if(arg == "NA")
    return pl2r_na() ;

  return as<RObject>(Symbol((char*) arg)) ;
}

RObject pl2r_list(PlTerm arg)
{
  List r ;
  
  PlTail tail(arg) ;
  PlTerm e ;
  while(tail.next(e))
    r.push_back(pl2r(e)) ;
  
  return r ;
}

RObject pl2r_compound(PlTerm term)
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
  
  return as<RObject>(r) ;
}

RObject pl2r(PlTerm arg)
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

  throw PlException(PlTypeError("NULL, Integer, Float, String, Atom, List, Compound", arg)) ;
  return pl2r_null() ;
}

PlTerm r2pl(RObject arg) ;

PlTerm r2pl_real(NumericVector arg)
{
  return PlTerm(arg(0)) ;
}

PlTerm r2pl_na()
{
  return PlTerm("NA") ;
}

PlTerm r2pl_logical(LogicalVector arg)
{
  if(arg(0) = NA_LOGICAL)
    return r2pl_na() ;

  if(arg(0))
    return PlAtom("TRUE") ;
  
  return PlAtom("FALSE") ;
}

PlTerm r2pl_integer(IntegerVector arg)
{
  if(arg(0) = NA_INTEGER)
    return r2pl_na() ;

  return PlTerm((long) arg(0)) ;
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

PlTerm r2pl_atom(Symbol arg)
{
  if(arg == "NA")
    return r2pl_na() ;

  if(arg == "NULL")
    return r2pl_null() ;

  return PlAtom(arg.c_str()) ;
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

PlTerm r2pl(RObject arg)
{
  if(is<Language>(arg))
    return r2pl_compound(as<Language>(arg)) ;

  if(is<NumericVector>(arg))
    return r2pl_real(as<NumericVector>(arg)) ;
  
  if(is<LogicalVector>(arg))
    return r2pl_logical(as<LogicalVector>(arg)) ;
  
  if(is<IntegerVector>(arg))
    return r2pl_integer(as<IntegerVector>(arg)) ;
  
  if(is<Symbol>(arg))
    return r2pl_atom(as<Symbol>(arg)) ;

  if(is<CharacterVector>(arg))
    return r2pl_string(as<CharacterVector>(arg)) ;

  if(is<List>(arg))
    return r2pl_list(as<List>(arg)) ;
  
  if(arg.sexp_type() == VECSXP)
    return r2pl_list(as<List>(arg)) ;
  
  if(arg.sexp_type() == NILSXP)
    return r2pl_null() ;
  
  String s = Language("class", arg).eval() ;
  throw PlException(PlTypeError("Language, Vector, Symbol, List, NULL", PlTerm(s.get_cstring()))) ;
  return r2pl_na() ;
}

RInside* r_instance = NULL ;

PREDICATE(r_init, 1)
{
  if(r_instance)
    return true ;

  const char* const argv[] = {(const char*) A1} ;
  r_instance = new RInside(1, argv) ;
  return true ;
}

PREDICATE(eval_, 2)
{
  if(!r_instance)
    throw PlException(PlTerm("R not initialized")) ;

  RObject Expr = pl2r(A1) ;
  RObject Res = Expr ;
  try 
  {
    if(is<Language>(Expr))
      Res = as<Language>(Expr).eval() ;
  } 
  catch(std::exception& ex)
  {
    throw PlException(PlTerm(ex.what())) ;
    return false ;
  }

  PlTerm a2 ;
  try
  {
    a2 = r2pl(Res) ;
  }
  catch(std::exception& ex)
  {
    throw PlException(PlTerm(ex.what())) ;
    return false ;
  }

  return A2 = a2 ;
}
