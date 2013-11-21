#ifndef __LOLIROFLE_TCALC_VARIABLE_H_INCLUDED__
#define __LOLIROFLE_TCALC_VARIABLE_H_INCLUDED__

#include <lolie/Stringp.h>

struct Type;
struct Expression;

struct Variable{
	const struct Type* type;
	const Stringcp name;
	struct Expression* value;
	
};

#endif
