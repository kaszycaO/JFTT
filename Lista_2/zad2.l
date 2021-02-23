%{
#include <stdio.h>
int yywrap();
int yylex();
%}
/* Dlaczego nie dziala [\\]{2}?[']{3}  */
%s single_quote
%s double_quote
%s triple_single_quote
%s triple_double_quote
%%
<INITIAL>{
    \#.*    ;
    \'      { ECHO; BEGIN(single_quote); }
    \"      { ECHO; BEGIN(double_quote); }
    \'{3}   { ECHO; BEGIN(triple_single_quote); }
    \"{3}   { ECHO; BEGIN(triple_double_quote); }
}
<single_quote>{
    [\\]{2}             { ECHO; }
    \\[']               { ECHO; }
    [']         { ECHO; BEGIN(INITIAL); }
}
<double_quote>{
    [\\]{2}             { ECHO; }
    \\["]               { ECHO; }
    ["]                 { ECHO; BEGIN(INITIAL); }
}
<triple_single_quote>{
    [\\]{2}             { ECHO; }
    \\[']{3}            { ECHO; }
    [']{3}      { ECHO ; BEGIN(INITIAL); }
}
<triple_double_quote>{
    [\\]{2}             { ECHO; }
    \\["]{3}            { ECHO; }
    ["]{3}      { ECHO; BEGIN(INITIAL); }
}
%%

int yywrap()
{
    printf("\n");
    return 1;
}

int main()
{
  return yylex();

}
