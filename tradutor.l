%{
    //Includes
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <vector>
    #include <map>
    #include <iostream>

    //Using
    using namespace std;

    //Funções utilizadas
    void A();
    void E();
    void E_linha();
    void T();
    void T_linha();
    void F();
    void casa();
    int next_token();
    void print();
    void erro();

    //Variáveis globais
    string lexema;
    vector<string> pilha;
    map<string, double> var;
%}
     
DIGITO  [0-9]
LETRA   [A-Za-z_]
WS      [ \t\n]

NUMERO  {DIGITO}+
ID      {LETRA}({LETRA}|{DIGITO})*
INT     {DIGITO}+
FLOAT   {INT}("."{INT})?([E|e]("+"|"-")?{INT})?

STRING  \"(\"\"|\\\"|[^\n\"])*\"
COMENTARIO \/\*(((([^\*])*\*(\*)*([^\*\/]))*)(([^\*])*\*(\*)*))\/

RESTO [^\n]

%%

{WS}    {}

"for"   { return _FOR; }
"if"    { return _IF; }

{INT}   { return _INT; }
{FLOAT} { return _FLOAT; }

">="    { return _MAIG; }
"<="    { return _MEIG; }
"=="    { return _IG; }
"!="    { return _DIF; }

{STRING} { return _STRING; }
{COMENTARIO} { return _COMENTARIO; }

{ID}    { return _ID; }

{RESTO} { return *yytext; }

%%

int next_token(){
    return yylex();
}

void casa(int esperado){
    if(token == esperado){
        token = next_token();
    } else{
        cout << "Esperado, " << esperado
            << "encontrado: " << token << endl;
        exit(1);
    }
}

void print(lexema){
    cout << lexema << endl;
}

//>>> Conferir se está certo, pois está igual ao print <<<
void erro(lexema){
    cout << lexema << endl;
}

//Início das regras da gramática
void A(){
    casa(ID);
    print(lexema);
    casa('=');
    E();
    print('=');
}

void E(){
    T();
    E_linha();
}

void E_linha(){
    switch(token){
        case '+':
            casa('+');
            T();
            print('+');
            E_linha();
        break;

        case '-':
            casa('-');
            T();
            print('-');
            E_linha();
        break;
    }
}

void T(){
    F();
    T_linha();
}

void T_linha(){
    switch(token){
        case '*':
            casa('*');
            F();
            print('*');
            T_linha();
        break;

        case '/':
            casa ('/');
            F();
            print('/');
            T_linha();
        break;
    }
}

void F(){
    switch(token){
        case ID:
            casa(ID);
            print(lexema + '@');
        break;

        case NUMERO:
            casa(NUMERO);
            print(lexema);
        break;

        case '(':
            casa('(');
            E();
            casa(')');
        break;

        default:
        erro("Operando esperado, encontrado" + lexema);    
    }
}
//Fim das regras da gramática