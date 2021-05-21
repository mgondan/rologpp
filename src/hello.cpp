#include <SWI-CPP.h>
#include <iostream>
#include <string.h>

static foreign_t pl_hello(term_t list)
{ extern char **environ;
  term_t tail = PL_copy_term_ref(list);
  term_t head = PL_new_term_ref();
  char **ep;

  for(ep=environ; *ep; ep++)
  { char *e = *ep;
    char *en;

    if ( (en=strchr(e, '=')) && en-e < MAXNAME )
    { char name[MAXNAME];

      strncpy(name, e, en-e);
      name[en-e] = 0;

      if ( !PL_unify_list(tail, head, tail) ||
	   !PL_unify_term(head, PL_FUNCTOR, FUNCTOR_equal2,
			    PL_MBCHARS, name,
			    PL_MBCHARS, en+1) )
	return FALSE;
    }
  }

  return PL_unify_nil(tail);
}

install_t install_rologpp()
{ 
  FUNCTOR_equal2 = PL_new_functor(PL_new_atom("="), 2);
  PL_register_foreign("hello", 1, pl_hello, 0);
}
