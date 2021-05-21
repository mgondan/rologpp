#include <SWI-CPP.h>
#include <iostream>

PREDICATE(hello, 1)
{ 
  cout << "Hello " << (char *)A1 << endl;
  return TRUE;
}

install_t install_rologpp()
{ 
  PlRegister x_hello_1(NULL, "hello", 2, pl_hello);
}

