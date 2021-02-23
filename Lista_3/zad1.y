%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror(char *s);
int division(long long int x, long long int y);
void neg_shift(int data, int shift);
void string_append(char* a);
int modInverse(int a);
unsigned long long int power(unsigned long long int x, unsigned int y);
const int field = 1234577;
// phi(p) = p - 1, p - PRIME
const int phi_field = 1234576;
int err = 0;
char *notation = "";
int nt_size = 1;

%}
%token NUM
%token '('
%token ')'
%left '-' '+'
%left '*' '/'
%nonassoc '^'
%nonassoc NPOW
%precedence NEG
%%
input:
	%empty
|	input line
;
line:
	'\n'
|	exp	'\n'	{
					if (err == 0) printf("%s\nWynik: %d\n", notation, $1);
					else err = 0;
					notation = "";
					nt_size = 1;
				}
|	error '\n'	{ notation = ""; nt_size = 1; err = 0;}
;
exp:
	NUM					{ $$ = $1 % field; char num[9]; sprintf(num, "%d ", $$); string_append(num);}
|	exp '+' exp 		{ $$ = ($1 % field + $3 % field) % field; string_append("+ ");}
|	exp '-' exp 		{ $$ = ($1 % field + (field - $3)) % field; string_append("- ");}
|	exp '*'	exp 		{ $$ = ($1 % field * $3 % field) % field; string_append("* ");}
|   exp '/' exp			{
							if ($3 == 0)
                            {
                                yyerror("Dzielenie przez 0");
								err = 1;
							}
							else
                            {
                                $$ = division($1, $3);
								string_append("/ ");
							}
						}
|   exp NPOW exp		{
							$$ = power($1, phi_field - $3);
                            neg_shift($3, 1);
							string_append("^ ");
						}
|	exp '^' exp			{ $$ = power($1, $3); string_append("^ "); }
|	'-' exp	%prec NEG 	{ $$ = field - $2; neg_shift($2, 2); }
|   '(' exp ')'			{ $$ = $2; }
;
%%


void string_append(char* a){

	char *new_buff = (char*) malloc((strlen(notation)*sizeof(char)));
	strcpy(new_buff, notation);
	strcat(new_buff, a);
	notation = new_buff;
}
void neg_shift(int data, int shift)
{
    char num[9];

    if(shift == 1)
    {
        sprintf(num, "%d ", data);
        *(notation+strlen(notation)-strlen(num)) = '\0';
        sprintf(num, "%d ", (phi_field - data));
        string_append(num);
    }
    else if(shift == 2)
    {
        sprintf(num, "%d ", data);
        *(notation+strlen(notation)-strlen(num)) = '\0';
        sprintf(num, "%d ", field - data);
        string_append(num);
    }
}


int division(long long int x, long long int y)
{
	long long int result = 0;
	result = (x * modInverse(y)) % field;
	return result;

}

int modInverse(int num)
{
	int base = field;
	// przechowywanie wynikow
    int y = 0, x = 1;

    if (base == 1)
        return 0;

    while (num > 1) {

        int quotient = num / base;
        int temp = base;

        // Algorytm Euklidesa
        base = num % base, num = temp;
        temp = y;

        y = x - quotient * y;
        x = temp;
    }

    if (x < 0)
        x += field;

    return x;
}

unsigned long long int power(unsigned long long int x, unsigned int y)
{
    unsigned long long int res = 1;

    x = x % field;
	// jezeli x % field = 0
    if (x == 0)
		return 0;

    while (y > 0)
    {
        if (y % 2 == 1)
            res = (res*x) % field;

        y = y>>1; // y = y/2
        x = (x*x) % field;
    }
    return res;
}



int yyerror(char *s)
{
	fprintf (stderr, "Błąd!\n");
	err = 1;
}

int main()
{
    return yyparse();
}
