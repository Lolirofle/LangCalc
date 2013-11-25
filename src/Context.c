#include "Context.h"

#include "Type.h"
#include "Function.h"
#include "Variable.h"

const struct Type* Context_getType(const struct Context* context,Stringcp name){
	LinkedList_forEach(context->types,node){
		if(name.length==((struct Type*)node->ptr)->name.length && Memory_equals(((struct Type*)node->ptr)->name.ptr,name.ptr,name.length))
			return (struct Type*)node->ptr;
	}
	return NULL;
}

const struct Function* Context_getFunction(const struct Context* context,Stringcp name){
	LinkedList_forEach(context->functions,node){
		if(name.length==((struct Function*)node->ptr)->name.length && Memory_equals(((struct Function*)node->ptr)->name.ptr,name.ptr,name.length))
			return (struct Function*)node->ptr;
	}
	return NULL;
}

const struct Variable* Context_getVariable(const struct Context* context,Stringcp name){
	LinkedList_forEach(context->variables,node){
		if(name.length==((struct Variable*)node->ptr)->name.length && Memory_equals(((struct Variable*)node->ptr)->name.ptr,name.ptr,name.length))
			return (struct Variable*)node->ptr;
	}
	return NULL;
}
