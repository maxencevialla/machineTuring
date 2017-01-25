%option noyywrap
%{
/* * * * * * * * * * * *
 * * * DEFINITIONS * * *
 * * * * * * * * * * * */
%}

%{
int line_num = 1;
%}

alphanum [0-9a-zA-Z ]
%%

%{
/* * * * * * * * * 
 * * * RULES * * *
 * * * * * * * * */
%}

^{alphanum}+,{alphanum}:[{alphanum}><],{alphanum}+$  { lancer(); }

.* { printf("%d: error: %s \n", line_num, yytext); }
\n { line_num++; }
%%

/* * * * * * * * * * * 
 * * * USER CODE * * *
 * * * * * * * * * * *
 */
int main(int argc, char *argv[]) {
	char filename[30];
    strcpy(filename, argv[1]);
	yyin = fopen(filename, "r+");
  yylex();
}

void moveLeft() {
	
	printf("Move left\n");
	
}

void moveRight() {
	
	printf("Move right\n");
	
}

void lancer() {
	
	printf("Instruction read : %s\n", yytext);
	
}

/*char ** tranche(char *chaine, char car) {
	
}*/
