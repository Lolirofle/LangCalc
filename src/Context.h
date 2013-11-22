#ifndef __LOLIROFLE_TCALC_CONTEXT_H_INCLUDED__
#define __LOLIROFLE_TCALC_CONTEXT_H_INCLUDED__

#include <lolie/LinkedList.h>
#include <lolie/Stringp.h>
#include <lolie/Memory.h>

struct Type;

struct Context{
	LinkedList* types;
	LinkedList* functions;
	LinkedList* variables;
};

const struct Type* Context_getType(const struct Context* context,Stringcp name);
const struct Function* Context_getFunction(const struct Context* context,Stringcp name);
const struct Variable* Context_getVariable(const struct Context* context,Stringcp name);

#endif
