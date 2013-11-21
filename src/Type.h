#ifndef __LOLIROFLE_TCALC_TYPE_H_INCLUDED__
#define __LOLIROFLE_TCALC_TYPE_H_INCLUDED__

#include <lolie/TypeAliases.h>
#include <lolie/Stringp.h>

struct Type{
	Stringp name;
	size_t size;
	void(*print)(void* data);
};

bool Type_equals(const struct Type* a,const struct Type* b);

#endif
