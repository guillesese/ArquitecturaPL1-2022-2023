package compiler.lexical;

import compiler.syntax.sym;
import compiler.lexical.Token;
import es.uned.lsi.compiler.lexical.ScannerIF;
import es.uned.lsi.compiler.lexical.LexicalError;
import es.uned.lsi.compiler.lexical.LexicalErrorManager;

// incluir aqui, si es necesario otras importaciones

%%
 
%public
%class Scanner
%char
%line
%column
%cup
%unicode

%implements ScannerIF
%scanerror LexicalError

// incluir aqui, si es necesario otras directivas
// (GSC) incluyo la directiva %ignorecase
%ignorecase

%{
  LexicalErrorManager lexicalErrorManager = new LexicalErrorManager ();
  
  private int commentCount = 0;
  
  private Token createToken (int simbolo){
  	Token token = new Token(simbolo);
  	token.setLine (yyline + 1); 
  	token.setColumn (yycolumn + 1);
  	token.setLexema (yytext());
  	return token;
  }
%}  
  
FIN_LINEA = \r|\n|\r\n
ENTRADA = [^\r\n]
ESPACIO_BLANCO = {FIN_LINEA} | [ \t\f]
LETRA   = [A-Za-z_]
DIGITO  = [0-9]
LINEA_COMENTARIO = "--" {ENTRADA}* {FIN_LINEA}
COMENTARIO = {LINEA_COMENTARIO}
IDENTIFICADOR = {LETRA}({LETRA}|{DIGITO}+)*
CADENA = \"([\x21-\x7F])*\"
fin = "fin"{ESPACIO_BLANCO}

%%

<YYINITIAL> 
{			
    //operadores       			       
    "-" 				{ return createToken(sym.MINUS);}
    "*"					{ return createToken(sym.MULT);}
    ">" 				{ return createToken(sym.GT);}
    "/="				{ return createToken(sym.NEQ);}
    "and" 				{ return createToken(sym.AND);}
    ":=" 				{ return createToken(sym.ASSIGN);}
    "."					{ return createToken(sym.DOT);}
    
    //delimitadores
    (GSC) Es necesario 'escapar' las comillas usando \ 
    "\""				{ return createToken(sym.COMILLAS);}
    "(" 				{ return createToken(sym.APARENTESIS);}
    ")" 				{ return createToken(sym.CPARENTESIS);}
    ","					{ return createToken(sym.COMA);}
    ";"					{ return createToken(sym.PUNTOYCOMA);}
    ":"					{ return createToken(sym.DOSPUNTOS);}
    
    //palabras reservadas
    "begin" 			{ return createToken(sym.BEGIN);}
    "Boolean" 			{ return createToken(sym.BOOLEAN);}
    "constant" 			{ return createToken(sym.CONSTANT);}
    "else" 				{ return createToken(sym.ELSE);}
    "end" 				{ return createToken(sym.END);}
    "False"				{ return createToken(sym.FALSE);}
    "function" 			{ return createToken(sym.FUNCTION);}
    "if"				{ return createToken(sym.IF);}
    "Integer" 			{ return createToken(sym.INTEGER);}
	"is"				{ return createToken(sym.IS);}
	"loop"				{ return createToken(sym.LOOP);}
	"out" 				{ return createToken(sym.OUT);}
	"procedure" 		{ return createToken(sym.PROCEDURE);}
	"Put_line" 			{ return createToken(sym.PUT_LINE);}
	"record" 			{ return createToken(sym.RECORD);}
	"return"			{ return createToken(sym.RETURN);}
	"then" 				{ return createToken(sym.THEN);}
	"True"				{ return createToken(sym.TRUE);}
	"type"				{ return createToken(sym.TYPE);}
	"while" 			{ return createToken(sym.WHILE);}
	
	 //palabras clave
	{IDENTIFICADOR}     { return createToken(sym.IDENTIFICADOR);}
	{DIGITO}+			{ return createToken(sym.NUMERO);} 
	{CADENA} 			{ return createToken(sym.CADENA);}            
    {ESPACIO_BLANCO}	{}
	{COMENTARIO} 		{}
	{fin} {}
	
  	//fin de fichero
    <<EOF>> 			{ return createToken(sym.EOF);}
    
    // error en caso de coincidir con ningún patrón
	[^]     
                        {                                               
                           LexicalError error = new LexicalError ();
                           error.setLine (yyline + 1);
                           error.setColumn (yycolumn + 1);
                           error.setLexema (yytext ());
                           lexicalErrorManager.lexicalError (error);
                        }
    
}

                         



