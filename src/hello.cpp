#include <SWI-CPP.h>
#include <iostream>

static foreign_t pl_hello(term_t A1)
{ 
  std::cout << "Hello " << (char *) A1 << std::endl ;
  return true ;
}

install_t install_rologpp()
{
  PL_register_foreign("hello", 1, pl_hello, 0) ;
}
