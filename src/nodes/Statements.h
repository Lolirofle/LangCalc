#ifndef __LOLIROFLE_TCALC_NODE_STATEMENTS_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_STATEMENTS_H_INCLUDED__

#include <lolie/Stringp.h>
#include <lolie/LinkedList.h>

struct Statement;
struct Expression;

struct Statement_StructureSignature{
	LinkedList* /*<Statement_VariableDeclaration*>*/ fields;
};

struct Statement_VariableDeclaration{
	Stringcp type;
	Stringcp name;
	struct Expression* value;
};

struct Statement_FunctionDeclaration{
	Stringcp name;
	struct Statement_StructureSignature* parameters;
	struct Expression* body;
};

struct Statement_StructureDeclaration{
	Stringcp name;
	struct Statement_StructureSignature* structure;
};

struct Statement_VariableAssignment{
	Stringcp name;
	struct Expression* value;
};

#endif
