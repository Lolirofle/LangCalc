#include "main.h"

#include <stdlib.h>
#include <string.h>
#include <lolie/Essentials.h>

#include "calc_rules.h"
#include "Context.h"
#include "Type.h"

struct Context* main_context;

int main(void){
	//Initialize context
	main_context=malloc(sizeof(struct Context));
	*main_context=(struct Context){
		.types=NULL,
		.variables=NULL,
		.functions=NULL,
	};

	{//Initialize types
		struct Type* type = malloc(sizeof(struct Type));
		*type = (struct Type){
			.name = {malloc(3),3},
			.print = function(void,(void* integer){printf("%d\n",*(int*)integer);})
		};
		memcpy(type->name.ptr,"int",3);

		LinkedList_push(&main_context->types,type);
	}

	//Begin parsing using rules and tokens
	yyparse();
}
