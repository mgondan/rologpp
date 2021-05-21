#include <SWI-CPP.h>
#include <iostream>

static foreign_t pl_hello(PlTerm a1)
{
  std::cout << "Hello " << (char*) a1 << std::endl;
  return TRUE;
}

PlRegister x_hello_1(NULL, "hello", 1, &pl_hello) ;
