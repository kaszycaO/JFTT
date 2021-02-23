%{
#include <stdio.h>
int yywrap();
int yylex();
int doc = 0;
%}
%s string_s
%s string_d
%s c1
%s c2
%s doc1
%s doc2
%%
<INITIAL>{
    "///"|"//!"    if(doc == 1){ BEGIN(doc1); ECHO; } else BEGIN(c1);
    "/**"|"/*!"    if(doc == 1){ BEGIN(doc2); ECHO; } else BEGIN(c2);

    "//"      { BEGIN(c1); }
    "/*"      { BEGIN(c2); }

    \"        { ECHO; BEGIN(string_d); }
    \'        { ECHO; BEGIN(string_s); }


}
<string_d>{
    \\\n                ;
    \\["]               { ECHO; }
    [\\]{2}?["]         { ECHO; BEGIN(INITIAL); }
}

<string_s>{
    \\\n                ;
    \\[']               { ECHO; }
    [\\]{2}?['']         { ECHO; BEGIN(INITIAL); }
}


<c1>{
    .                  ;
    \n                 { printf("\n"); BEGIN(INITIAL); }
    [\\]+\n            ;
}

<c2>{
    .                  ;
    [\\]{2}?"*/"       { BEGIN(INITIAL); }

}

<doc1>{
    \\\n                { printf("\n"); } 
    .                  { ECHO; }
    [\\]{2}?\n          { ECHO; BEGIN(INITIAL); }

}

<doc2>{
    .                  { ECHO; }
    [\\]{2}?"*/"       { ECHO; BEGIN(INITIAL); }

}

%%

int yywrap()
{
    printf("\n");
    return 1;
}

int main(int argc, char *argv[])
{
  if(argc == 2)
  {
    if(!strcmp(argv[1], "--docs"))
    {
      doc = 1;
    }
  }
  return yylex();

}
