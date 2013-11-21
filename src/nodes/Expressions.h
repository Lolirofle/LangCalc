#ifndef __LOLIROFLE_TCALC_NODE_EXPRESSIONS_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_EXPRESSIONS_H_INCLUDED__

#include <lolie/Stringp.h>
#include <lolie/TypeAliases.h>
#include <lolie/LinkedList.h>

struct Expression;

struct Expression_VariableCall{
	Stringcp name;
};

struct Expression_FunctionCall{
	Stringcp name;
	LinkedList* arguments;
};

enum Expression_ConstantCall_Kind{
	EXPRESSION_CONSTANTCALL_NUMERIC,
	EXPRESSION_CONSTANTCALL_CHARACTER,
	EXPRESSION_CONSTANTCALL_STRING,
};

struct Expression_ConstantCall{
	enum Expression_ConstantCall_Kind kind;
	union{
		struct{
			Stringcp number;
			byte base;
		}numeric;

		unsigned int character;
		Stringcp string;
	};
};

struct Expression_StructureCall{
	LinkedList* /*<struct Expression*>*/ fields;
};

struct Expression_UnaryOperation{
	Stringcp operator;
	struct Expression* value;
};

struct Expression_BinaryOperation{
	Stringcp operator;
	struct Expression* lhs;
	struct Expression* rhs;
};

#endif
