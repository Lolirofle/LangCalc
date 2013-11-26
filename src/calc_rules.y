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

	struct Statement_FunctionDeclaration functionDeclaration;
	struct Statement_VariableDeclaration variableDeclaration;
	struct Statement_StructureDeclaration structureDeclaration;

	struct Expression_UnaryOperation unaryOperation;
	struct Expression_BinaryOperation binaryOperation;
	struct Expression_FunctionCall functionCall;
	struct Expression_StructureCall structureCall;
	struct Expression_Block block;

	struct Statement_StructureSignature structureSignature;

	//Storage for data
	LinkedList* list;
	char character;
}

//Tokens
%token INTEGER IDENTIFIER OPERATOR TOKEN_BINARYOPERATOR_1 TOKEN_BINARYOPERATOR_2 TOKEN_BINARYOPERATOR_3
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END TOKEN_VARIABLEDECLARATION TOKEN_FUNCTIONDECLARATION TOKEN_STRUCTUREDECLARATION TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END

//Operator precedence
%right TOKEN_EQUAL
%left TOKEN_BINARYOPERATOR_1
%left TOKEN_BINARYOPERATOR_2
%right TOKEN_BINARYOPERATOR_3
%left OPERATOR
%left UNARYOPERATOR

//Types from yylval for the rules
%type <integer> INTEGER
%type <identifier> IDENTIFIER
%type <operator> OPERATOR TOKEN_BINARYOPERATOR_1 TOKEN_BINARYOPERATOR_2 TOKEN_BINARYOPERATOR_3 operator
%type <list> structuresignaturelist structurecalllist statementlist

%type <expression> expression
%type <unaryOperation> unaryoperation
%type <binaryOperation> binaryoperation
%type <functionCall> functioncall
%type <structureCall> structurecall
%type <block> block
%type <variableDeclaration> variabledeclaration
%type <functionDeclaration> functiondeclaration
%type <structureDeclaration> structuredeclaration
%type <structureSignature> structuresignature
%type <statement> statement

//Start in rule `program`
%start program

//Rules
%%

program: program statement TOKEN_STATEMENT_END ;//{ LinkedList_push(&main_context->statements,malloc(sizeof(int)));*(int*)(main_context->statements->ptr)=$1; }
       | 
       ;

//////////////////////////////////////////////////////////////
//Statements
statement: expression                        { $$ = smalloc_type_assign(struct Statement,((struct Statement){.kind=STATEMENT_EXPRESSION,.expression=*$1}));static char outBuffer[512];Expression_evaluate($1,NULL);Stringp_print(STRINGP(outBuffer,Expression_toString($1,STRINGP(outBuffer,512))));putchar('\n');Expression_free(&$1);}
         | IDENTIFIER TOKEN_EQUAL expression { $$ = smalloc_type_assign(struct Statement,((struct Statement){.kind=STATEMENT_VARIABLEASSIGNMENT,.variableAssignment={.name=$1,.value=$3}})); }
         | functiondeclaration               { $$ = smalloc_type_assign(struct Statement,((struct Statement){.kind=STATEMENT_FUNCTIONDECLARATION,.functionDeclaration=$1})); }
         | variabledeclaration               { $$ = smalloc_type_assign(struct Statement,((struct Statement){.kind=STATEMENT_FUNCTIONDECLARATION,.variableDeclaration=$1})); }
         | structuredeclaration              { $$ = smalloc_type_assign(struct Statement,((struct Statement){.kind=STATEMENT_FUNCTIONDECLARATION,.structureDeclaration=$1})); }
         ;

functiondeclaration: TOKEN_FUNCTIONDECLARATION IDENTIFIER structuresignature TOKEN_EQUAL expression { $$ = (struct Statement_FunctionDeclaration){.name=$2,.parameters=smalloc_type_assign(struct Statement_StructureSignature,$3),.body=$5}; }
                   | TOKEN_FUNCTIONDECLARATION IDENTIFIER structuresignature                        { $$ = (struct Statement_FunctionDeclaration){.name=$2,.parameters=smalloc_type_assign(struct Statement_StructureSignature,$3),.body=NULL}; }
                   ;

variabledeclaration: TOKEN_VARIABLEDECLARATION IDENTIFIER                        { $$ = (struct Statement_VariableDeclaration){.name=$2,.value=NULL}; }
                   | TOKEN_VARIABLEDECLARATION IDENTIFIER TOKEN_EQUAL expression { $$ = (struct Statement_VariableDeclaration){.name=$2,.value=$4}; }
                   ;

