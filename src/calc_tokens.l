%{
	#include "calc_rules.h"
	#include <stdlib.h>
	
	void yyerror(char*);

	#define TOKEN(t) (yylval.token = t)
	#define YY_NO_INPUT
%}

%option nounput

%%

[ \t]|(\/\*(.*)\*\/)|(\/\/([^\n]*)) ;

[;\n] {
	return TOKEN(TOKEN_STATEMENT_END);
}

"var"    return TOKEN_VARIABLEDECLARATION;
"fn"     return TOKEN_FUNCTIONDECLARATION;
"struct" return TOKEN_STRUCTUREDECLARATION;

[A-Za-z][A-Za-z0-9]* {//String identifier
	yylval.identifier = STRINGCP(yytext,yyleng);
	return IDENTIFIER;
}

[0-9]+ {//Integers
	yylval.integer = STRINGCP(yytext,yyleng);
	return INTEGER;
}

"=" return TOKEN_EQUAL;
"(" return TOKEN_PARENTHESIS_BEGIN;
")" return TOKEN_PARENTHESIS_END;
"{" return TOKEN_BLOCK_BEGIN;
"}" return TOKEN_BLOCK_END;

[+\-] {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_1;}
[*/]  {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_2;}
[\^]  {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_3;}

[!#$%&<|>~:?@]|([\-+/*\^!#$%&<|>~:?@][\-+/*\^!#$%&<|>~:?@]+) {//Operators
	yylval.operator = STRINGCP(yytext,yyleng);
	return OPERATOR;
}

%%

int yywrap(void){
	return 1;
}
