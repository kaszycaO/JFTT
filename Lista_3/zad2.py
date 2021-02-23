#!usr/bin/python3

from ply import lex
from ply import yacc



#----------------- LEXER -----------------------#

tokens = (
    'NUMBER', 'PLUS', 'MINUS', 'MUL', 'DIV', 'LPAREN', 'RPAREN', 'POW', 'NPOW'
)

t_PLUS    = r'\+'
t_MINUS   = r'-'
t_MUL   = r'\*'
t_DIV  = r'/'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_NPOW= r'\^\-'
t_POW = r'\^'

t_ignore_LINECONT = r'\\\n'

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)


def t_error(t):
    print("Nieprawidlowy znak: '%s'" % t.value[0])
    t.lexer.skip(1)

t_ignore = ' \t'

t_ignore_COMMENT = r'\#.*'

lexer = lex.lex()

#----------------- PARSER -----------------------#

field = 1234577
phi_field = 1234576
notation = ""
err = False;

def division(x, y):
    result = (x * modInverse(y)) % field
    return result

def modInverse(num):
    base = field
    y = 0
    x = 1

    if base == 1:
        return 0;

    while num > 1:

        quotient = num // base
        temp = base

        # Algorytm Euklidesa
        base = num % base
        num = temp
        temp = y

        y = x - quotient * y
        x = temp

    if x < 0:
        x = x + field

    return x

def power(x, y):

    res = 1
    # jezeli x % field = 0
    x = x % field
    if x == 0:
        return 0
    while y > 0:
        if y % 2 == 1:
            res = (res*x) % field

        y = y>>1 # y = y/2
        x = (x*x) % field

    return res


precedence = (

    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
    ('nonassoc', 'NPOW'),
    ('nonassoc', 'POW'),
    ('right', 'NEG'),

)


def p_input_expr(p):
    '''input : empty
             | expression
    '''

    global notation
    global err
    if err != True and p[1] != None:
        print(notation)
        print("Wynik: ", p[1])
    notation = ""
    err = False


def p_get_num(p):
    '''expression : num'''
    global notation
    p[0] = p[1]

def p_pow_neg(p):
    'expression : expression NPOW expression '

    global notation
    p[0] = power(p[1], phi_field - p[3])
    lim = len(notation) - len(str(p[3] % field)) - 1
    notation = notation[:lim]
    notation += str(phi_field - p[3]) + " "
    notation += "^" + " "

def p_num_neg(p):
    '''
        num : NUMBER
            | MINUS NUMBER %prec NEG
    '''
    global notation

    if p[1] == '-':
        p[0] = field - p[2]
        notation += (str(p[0]) + " ")

    else:
        p[0] = p[1] % field
        notation += (str(p[0]) + " ")


def p_expression(p):
     '''
        expression  : expression PLUS expression
                    | expression MINUS expression
                    | expression MUL expression
                    | expression DIV expression
                    | expression POW expression
                    | LPAREN expression RPAREN
     '''
     global notation
     global err

     if p[2] == '+':
         p[0] = (p[1] + p[3]) % field
         notation += '+' + " "
     elif p[2] == '-':
         p[0] = (p[1] - p[3]) % field
         notation += '-' + " "
     elif p[2] == '*':
         p[0] = (p[1] * p[3]) % field
         notation += '*' + " "
     elif p[2] == '/':
        if p[3] == 0:
            p_error(p)
            err = True
        else:
            p[0] = division(p[1], p[3])
            notation += '/' + " "
     elif p[2] == '^':
         p[0] = power(p[1], p[3])
         notation += '^' + " "
     elif p[1] == '(' and p[3] == ')':
         p[0] = p[2]


def p_error(p):
    global err
    global notation
    print("Błąd! ")
    notation = ""
    err = True

def p_empty(p):
     'empty :'
     pass


parser = yacc.yacc()

while True:
    try:
        s = input()
    except EOFError:
        break
    if not s: continue
    parser.parse(s)

if __name__ == '__main__':
    pass
