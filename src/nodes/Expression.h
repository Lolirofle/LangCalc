#ifndef __LOLIROFLE_TCALC_NODE_EXPRESSION_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_EXPRESSION_H_INCLUDED__

#include "Expressions.h"

struct Type;

enum Expression_Kind{
	EXPRESSION_CONSTANTCALL,
	EXPRESSION_VARIABLECALL,
	EXPRESSION_FUNCTIONCALL,
	EXPRESSION_UNARYOPERATION,
	EXPRESSION_BINARYOPERATION
};

struct Expression{
	struct Type* type;
	enum Expression_Kind kind;
	union{
		struct Expression_VariableCall variableCall;
		struct Expression_FunctionCall functionCall;
		struct Expression_ConstantCall constantCall;
		struct Expression_UnaryOperation unaryOperation;
		struct Expression_BinaryOperation binaryOperation;
	};
};

size_t Expression_toString(struct Expression* expression,Stringp out);

#endif
