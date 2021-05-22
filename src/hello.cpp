#include "SWI-cpp.h"
#include <iostream>
#include <math.h>
using namespace std ;

PREDICATE(hello, 1)
{ 
  cout << "Hello " << (char*) A1 << endl ;
  return TRUE;
}
