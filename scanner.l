%{
/* COSMOS Language - Lexical Analyzer (Phase 1)
   Inspired by Dr. Neil deGrasse Tyson, Interstellar & Astrophysics
   Student: Usman Shahid | Roll No: L1F22BSCS1057
   Total Keywords: 16 | Operators: 4 | Punctuations: 3
*/
#include <stdio.h>
#include <string.h>
int line_num = 1;

void print_token(const char *type, const char *lexeme) {
    printf("Line %d: %s -> %s\n", line_num, type, lexeme);
}
%}

%option noyywrap

DIGIT   [0-9]
LETTER  [A-Za-z_]
EXP     [eE][+-]?{DIGIT}+
ID      {LETTER}({LETTER}|{DIGIT})*
WS      [ \t\r]+

%%

\n                      { line_num++; }

\"([^\"\\\n]|\\.)*\"    { print_token("STRING", yytext); }

"universe"      { print_token("KW_UNIVERSE", yytext); }      // main
"star"          { print_token("KW_STAR", yytext); }         // int
"planet"        { print_token("KW_PLANET", yytext); }       // float
"galaxy"        { print_token("KW_GALAXY", yytext); }       // string
"nebula"        { print_token("KW_NEBULA", yytext); }       // function
"orbit"         { print_token("KW_ORBIT", yytext); }        // if
"gravity"       { print_token("KW_GRAVITY", yytext); }      // else
"supernova"     { print_token("KW_SUPERNOVA", yytext); }    // return
"cosmic"        { print_token("KW_COSMIC", yytext); }       // void
"blackhole"     { print_token("KW_BLACKHOLE", yytext); }    // break
"quasar"        { print_token("KW_QUASAR", yytext); }       // continue
"lightyear"     { print_token("KW_LIGHTYEAR", yytext); }    // while
"eventhorizon"  { print_token("KW_EVENTHORIZON", yytext); } // for
"darkmatter"    { print_token("KW_DARKMATTER", yytext); }   // const
"astrophysics"  { print_token("KW_ASTROPHYSICS", yytext); } // class
"observe"       { print_token("KW_OBSERVE", yytext); }      // cout / print

"fusion"        { print_token("OP_FUSION", yytext); }       // +
"collapse"      { print_token("OP_COLLAPSE", yytext); }     // -
"radiate"       { print_token("OP_RADIATE", yytext); }      // *
"expand"        { print_token("OP_EXPAND", yytext); }       // /

"launch"        { print_token("OP_LAUNCH", yytext); }       // =
"::"            { print_token("PUNCT_SCOPE", yytext); }
"{"             { print_token("LBRACE", yytext); }
"}"             { print_token("RBRACE", yytext); }
"("             { print_token("LPAREN", yytext); }
")"             { print_token("RPAREN", yytext); }
";"             { print_token("SEMICOLON", yytext); }

{DIGIT}+{EXP}                   { print_token("NUMBER_EXP", yytext); }
{DIGIT}*"."{DIGIT}+({EXP})?     { print_token("NUMBER_FLOAT", yytext); }
{DIGIT}+                        { print_token("NUMBER_INT", yytext); }

{ID}                            { print_token("IDENTIFIER", yytext); }
{WS}                            { /* ignore */ }

@.{0,20}                        { printf("Line %d: ERROR -> %s (invalid identifier)\n", line_num, yytext); }
.                               { printf("Line %d: ERROR -> %s\n", line_num, yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("File open error"); return 1; }
        yyin = f;
    }
    yylex();
    printf("\nCOSMOS Scanner: Mission Accomplished!\n");
    return 0;
}