%{
#include <stdio.h>
#include <math.h>
int yywrap();
int yylex();


typedef struct Stack {
    int data;
    struct Stack *prev;
} myStack;


myStack *createRoot()
{
  return NULL;
}


myStack *createNode(int data)
{
    myStack *node = (myStack*)malloc(sizeof(myStack*));
    node->data = data;
    node->prev = NULL;
    return node;
}

myStack *push(myStack *node, int data)
{
  myStack *el = createNode(data);
  if(node == NULL)
  {
    node = el;
    return node;

  }

  el->prev = node;
  return el;
}



int pop(myStack **node)
{
  int data = (*node)->data;
  *node = (*node)->prev;
  return data;

}

int power(int a, int b)
{
  if(b == 0)
  {
    return 1;
  }
  else if(b < 0)
  {
    printf("Wynik niecałkowity dla potęgi liczb: %d ^ %d \n ", a, b);
    return -1;
  }
  else
  {
    int mul = a;
    for(int i = 1; i < b; i++)
    {
      a *= mul;
    }
    return a;
  }
}
myStack* root;

int check_if_error(){
  if (root == NULL || root->prev == NULL)
  {
    printf("Błąd: za mała liczba argumentów \n");
    return 1;
  }
  else
    return 0;
}


myStack *calculate(myStack *root, char *operation)
{
  if(!check_if_error(root)){
    int data1 = pop(&root);
    int data2 = pop(&root);
    if((data1 == 0 && *operation == '/') || (data1 == 0 && *operation == '%'))
    {
      printf("Dzielenie przez 0 \n");
      root = NULL;
    }
    else
    {
      if(*operation == '+') root = push(root, data2+data1);
      else if(*operation == '-') root = push(root, data2-data1);
      else if(*operation == '*') root = push(root, data2*data1);
      else if(*operation == '/') root = push(root, data2/data1);
      else if(*operation == '^') root = push(root, power(data2,data1));
      else if(*operation == '%') root = push(root, data2%data1);
    }
  }
  else
    root = NULL;

  return root;
}

%}
%s endline
%%
<INITIAL>{
    " "               ;
    [0-9]+|-[0-9]+    { root = push(root, atoi(yytext)); }
    \*{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \/{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \+{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \-{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \^{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \%{1}             { root = calculate(root, yytext); if(root == NULL) BEGIN(endline); }
    \n                {
                        if(root == NULL)
                            ECHO;
                        else if(root->prev == NULL)
                          printf("= %d\n", pop(&root));
                        else
                          printf("Błąd: za mała liczba operatorów\n");
                      }
      .               { printf("Zły symbol \"%s\" \n", yytext); BEGIN(endline); }
}
<endline>{
  .+           ;
  \n           { root = NULL; BEGIN(INITIAL); }
}
%%

int yywrap()
{
    return 1;
}

int main()
{
  root = createRoot();
  return yylex();

}
