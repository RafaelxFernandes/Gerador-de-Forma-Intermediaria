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
    
    //Variáveis globais
    int token;
    string lexema;
    vector<string> pilha;
    map<string, double> var;

    //Funções utilizadas
    int next_token();
    void casa();
    //Regras da gramática
    void A();
    void E();
    void E_linha();
    void T();
    void T_linha();
    void F();

    enum { _NUMERO = 256, _ID, _PRINT };

%}
     
DIGITO  [0-9]
LETRA   [A-Za-z_]
WS      [ \t\n]

NUMERO  {DIGITO}+
ID      {LETRA}({LETRA}|{DIGITO})*

PRINT ^print$

%%

{WS}    {}

{NUMERO} { return _NUMERO; }
{ID}    { return _ID; }

{PRINT} { return _PRINT; }

%%

int main(){
    token = next_token();
    
    while(token != 0){
        A();
    }

    return 0;
}

int next_token(){
    return yylex();
}

void casa(int esperado){
    if(token == esperado){
        token = next_token();
    } else{
        cout << "Esperado, " << esperado << "encontrado: " << token << endl;
        exit(1);
    }
}

//Início das regras da gramática
void A(){
    switch(token){
        case _ID:
            casa(_ID);
            cout << lexema << endl;
            casa('=');
            E();
            cout << '=' << endl;
            break;
        

        case _PRINT:
            token = next_token(); //Não queremos imprimir "print a", mas sim "a @"
            casa(_PRINT);
            F();
            if(lexema == ";"){
                casa(';');
            }
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
            casa(_ID);
            cout << lexema << '@' << endl;
        break;

        case _NUMERO:
            casa(_NUMERO);
            cout << lexema << endl;
        break;

        case '(':
            casa('(');
            E();
            casa(')');
        break;

        default:
            //Erro
            cout << "Operando esperado, encontrado" << lexema << endl;    
    }
} 
//Fim das regras da gramática