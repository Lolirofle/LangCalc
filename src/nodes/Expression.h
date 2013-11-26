#ifndef __LOLIROFLE_TCALC_NODE_EXPRESSION_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_EXPRESSION_H_INCLUDED__

#include "Expressions.h"

struct Type;
struct Context;

enum Expression_Kind{
	EXPRESSION_CONSTANTCALL,
	EXPRESSION_VARIABLECALL,
	EXPRESSION_FUNCTIONCALL,
	EXPRESSION_STRUCTURECALL,
	EXPRESSION_UNARYOPERATION,
	EXPRESSION_BINARYOPERATION,
	EXPRESSION_BLOCK,

	EXPRESSION_COMPILETIME_VALUE
};

struct Expression{
	enum Expression_Kind kind;
	union{
		struct Expression_VariableCall variableCall;
		struct Expression_FunctionCall functionCall;
		struct Expression_ConstantCall constantCall;
		struct Expression_StructureCall structureCall;
		struct Expression_UnaryOperation unaryOperation;
		struct Expression_BinaryOperation binaryOperation;
		struct Expression_Block block;

		struct{
			struct Type* type;
			void* data;
		}compileTime_value;
	};
};

size_t Expression_toString(const struct Expression* expression,Stringp out);
bool Expression_evaluate(struct Expression* expression,const struct Context* context);
struct Type* Expression_getType(const struct Expression* expression,struct Context* context);
void Expression_free(struct Expression** expression);

#endif
