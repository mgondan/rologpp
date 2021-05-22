#include "SWI-cpp.h"
#include <math.h>

PREDICATE(add, 3)
{ 
  return A3 = (long)A1 + (long)A2;
}
