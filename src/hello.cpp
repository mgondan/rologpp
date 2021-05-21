#include <SWI-CPP.h>
#include <iostream>
static foreign_t pl_hello(term_t a1)
{
  PlTerm A1(a1) ;
  
  std::cout << "Hello " << (char*) A1 << std::endl;
  return TRUE;
}

install_t install_rologpp()
{
  PL_register_foreign("hallo", 1, pl_hello, 0);
}
