#ifndef __LOLIROFLE_TCALC_NODE_STATEMENTS_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_STATEMENTS_H_INCLUDED__

#include <lolie/Stringp.h>

struct Statement;
struct Expression;

struct Statement_VariableDeclaration{
	Stringp type;
	Stringp name;
	struct Expression* value;
};

struct Statement_FunctionDeclaration{
	Stringp name;
	struct Expression* body;
};

struct Statement_VariableAssignment{
	Stringp name;
	struct Expression* value;
};

#endif
