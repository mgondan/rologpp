#include <SWI-CPP.h>
#include <iostream>

static foreign_t pl_hello(PlTerm a1)
{
  std::cout << "Hello " << (char*) a1 << std::endl;
  return TRUE;
}

install_t install_rologpp()
{
  PL_register_foreign("hallo", 1, pl_hello, 0);
}
