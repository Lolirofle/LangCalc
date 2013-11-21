#ifndef __LOLIROFLE_TCALC_NODE_STATEMENT_H_INCLUDED__
#define __LOLIROFLE_TCALC_NODE_STATEMENT_H_INCLUDED__

#include "Expression.h"
#include "Statements.h"

enum Statement_Kind{
	STATEMENT_EXPRESSION,
	STATEMENT_VARIABLEDECLARATION,
	STATEMENT_FUNCTIONDECLARATION,
	STATEMENT_STRUCTUREDECLARATION,
	STATEMENT_VARIABLEASSIGNMENT
};

struct Statement{
	enum Statement_Kind kind;
	union{
		struct Expression expression;
		struct Statement_VariableDeclaration variableDeclaration;
		struct Statement_FunctionDeclaration functionDeclaration;
		struct Statement_StructureDeclaration structureDeclaration;
		struct Statement_VariableAssignment variableAssignment;
	};
};

#endif
