%{

#include <stdio.h>
#include "zad1.tab.h"

%}
op  [+\-*/\^\(\)]
blank  [ \t]+
letter [a-zA-Z]
digit [0-9]+
%s comment
%%
<INITIAL>{
    ^#           { BEGIN(comment); }
    \\\n        ;
    {letter}    ECHO;
    {digit}     { sscanf(yytext, "%d", &yylval); return NUM; }
    \^" "*\-    { return NPOW; }
    {op}|\n     return *yytext;
    {blank}     ;
    .           ;
}
<comment>{
    .*\\\n         ;
    .*\n          { BEGIN(INITIAL); }
}
%%
