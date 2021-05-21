#include <SWI-CPP.h>
#include <iostream>

PREDICATE(hello, 1)
{ 
  std::cout << "Hello " << (char *)A1 << std::endl ;
  return true ;
}

install_t install_rologpp()
{
  PL_register_foreign("hello", 1, pl_hello, 0) ;
}
