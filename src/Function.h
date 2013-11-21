#ifndef __LOLIROFLE_TCALC_FUNCTION_H_INCLUDED__
#define __LOLIROFLE_TCALC_FUNCTION_H_INCLUDED__

#include <lolie/Stringp.h>

struct Type;
struct FunctionParameter;

struct Function{
	const Stringcp name;
	unsigned short parameterCount;
	const struct FunctionParameter* parameters;
	const struct Type* returnType;
	void(*function)(void* arguments,void* returnValue);
};

#endif