structuredeclaration: TOKEN_STRUCTUREDECLARATION IDENTIFIER TOKEN_EQUAL structuresignature { $$ = (struct Statement_StructureDeclaration){.name=$2,.structure=smalloc_type_assign(struct Statement_StructureSignature,$4)}; }
                    | TOKEN_STRUCTUREDECLARATION IDENTIFIER                                { $$ = (struct Statement_StructureDeclaration){.name=$2,.structure=NULL}; }
                    ;

//////////////////////////////////////////////////////////////
//Expressions
expression: INTEGER               { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_CONSTANTCALL,.constantCall={.kind=EXPRESSION_CONSTANTCALL_NUMERIC,.numeric={.number=$1,.base=10}}})); }
          | IDENTIFIER            { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_VARIABLECALL,.variableCall={.name=$1}})); }
          | TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = $2; }
          | unaryoperation        { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_UNARYOPERATION,.unaryOperation=$1})); }
          | binaryoperation       { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_BINARYOPERATION,.binaryOperation=$1})); }
          | functioncall          { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_FUNCTIONCALL,.functionCall=$1})); }
          | structurecall         { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_STRUCTURECALL,.structureCall=$1})); }
          | block                 { $$ = smalloc_type_assign(struct Expression,((struct Expression){.kind=EXPRESSION_BLOCK,.block=$1})); }
          ;

operator: TOKEN_BINARYOPERATOR_1 { $$ = $1; }
        | TOKEN_BINARYOPERATOR_2 { $$ = $1; }
        | TOKEN_BINARYOPERATOR_3 { $$ = $1; }
        | OPERATOR               { $$ = $1; }
        ;

binaryoperation: expression TOKEN_BINARYOPERATOR_1 expression { $$ = (struct Expression_BinaryOperation){$2,$1,$3}; }
               | expression TOKEN_BINARYOPERATOR_2 expression { $$ = (struct Expression_BinaryOperation){$2,$1,$3}; }
               | expression TOKEN_BINARYOPERATOR_3 expression { $$ = (struct Expression_BinaryOperation){$2,$1,$3}; }
               | expression OPERATOR expression               { $$ = (struct Expression_BinaryOperation){$2,$1,$3}; }
               ;

unaryoperation: operator expression %prec UNARYOPERATOR { $$ = (struct Expression_UnaryOperation){$1,$2}; }
              ;

functioncall: IDENTIFIER structurecall { $$ = (struct Expression_FunctionCall){.name=$1,.arguments=$2.fields}; }
            ;

structurecall: TOKEN_PARENTHESIS_BEGIN structurecalllist TOKEN_PARENTHESIS_END { $$ = (struct Expression_StructureCall){$2}; }
             ;

structurecalllist: /*Empty*/                        { $$ = NULL; }
                 | expression                       { $$ = NULL;LinkedList_push(&$$,$1); }
                 | structurecalllist ',' expression { LinkedList_push(&$1,$3); $$ = $1; }
                 ;

block : TOKEN_BLOCK_BEGIN statementlist TOKEN_BLOCK_END {$$ = (struct Expression_Block){.statements=$2};;}
      | TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END               {$$ = (struct Expression_Block){.statements=NULL};}

//////////////////////////////////////////////////////////////
//Other
structuresignature: TOKEN_PARENTHESIS_BEGIN structuresignaturelist TOKEN_PARENTHESIS_END { $$ = (struct Statement_StructureSignature){$2}; }
                  ;

structuresignaturelist: /*Empty*/                                      { $$ = NULL; }
                      | variabledeclaration                            { $$ = NULL;LinkedList_push(&$$,smalloc_type_assign(struct Statement_VariableDeclaration,$1)); }
                      | structuresignaturelist ',' variabledeclaration { LinkedList_push(&$1,smalloc_type_assign(struct Statement_VariableDeclaration,$3)); $$ = $1; }
                      ;

statementlist: /*Empty*/                   { $$ = NULL; }
             | statement                   { $$ = NULL;LinkedList_push(&$$,$1); }
             | statementlist ';' statement { LinkedList_push(&$1,$3); $$ = $1; }

%%

void yyerror(char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
