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
    int next_token();
    void casa();

    //Regras da gramática
    void A();
    void E();
    void E_linha();
    void T();
    void T_linha();
    void F();

    enum { tk_num = 256, tk_id, tk_print };

    map<int, string> nome_tokens{
        { tk_num, "numero" },
        { tk_id, "id" },
        { tk_print, "print" }
    };
%}
     
DIGITO  [0-9]
LETRA   [A-Za-z_]
WS      [ \t\n]

NUMERO  {DIGITO}+
ID      {LETRA}({LETRA}|{DIGITO})*

PRINT ^print$

%%

{WS}    {}

{NUMERO} { return tk_num; }
{ID}     { return tk_id; }

{PRINT}  { return tk_print; }

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
        cout << "Esperado" << esperado << " ,encontrado: " << nome_token(token) << endl;
        exit(1);
    }
}

//Início das regras da gramática
void A(){
    switch(token){
        case tk_id:
            casa(tk_id);
            cout << yytext << endl;
            casa('=');
            E();
            cout << '=' << endl;
        break;       

        case tk_print:
            token = yylex();
            casa(tk_print);
            F();
            if(yytext == ";"){
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
        case tk_id:
            casa(tk_id);
            cout << yytext << '@' << endl;
        break;

        case tk_num:
            casa(tk_num);
            cout << yytext << endl;
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
//Fim das regras da gramática