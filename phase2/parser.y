%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_num; /* Imported from scanner.l */

void yyerror(const char *s);
%}

/* ==============================================
   TOKEN DECLARATIONS
   ============================================== */
%token KW_UNIVERSE KW_STAR KW_PLANET KW_GALAXY KW_NEBULA
%token KW_ORBIT KW_GRAVITY KW_SUPERNOVA KW_COSMIC
%token KW_BLACKHOLE KW_QUASAR KW_LIGHTYEAR KW_EVENTHORIZON
%token KW_DARKMATTER KW_ASTROPHYSICS KW_OBSERVE

%token OP_FUSION OP_COLLAPSE OP_RADIATE OP_EXPAND OP_LAUNCH
%token PUNCT_SCOPE LBRACE RBRACE LPAREN RPAREN SEMICOLON
%token IDENTIFIER NUMBER STRING_LITERAL

/* Operator Precedence */
%left OP_FUSION OP_COLLAPSE
%left OP_RADIATE OP_EXPAND

%%

/* ==============================================
   GRAMMAR RULES WITH LOGGING
   ============================================== */

program:
    KW_UNIVERSE IDENTIFIER LPAREN RPAREN LBRACE stmt_list RBRACE
    { 
        printf("\n[STATUS] --------------------------------------\n");
        printf("[STATUS] Syntax Analysis Successful!\n"); 
        printf("[STATUS] The structure of the 'Universe' is valid.\n");
        printf("[STATUS] --------------------------------------\n");
    }
    ;

stmt_list:
    stmt
    | stmt stmt_list
    ;

stmt:
    declaration_stmt
    | assignment_stmt
    | conditional_stmt
    | loop_stmt
    | output_stmt
    | return_stmt
    ;

declaration_stmt:
    type IDENTIFIER SEMICOLON
    { printf("[LOG] Line %d: Found Variable Declaration\n", line_num); }
    ;

type:
    KW_STAR | KW_PLANET | KW_GALAXY | KW_COSMIC
    ;

assignment_stmt:
    IDENTIFIER OP_LAUNCH expression SEMICOLON
    { printf("[LOG] Line %d: Found Assignment Operation (Launch)\n", line_num); }
    ;

conditional_stmt:
    KW_ORBIT LPAREN expression RPAREN LBRACE stmt_list RBRACE
    { printf("[LOG] Line %d: Found Conditional Block (Orbit)\n", line_num); }
    | KW_ORBIT LPAREN expression RPAREN LBRACE stmt_list RBRACE KW_GRAVITY LBRACE stmt_list RBRACE
    { printf("[LOG] Line %d: Found Conditional Block with Else (Orbit/Gravity)\n", line_num); }
    ;

loop_stmt:
    KW_LIGHTYEAR LPAREN expression RPAREN LBRACE stmt_list RBRACE
    { printf("[LOG] Line %d: Found Loop Structure (Lightyear)\n", line_num); }
    ;

output_stmt:
    KW_OBSERVE output_values SEMICOLON
    { printf("[LOG] Line %d: Found Output Statement (Observe)\n", line_num); }
    ;

output_values:
    expression
    | STRING_LITERAL
    | STRING_LITERAL expression
    ;

return_stmt:
    KW_SUPERNOVA expression SEMICOLON
    { printf("[LOG] Line %d: Found Return Statement (Supernova)\n", line_num); }
    ;

expression:
    expression OP_FUSION expression
    | expression OP_COLLAPSE expression
    | expression OP_RADIATE expression
    | expression OP_EXPAND expression
    | LPAREN expression RPAREN
    | IDENTIFIER
    | NUMBER
    ;

%%

/* ==============================================
   C CODE SECTION
   ============================================== */

void yyerror(const char *s) {
    fprintf(stderr, "\n[ERROR] CRITICAL FAILURE on Line %d\n", line_num);
    fprintf(stderr, "[ERROR] Reason: %s\n", s);
    fprintf(stderr, "[ERROR] Parsing halted.\n");
}

int main(int argc, char **argv) {
    printf("COSMOS Compiler - Phase 2 Syntax Analyzer | Developed by Usman Shahid (Not Your Average Hacker!)\n");
    printf("Initializing...\n\n");

    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror("File open error");
            return 1;
        }
        yyin = f;
    }
    
    yyparse();
    return 0;
}