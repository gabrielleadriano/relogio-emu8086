data segment


LINHA DB ?
COLUNA DB ?
DIGITO DB ?
DIGITO_UNI DB ?
DIGITO_DEZ DB ?    
                 
;PERGUNTAS 
PMINUTO_DEZ DB "Digite minutos (dez)$"
PMINUTO_UNI DB "Digite minutos (uni)$"

PSEGUNDO_DEZ DB "Digite segundos (dez)$"
PSEGUNDO_UNI DB "Digite segundos (uni)$"
                               
MINUTOS DB ? 
 
SEGUNDOS DB ?

DOISPONTOS DB " _ ",10
DB "(_)",10
DB "   ",10
DB "   ",10
DB " _ ",10
DB "(_)",0

ZERO DB "   ___   ",10
DB "  / _ \  ",10
DB " | | | | ",10
DB " | | | | ",10
DB " | |_| | ",10
DB "  \___/  ",0
					    
UM DB "   __    ",10
DB "  /_ |   ",10
DB "   | |   ",10
DB "   | |   ",10
DB "   | |   ",10
DB "   |_|   ",0
	
DOIS DB "  ___    ",10
DB " |__ \   ",10
DB "    ) |  ",10
DB "   / /   ",10
DB "  / /_   ",10
DB " |____|  ",0
	
TRES DB "  ____   ",10
DB " |___ \  ",10
DB "   __) | ",10
DB "  |__ <  ",10
DB "  ___) | ",10
DB " |____/  ",0
	
QUATRO DB "  _  _   ",10
DB " | || |  ",10
DB " | || |_ ",10
DB " |__   _|",10
DB "    | |  ",10
DB "    |_|  ",0
	
CINCO DB "  _____  ",10
DB " | ____| ",10
DB " | |__   ",10
DB " |___ \  ",10
DB "  ___) | ",10
DB " |____/  ",0
	
SEIS DB "    __   ",10
DB "   / /   ",10
DB "  / /_   ",10
DB " | '_ \  ",10
DB " | (_) | ",10
DB "  \___/  ",0
	
SETE DB "  ______ ",10
DB " |____  |",10
DB "     / / ",10
DB "    / /  ",10
DB "   / /   ",10
DB "  /_/    ",0
	
OITO DB "   ___   ",10
DB "  / _ \  ",10
DB " | (_) | ",10
DB "  > _ <  ",10
DB " | (_) | ",10
DB "  \___/  ",0
	
NOVE DB "   ___   ",10
DB "  / _ \  ",10
DB " | (_) | ",10
DB "  \__, | ",10
DB "    / /  ",10
DB "   /_/   ",0
ends    

stack segment
dw 128 dup(0)
ends

code segment
start:

mov ax, data
mov ds, ax
mov es, ax


 
 
RELOGIO:  

    ;SEGUNDOS
    CALL LIMPA
    ;pergunta dezena segundos
    LEA DX, PSEGUNDO_DEZ
    MOV AH, 9
    INT 21h    
    
    ;pega input       
    MOV AH,8
    INT 21h 
    CALL VERIFICA        
    
    SUB AL,48 
    
    ;multiplica dezena separada por 10
    MOV BL,10
    MUL BL
    
    ;segundos com dezena 
    MOV SEGUNDOS,AL 
    CALL pula_linha  
      
   
    ;pergunta unidade segundos  
    LEA DX, PSEGUNDO_UNI
    MOV AH, 9
    INT 21h    
    
    ;pega input        
    MOV AH,8
    INT 21h
    CALL VERIFICA
    
    
    SUB AL,48     
    ADD SEGUNDOS,AL
 
    CALL pula_linha 
    
    
    ;MINUTOS
    ;pergunta dezena minutos
    LEA DX, PMINUTO_DEZ
    MOV AH, 9
    INT 21h    
    
    ;pega input       
    MOV AH,8
    INT 21h
    CALL VERIFICA
            
    SUB AL,48 
    
    ;multiplica dezena separada por 10
    MOV BL,10
    MUL BL
    
    ;segundos com dezena 
    MOV MINUTOS,AL 
    CALL pula_linha  
      
    
    ;pergunta unidade minutos  
    LEA DX, PMINUTO_UNI
    MOV AH, 9
    INT 21h    
    
    ;pega input        
    MOV AH,8
    INT 21h
    CALL VERIFICA
    
    SUB AL,48     
    ADD MINUTOS,AL
 
    CALL pula_linha    
    
    CALL LIMPA
    
    JMP MOSTRANDO 
    




MOSTRANDO:                       
    MOV AH,1
    MOV CH,20H
    INT 10H
    ;DESLIGA CURSOR
    
    ;SEGUNDOS
    
    MOV AH,0
    MOV AL, SEGUNDOS
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH
    
  
    ;verifica se unidade = 10 ou segundos = 60
    CALL FORMATA_SEGUNDOS 
    
    ;var SEGUNDOS atualizada
    MOV AL,DIGITO_DEZ
    MOV BL,10
    MUL BL
    MOV SEGUNDOS,AL 
    
    MOV AL,DIGITO_UNI
    ADD SEGUNDOS,AL

	;imprime DEZ. segundos
	MOV AL,DIGITO_DEZ
	MOV DIGITO,AL
	MOV LINHA, 5
	MOV COLUNA, 30
	CALL IMPRIME_DIGITO
	
	;imprime UNI. segundos
	MOV AL,DIGITO_UNI
	MOV DIGITO,AL
	MOV LINHA, 5
	MOV COLUNA, 40
	CALL IMPRIME_DIGITO
	
	
	     
	;MINUTOS
	MOV AH,0
    MOV AL,MINUTOS
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH     
	     
	;verifica se unidade = 10 ou minutos = 60
	CALL FORMATA_MINUTOS
	
	;imprime DEZ. minutos
	MOV AL,DIGITO_DEZ
	MOV DIGITO,AL
	MOV LINHA, 5
	MOV COLUNA, 0
	CALL IMPRIME_DIGITO
	
	;imprime UNI. minutos
	MOV AL,DIGITO_UNI
	MOV DIGITO,AL
	MOV LINHA, 5
	MOV COLUNA, 10
	CALL IMPRIME_DIGITO
	
	MOV LINHA, 5
	MOV COLUNA, 25
	CALL IMP_DOISPONTOS


