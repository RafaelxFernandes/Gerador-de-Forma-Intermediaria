%{
    //Includes
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <map>
    #include <iostream>

    //Using
    using namespace std;
    
    //Variáveis globais
    int token;

    //Funções utilizadas
    string nome_token(int);
    void casa(int);

    //Regras da gramática
    void A();
    void E();
    void E_linha();
    void T();
    void T_linha();
    void F();

    enum { _PRINT = 256, _ID, _INT, _FLOAT, _STRING };

    map<int, string> nome_tokens{
        { _PRINT, "print" },
        { _ID, "id" },
        { _INT, "int" },
        { _FLOAT, "float" },
        { _STRING, "string" }
    };
%}
     
DIGITO  [0-9]
LETRA   [A-Za-z_]
WS      [ \t\n]

PRINT   "print"

ID      {LETRA}({LETRA}|{DIGITO})*
INT     {DIGITO}+
FLOAT   {INT}("."{INT})?([E|e]("+"|"-")?{INT})?

STRING  \"(\"\"|\\\"|[^\n\"])*\"

RESTO   [^\n]

%%

{WS}     {}

{PRINT}  { return _PRINT; }

{ID}     { return _ID; }
{INT}    { return _INT; }
{FLOAT}  { return _FLOAT; }

{STRING} { return _STRING; }

{RESTO}  { return *yytext; }

%%

int main(){
    token = yylex();
    
    while(token != 0){
        A();
    }

    return 0;
}

string nome_token(int token){
    if(nome_tokens.find(token) != nome_tokens.end()){
        return nome_tokens[token];
    } else{
        string r;
        r = token;
        return r;
    }
}

void casa(int esperado){
    if(token == esperado){
        token = yylex();
    } else{
        cout << "Esperado" << nome_token(esperado) << " ,encontrado: " << nome_token(token) << endl;
        exit(1);
    }
}

//Início das regras da gramática
void A(){
    switch(token){
        case _PRINT:
            casa(_PRINT);
            F();
            if(yytext == ";"){
                casa(';');
            }
        break;
        
        case _ID:
            cout << yytext << endl;
            casa(_ID);
            casa('=');
            E();
            cout << '=' << endl;
            casa(';');
        break;
    }
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
            cout << '+' << endl;
            E_linha();
        break;

        case '-':
            casa('-');
            T();
            cout << '-' << endl;
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
            cout << '*' << endl;
            T_linha();
        break;

        case '/':
            casa ('/');
            F();
            cout << '/' << endl;
            T_linha();
        break;
    }
}

void F(){
    switch(token){
        case _ID:
            cout << yytext << '@' << endl;
            casa(_ID);
        break;

        case _INT:
            cout << yytext << endl;
            casa(_INT);
        break;

        case _FLOAT:
            cout << yytext << endl;
            casa(_FLOAT);
        break;

        case _STRING:
            cout << yytext << endl;
            casa(_STRING);
        break;

        case '(':
            casa('(');
            E();
            casa(')');
        break;

        default:
            //Erro
            cout << "Operando esperado, encontrado: " << yytext << endl;
        break;    
    }
}