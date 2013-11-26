#include "Expression.h"

#include <stdio.h>
#include <string.h>
#include <lolie/Math.h>
#include <lolie/TypeAliases.h>
#include <lolie/Memory.h>

size_t Expression_toString(const struct Expression* expression,Stringp out){
	switch(expression->kind){
		case EXPRESSION_CONSTANTCALL:
			switch(expression->constantCall.kind){
				case EXPRESSION_CONSTANTCALL_NUMERIC:
					return Stringp_vcopy(out,3,
						STRINGP("Number(",7),
						expression->constantCall.numeric.number,
						STRINGP(")",1)
					);
				case EXPRESSION_CONSTANTCALL_CHARACTER:{
					size_t len=MIN(7,out.length);
					memcpy(out.ptr,"Char(_)",len);
					if(len>6)
						out.ptr[6]=expression->constantCall.character;
					return len;
				}
				case EXPRESSION_CONSTANTCALL_STRING:
					return Stringp_vcopy(out,3,
						STRINGP("String(",7),
						expression->constantCall.string,
						STRINGP(")",1)
					);
			}
			break;
		case EXPRESSION_VARIABLECALL:
			return Stringp_vcopy(out,3,
				STRINGP("Variable(",9),
				expression->variableCall.name,
				STRINGP(")",1)
			);
		case EXPRESSION_FUNCTIONCALL:
			return Stringp_vcopy(out,3,
				STRINGP("Function(",9),
				expression->functionCall.name,
				STRINGP(")",1)
			);
		case EXPRESSION_STRUCTURECALL:
			return Stringp_vcopy(out,2,
				STRINGP("Structure(",9),
				STRINGP(")",1)
			);
		case EXPRESSION_UNARYOPERATION:{
			const size_t len=Stringp_copy(expression->unaryOperation.operator,out);
			Stringp_increment(&out,len);
			return len+Expression_toString(expression->unaryOperation.value,out);
		}
		case EXPRESSION_BINARYOPERATION:{
			const size_t originalLength=out.length;

			Stringp_copy(STRINGCP("(",1),out);
			Stringp_increment(&out,1);

			Stringp_increment(&out,Expression_toString(expression->binaryOperation.lhs,out));

			Stringp_copy(expression->binaryOperation.operator,out);
			Stringp_increment(&out,expression->binaryOperation.operator.length);

			Stringp_increment(&out,Expression_toString(expression->binaryOperation.rhs,out));

			Stringp_copy(STRINGCP(")",1),out);
			Stringp_increment(&out,1);

			return originalLength-out.length;
		}
		case EXPRESSION_BLOCK:{
			const size_t originalLength=out.length;

			Stringp_copy(STRINGCP("{",1),out);
			Stringp_increment(&out,1);

			LinkedList_forEach(expression->block.statements,expr){
				Stringp_increment(&out,Expression_toString((struct Expression*)expr,out));

				Stringp_copy(STRINGCP("; ",2),out);
				Stringp_increment(&out,2);
			}

			Stringp_copy(STRINGCP("}",1),out);
			Stringp_increment(&out,1);

			return originalLength-out.length;
		}

		case EXPRESSION_COMPILETIME_VALUE:
			return long2str(*(long*)expression->compileTime_value.data,out);
	}
	return 0;
}