INCREMENTA:

    CALL DELAY 
    INC SEGUNDOS  
    JMP MOSTRANDO
       

;FORMATACAO DE SEGUNDOS

FORMATA_SEGUNDOS:

    CMP DIGITO_UNI,10
    JE ADICIONA_DEZENA
    
    CMP SEGUNDOS,60
    JE ADICIONA_MINUTO 
    
    RET    


ADICIONA_MINUTO:
    INC MINUTOS
    
    CMP MINUTOS,60
    JE FIM_MINUTOS
    
    CALL RESETA_SEGUNDO    
           
    
RESETA_SEGUNDO:
    MOV DIGITO_DEZ,0
    MOV DIGITO_UNI,0
    RET 
    
                         
;FORMATACAO DE MINUTOS
 
FORMATA_MINUTOS:

    CMP DIGITO_UNI,10
    JE ADICIONA_DEZENA
    
    CMP MINUTOS,60
    JE FIM_MINUTOS 
    
    RET    


FIM_MINUTOS:
    CALL RESETA_RELOGIO
   
RESETA_RELOGIO: 
    MOV SEGUNDOS,0
    MOV MINUTOS,0   
    JMP MOSTRANDO


;FORMATACOES DE UNIDADE GENERICAS 
ADICIONA_DEZENA: 
    INC DIGITO_DEZ 
    CALL RESETA_UNIDADE

RESETA_UNIDADE:
    MOV DIGITO_UNI,0
    RET 

                  
                  
                  
;METODOS DE CONTROLE

LIMPA: 

    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,02H    ;fundo preto, letra verde
    MOV CX,0000H    ;STARTING COORDINATES
    MOV DX,184FH    ;ENDING COORDINATES
    INT 10H        ;FOR VIDEO DISPLAY
    RET

   
;DELAY 500000 (7A120h).
DELAY:   
    MOV CX, 7      ;HIGH WORD.
    MOV DX, 0A120h ;LOW WORD.
    MOV AH, 86h    ;WAIT.
    INT 15h
    RET

VERIFICA:
    CMP AL,48
    JB ERRO
    
    CMP AL,57
    JA ERRO
    
    RET

ERRO:          
    MOV DL,007
    MOV AH,6
    INT 21h
    MOV AX, 4c00h
    INT 21h
  

IMPRIME_DIGITO:
    CMP DIGITO,0
    JE IMP_ZERO
    CMP DIGITO,1
    JE IMP_UM
    CMP DIGITO,2
    JE IMP_DOIS
    CMP DIGITO,3
    JE IMP_TRES
    CMP DIGITO,4
    JE IMP_QUATRO
    CMP DIGITO,5
    JE IMP_CINCO
    CMP DIGITO,6
    JE IMP_SEIS
    CMP DIGITO,7
    JE IMP_SETE
    CMP DIGITO,8
    JE IMP_OITO
    CMP DIGITO,9
    JE IMP_NOVE

IMP_DOISPONTOS:
    LEA SI, DOISPONTOS
    JMP IMPRIMINDO
    RET

IMP_ZERO:
    LEA SI, ZERO
    JMP IMPRIMINDO
    IMP_UM:
    LEA SI, UM
    JMP IMPRIMINDO
    IMP_DOIS:
    LEA SI, DOIS
    JMP IMPRIMINDO
    IMP_TRES:
    LEA SI, TRES
    JMP IMPRIMINDO
    IMP_QUATRO:
    LEA SI, QUATRO
    JMP IMPRIMINDO
    IMP_CINCO:
    LEA SI, CINCO
    JMP IMPRIMINDO
    IMP_SEIS:
    LEA SI, SEIS
    JMP IMPRIMINDO
    IMP_SETE:
    LEA SI, SETE
    JMP IMPRIMINDO
    IMP_OITO:
    LEA SI, OITO
    JMP IMPRIMINDO
    IMP_NOVE:
    LEA SI, NOVE
    JMP IMPRIMINDO

IMPRIMINDO:
    ; POSICIONA CURSOR
    MOV AH,2
    MOV BH,0
    MOV DH, LINHA
    MOV DL, COLUNA
    INT 10H
    
PROCURA_FIM:
    mov dl,ds:[si]
    cmp dl,0
    je FIM_IMPRESSAO
    cmp dl,10
    je pula_linha
    mov ah,2
    int 21h
    INC SI
    JMP PROCURA_FIM
    
pula_linha:
    
    inc byte ptr linha
    inc si
    jmp IMPRIMINDO
    
FIM_IMPRESSAO:
    RET

ends

end start