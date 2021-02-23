%{
#include <stdio.h>
int yywrap();
int yylex();
int NL = 0;
int WC = 0;
%}


%%
\\\n                     ;
^(([\t ]*)?(\n))+        ;
[\t ]+$                  ;
^[[:blank:]]+(\n)?       ;
[[:blank:]]+             { printf(" "); }
[^ \t\n\\]+              { printf("%s", yytext); WC++; }
\n                       { ECHO; NL++; }


%%

int yywrap()
{
    printf("-------\n");
    printf("Lines: %d\n", NL);
    printf("Words: %d\n", WC);
    return 1;
}

int main()
{
  return yylex();

}
