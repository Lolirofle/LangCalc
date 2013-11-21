%code requires{
	//Includes
	#include <stdio.h>//Input/output
	#include <lolie/LinkedList.h>//Linked list structure
	#include <lolie/Stringp.h>//String pointer structure

	#include "nodes/Expression.h"
	#include "nodes/Expressions.h"
	#include "nodes/Statement.h"
	#include "nodes/Statements.h"

	#include "main.h"
	#include "Context.h"
	#include "Type.h"

	//Declarations
	void yyerror(char*);
	int yylex(void);
}

//Defines the type of yylval
%union{
	//Token enumerator IDs
	int token;

	//Token storage IDs
	Stringcp integer;
	Stringcp identifier;
	Stringcp operator;

	//Rule data
	struct Expression* expression;
	struct Statement* statement;
	struct Expression_UnaryOperation unaryOperation;
	struct Expression_BinaryOperation binaryOperation;

	char character;
}

//Tokens
%token INTEGER IDENTIFIER OPERATOR TOKEN_BINARYOPERATOR_1 TOKEN_BINARYOPERATOR_2 TOKEN_BINARYOPERATOR_3
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END

//Operator precedence
%left TOKEN_BINARYOPERATOR_1
%left TOKEN_BINARYOPERATOR_2
%right TOKEN_BINARYOPERATOR_3

//Types for the rules in yylval
%type <integer> INTEGER
%type <identifier> IDENTIFIER
%type <operator> binaryoperator OPERATOR TOKEN_BINARYOPERATOR_1 TOKEN_BINARYOPERATOR_2 TOKEN_BINARYOPERATOR_3
%type <expression> expression
%type <unaryOperation> unaryoperation
%type <binaryOperation> binaryoperation
//%type <statement> statement

//Start in `program`
%start program

//Rules
%%

program: program statement TOKEN_STATEMENT_END ;//{ LinkedList_push(&main_context->statements,malloc(sizeof(int)));*(int*)(main_context->statements->ptr)=$1; }
       | 
       ;

statement: expression                        { static char outBuffer[512];Stringp_print(STRINGP(outBuffer,Expression_toString($1,STRINGP(outBuffer,512))));putchar('\n');}
         | IDENTIFIER TOKEN_EQUAL expression { /*sym[$1] = $3;$$ = malloc(sizeof(struct Statement));*$$=(struct Statement){.info={malloc(3),3}};strcpy($$->info.ptr,"var",3);*/ }
         ;

expression: INTEGER               { $$ = smalloc_type_assign(struct Expression,((struct Expression){.type=NULL,.kind=EXPRESSION_CONSTANTCALL,.constantCall={.kind=EXPRESSION_CONSTANTCALL_NUMERIC,.numeric={.number=$1,.base=10}}})); }
          | IDENTIFIER            { $$ = smalloc_type_assign(struct Expression,((struct Expression){.type=NULL,.kind=EXPRESSION_VARIABLECALL,.variableCall={.name=$1}})); }
          | binaryoperation       { $$ = smalloc_type_assign(struct Expression,((struct Expression){.type=NULL,.kind=EXPRESSION_BINARYOPERATION,.binaryOperation=$1})); }
          | unaryoperation        { $$ = smalloc_type_assign(struct Expression,((struct Expression){.type=NULL,.kind=EXPRESSION_UNARYOPERATION,.unaryOperation=$1})); }
          | TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = $2; }
          ;

binaryoperation: expression binaryoperator expression { $$ = (struct Expression_BinaryOperation){$2,$1,$3}; }
               | expression expression          { static char multiplicationChar='*';$$ = (struct Expression_BinaryOperation){STRINGCP(&multiplicationChar,1),$1,$2}; }
               ;

binaryoperator: TOKEN_BINARYOPERATOR_1 {$$ = $1;}
              | TOKEN_BINARYOPERATOR_2 {$$ = $1;}
              | TOKEN_BINARYOPERATOR_3 {$$ = $1;}
              | OPERATOR {$$ = $1;}
              ;

unaryoperation: OPERATOR expression { $$ = (struct Expression_UnaryOperation){$1,$2}; }
              ;

%%

void yyerror(char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
