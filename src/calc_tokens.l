%{
	#include "calc_rules.h"
	#include <stdlib.h>
	
	void yyerror(char*);

	#define TOKEN(t) (yylval.token = t)
%}

%%

[ \t]|(\/\*(.*)\*\/)|(\/\/([^\n]*)) ;

[;\n] {
	return TOKEN(TOKEN_STATEMENT_END);
}

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

[+\-] {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_1;}
[*/] {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_2;}
[\^]  {yylval.operator = STRINGCP(yytext,yyleng);return TOKEN_BINARYOPERATOR_3;}

[+\-*/\^]?[\-+/*\^!#$%&<|>~:?@]+ {//Operators
	yylval.operator = STRINGCP(yytext,yyleng);
	return OPERATOR;
}

%%

int yywrap(void){
	return 1;
}
