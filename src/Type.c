#include "Type.h"

#include <lolie/Memory.h>
#include <lolie/Stringp.h>

bool Type_equals(const struct Type* a,const struct Type* b){
	return a==b || (a->size == b->size && Stringp_equals(a->name,b->name));
}
