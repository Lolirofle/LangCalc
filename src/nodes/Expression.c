#include "Expression.h"

#include <stdio.h>
#include <string.h>
#include <lolie/Math.h>
#include <lolie/TypeAliases.h>

size_t Expression_toString(struct Expression* expression,Stringp out){
	switch(expression->kind){
		case EXPRESSION_CONSTANTCALL:
			switch(expression->constantCall.kind){
				case EXPRESSION_CONSTANTCALL_NUMERIC:
					return Stringp_sput(out,3,
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
					return Stringp_sput(out,3,
						STRINGP("String(",7),
						expression->constantCall.string,
						STRINGP(")",1)
					);
			}
			break;
		case EXPRESSION_VARIABLECALL:
			return Stringp_sput(out,3,
				STRINGP("Variable(",9),
				expression->variableCall.name,
				STRINGP(")",1)
			);
		case EXPRESSION_FUNCTIONCALL:
			return Stringp_sput(out,3,
				STRINGP("Function(",9),
				expression->functionCall.name,
				STRINGP(")",1)
			);
		case EXPRESSION_STRUCTURECALL:
			return Stringp_sput(out,2,
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
	}
	return 0;
}
