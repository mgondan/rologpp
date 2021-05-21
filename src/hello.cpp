#include <SWI-CPP.h>
#include <iostream>

PREDICATE(hello, 1)
{ 
  std::cout << "Hello " << (char *)A1 << std::endl ;
  return true ;
}