bool Expression_evaluate(struct Expression* expression,const struct Context* context){//TODO: Implement function correctly in constant call, everything should simplify to Expression_CompileTime_Value
	if(expression == NULL)
		return false;

	switch(expression->kind){
		case EXPRESSION_COMPILETIME_VALUE:
			return true;
		case EXPRESSION_CONSTANTCALL:
			expression->kind = EXPRESSION_COMPILETIME_VALUE;
			switch(expression->constantCall.kind){
				case EXPRESSION_CONSTANTCALL_NUMERIC:
					expression->compileTime_value.data = smalloc_type_assign(long,decStr2int(expression->constantCall.numeric.number.ptr,expression->constantCall.numeric.number.length));
					return true;
			}
			return false;
		case EXPRESSION_VARIABLECALL://TODO: Implement when contexts and variable declarations are implemented
			//Expression_evaluate(context->getVariable()->value,out);
			return true;
		case EXPRESSION_FUNCTIONCALL:
			return true;//TODO: Implement when functions are implemented
		case EXPRESSION_STRUCTURECALL:

			return true;
		case EXPRESSION_UNARYOPERATION:
			//TODO: Reimplement as function lookups when functions are implemented, and types, and compiler
			Expression_evaluate(expression->unaryOperation.value,context);

			if(expression->unaryOperation.value->kind == EXPRESSION_COMPILETIME_VALUE){
				if(expression->unaryOperation.operator.length==1){
					#define expr (*(long*)expression->unaryOperation.value->compileTime_value.data)
					#define Expression_CompileTime_setValue(expr) expression->compileTime_value.data = smalloc_type_assign(long,(expr))
					#define Expression_CompileTime_isOp(str,len) Memory_equals(str,expression->unaryOperation.operator.ptr,len)

					if(Expression_CompileTime_isOp("-",1))
						Expression_CompileTime_setValue(-expr);
					else
						return false;
					expression->kind = EXPRESSION_COMPILETIME_VALUE;

					#undef expr
					#undef Expression_CompileTime_setValue
					#undef Expression_CompileTime_isOp
				}
			}
			return true;
		case EXPRESSION_BINARYOPERATION:{
			//TODO: Same as unary operation todo
			Expression_evaluate(expression->binaryOperation.lhs,context);
			Expression_evaluate(expression->binaryOperation.rhs,context);

			if(expression->binaryOperation.lhs->kind == EXPRESSION_COMPILETIME_VALUE &&
			   expression->binaryOperation.rhs->kind == EXPRESSION_COMPILETIME_VALUE){
				if(expression->binaryOperation.operator.length==1){
					#define lhsExpr (*(long*)expression->binaryOperation.lhs->compileTime_value.data)
					#define rhsExpr (*(long*)expression->binaryOperation.rhs->compileTime_value.data)
					#define Expression_CompileTime_setValue(expr) expression->compileTime_value.data = smalloc_type_assign(long,(expr))
					#define Expression_CompileTime_isOp(str,len) Memory_equals(str,expression->binaryOperation.operator.ptr,len)

					if(Expression_CompileTime_isOp("+",1))
						Expression_CompileTime_setValue(lhsExpr+rhsExpr);
					else if(Expression_CompileTime_isOp("-",1))
						Expression_CompileTime_setValue(lhsExpr-rhsExpr);
					else if(Expression_CompileTime_isOp("*",1))
						Expression_CompileTime_setValue(lhsExpr*rhsExpr);
					else if(Expression_CompileTime_isOp("/",1))
						Expression_CompileTime_setValue(lhsExpr/rhsExpr);
					else
						return false;
					expression->kind = EXPRESSION_COMPILETIME_VALUE;

					#undef lhsExpr
					#undef rhsExpr
					#undef Expression_CompileTime_setValue
					#undef Expression_CompileTime_isOp
				}
			}
		}	return true;
	}
	return false;
}

void Expression_free(struct Expression** expression){
	switch((*expression)->kind){
		case EXPRESSION_UNARYOPERATION:
			Expression_free(&(*expression)->unaryOperation.value);
			break;
		case EXPRESSION_BINARYOPERATION:
			Expression_free(&(*expression)->binaryOperation.lhs);
			Expression_free(&(*expression)->binaryOperation.rhs);
			break;
		case EXPRESSION_BLOCK:
			break;
		case EXPRESSION_COMPILETIME_VALUE:
			sfree(&(*expression)->compileTime_value.data);
			break;
		default:
			break;
	}
	sfree((void**)expression);
}


struct Type* Expression_getType(const struct Expression* expression,struct Context* context){
	return NULL;//TODO: Implement later on when compiling is implemented
}
