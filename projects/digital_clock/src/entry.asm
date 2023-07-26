# 🚩 Definições

# Variáveis globais
    @dig0:  .byte,          @2    # Endereço da variável do dígito da unidade de segundos
    @dig1:  .byte,          @3    # Endereço da variável do dígito da dezena de segundos
    @dig2:  .byte,          @4    # Endereço da variável do dígito da unidade de minutos
    @dig3:  .byte,          @5    # Endereço da variável do dígito da dezena de minutos
    @dig4:  .byte,          @6    # Endereço da variável do dígito da unidade de horas
    @dig5:  .byte,          @7    # Endereço da variável do dígito da dezena de horas

    @INC1:  .byte,          @8    # Endereço da variável do argumento 1 de base de contagem da subrotina INC_DX
    @DEC1:  .byte,          @9    # Endereço da variável do argumento 1 de base de contagem da subrotina DEC_DX

# 🚩 Rotina principal

MAIN:
    ldi     $0                    # Carrega 0 no %ax
    sta     @HEX0                 # Descarrega 0 do %ax no HEX0, inicializando display
    sta     @HEX1                 # Descarrega 0 do %ax no HEX1, inicializando display
    sta     @HEX2                 # Descarrega 0 do %ax no HEX2, inicializando display
    sta     @HEX3                 # Descarrega 0 do %ax no HEX3, inicializando display
    sta     @HEX4                 # Descarrega 0 do %ax no HEX4, inicializando display
    sta     @HEX5                 # Descarrega 0 do %ax no HEX5, inicializando display

    ldi     $18                   # Carrega 18 no %ax
    sta     @TC1                  # Descarrega 10 do %ax no TC0, definindo base de contagem para 2^18

LOOP:
    nop                           # Janela para atuação das interrupções
    jmp     .LOOP                 # Desvia de volta para LOOP

# 🚩 Subrotinas

INC_DX:
    ldaind  $0,             %dx   # Carrega valor do digito na memória
    addi    $1,             %dx   # Incrementa em 1 o valor no %dx
    cle     @INC1,          %dx   # Verifica se o valor é menor ou igual ao limite em INC1
    jle     .INC_DX__UPDATE       # Se for menor ou igual ao limite, pula para INC_DX__UPDATE
    ldi     $0,             %dx   # Se não, zera valor do dígito
INC_DX__UPDATE:
    staind  $0,             %dx   # Atualiza valor na memória
    ret                           # Retorna subrotina INC_DX

DEC_DX:
    ldaind  $0,             %dx   # Carrega valor do digito na memória
    subi    $1,             %dx   # Decrementa em 1 o valor no %dx
    cgei    $0,             %dx   # Verifica se o valor é maior ou igual a 0
    jge     .DEC_DX__UPDATE       # Se for, pula para DEC_DX__UPDATE
    lda     @DEC1,          %dx   # Se não, define para o valor limite em @DEC1
DEC_DX__UPDATE:
    staind  $0,             %dx   # Atualiza valor na memória
    ret                           # Retorna subrotina DECREMENT_DIGIT

INC_D0:
    ldaddr  @dig0                 # Define ponteiro para dig0
    ldi     $9,             %dx   # Carrega 9 no %dx
    sta     @INC1,          %dx   # Guarda na 9 do %dx no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX0,          %dx   # Atualiza o HEX0 com o retorno subrotina
    jle     .INC_D0__RET          # Se não fez overflow, desvia para INC_D0__RET
INC_D1:
    ldaddr  @dig1                 # Define ponteiro para dig1
    ldi     $5,             %dx   # Carrega 5 no %dx
    sta     @INC1,          %dx   # Guarda na 5 do %dx no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX1,          %dx   # Atualiza o HEX1 com o retorno subrotina
    jle     .INC_D0__RET          # Se não fez overflow, desvia para INC_D0__RET
INC_D2:
    ldaddr  @dig2                 # Define ponteiro para dig2
    ldi     $9,             %dx   # Carrega 9 no %dx
    sta     @INC1,          %dx   # Guarda na 9 do %dx no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX2,          %dx   # Atualiza o HEX2 com o retorno subrotina
    jle     .INC_D0__RET          # Se não fez overflow, desvia para INC_D0__RET
INC_D3:
    ldaddr  @dig3                 # Define ponteiro para dig3
    ldi     $5,             %dx   # Carrega 5 no %dx
    sta     @INC1,          %dx   # Guarda na 5 do %dx no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX3,          %dx   # Atualiza o HEX3 com o retorno subrotina
    jle     .INC_D0__RET          # Se não fez overflow, desvia para INC_D0__RET
INC_D4:
    ldaddr  @dig4                 # Define ponteiro para dig4
    lda     @dig5,          %dx   # Carrega valor da dezena de hora no %dx
    cgei    $2,             %dx   # Compara se o valor é maior ou igual a 2
    ldi     $3,             %dx   # Carrega 3 no %dx
    jge     .INC_D4__SET_BASE     # Caso seja maior ou igual, Desvia para INC_D4__SET_BASE
    ldi     $9,             %dx   # Se não, carrega 9 no %dx
INC_D4__SET_BASE:
    sta     @INC1,          %dx   # Guarda a base de contagem do %dx no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX4,          %dx   # Atualiza o HEX4 com o retorno subrotina
    jle     .INC_D0__RET          # Se não fez overflow, desvia para INC_D0__RET
INC_D5:
    ldaddr  @dig5                 # Define ponteiro para dig5
    ldi     $2,             %dx   # Carrega 2 no %dx
    sta     @INC1,          %dx   # Guarda na 2 no endereço do argumeto 1 de INC_DX
    jsr     .INC_DX               # Chama subrotina INC_DX
    sta     @HEX5,          %dx   # Atualiza o HEX5 com o retorno subrotina
INC_D0__RET:
    ret                           # Retorna subrotina INC_D0

DEC_D0:
    ldaddr  @dig0                 # Define ponteiro para dig0
    ldi     $9,             %dx   # Carrega 9 no %dx
    sta     @DEC1,          %dx   # Guarda na 9 do %dx no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX0,          %dx   # Atualiza o HEX0 com o retorno subrotina
    jge     .DEC_D0__RET          # Se não fez underflow, desvia para DEC_D0__RET
DEC_D1:
    ldaddr  @dig1                 # Define ponteiro para dig1
    ldi     $5,             %dx   # Carrega 5 no %dx
    sta     @DEC1,          %dx   # Guarda na 5 do %dx no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX1,          %dx   # Atualiza o HEX1 com o retorno subrotina
    jge     .DEC_D0__RET          # Se não fez underflow, desvia para DEC_D0__RET
DEC_D2:
    ldaddr  @dig2                 # Define ponteiro para dig2
    ldi     $9,             %dx   # Carrega 9 no %dx
    sta     @DEC1,          %dx   # Guarda na 9 do %dx no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX2,          %dx   # Atualiza o HEX2 com o retorno subrotina
    jge     .DEC_D0__RET          # Se não fez underflow, desvia para DEC_D0__RET
DEC_D3:
    ldaddr  @dig3                 # Define ponteiro para dig3
    ldi     $5,             %dx   # Carrega 9 no %dx
    sta     @DEC1,          %dx   # Guarda na 5 do %dx no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX3,          %dx   # Atualiza o HEX3 com o retorno subrotina
    jge     .DEC_D0__RET          # Se não fez underflow, desvia para DEC_D0__RET
DEC_D4:
    ldaddr  @dig4                 # Define ponteiro para dig4
    lda     @dig5,          %dx   # Carrega valor da dezena de hora no %dx
    ceqi    $0,             %dx   # Compara se o valor é igual a 0
    ldi     $3,             %dx   # Carrega 3 no %dx
    jeq     .DEC_D4__SET_BASE     # Caso seja igual, Desvia para DEC_D4__SET_BASE
    ldi     $9,             %dx   # Se não, carrega 9 no %dx
DEC_D4__SET_BASE:
    sta     @DEC1,          %dx   # Guarda na 9 no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX4,          %dx   # Atualiza o HEX4 com o retorno subrotina
    jge     .DEC_D0__RET          # Se não fez underflow, desvia para DEC_D0__RET
DEC_D5:
    ldaddr  @dig5                 # Define ponteiro para dig5
    ldi     $2,             %dx   # Carrega 2 no %dx
    sta     @DEC1,          %dx   # Guarda na 2 no endereço do argumeto 1 de DEC_DX
    jsr     .DEC_DX               # Chama subrotina DEC_DX
    sta     @HEX5,          %dx   # Atualiza o HEX5 com o retorno subrotina
DEC_D0__RET:
    ret                           # Retorna subrotina DEC_D0

# 🚩 Interrupções

    @intr_rec:.byte@63

INTR_KEY0: .equ %INTR_KEY0
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    jsr     .INC_D2               # Chama subrotina INC_D2
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_KEY0             # Retorna da interrupção e reconhece estado de KEY0

INTR_KEY1: .equ %INTR_KEY1
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    jsr     .DEC_D2               # Chama subrotina DEC_D2
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_KEY1             # Retorna da interrupção e reconhece estado de KEY1

INTR_KEY2: .equ %INTR_KEY2
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    jsr     .INC_D4               # Chama subrotina INC_D4
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_KEY2             # Retorna da interrupção e reconhece estado de KEY2

INTR_KEY3: .equ %INTR_KEY3
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    jsr     .DEC_D4               # Chama subrotina DEC_D4
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_KEY3             # Retorna da interrupção e reconhece estado de KEY3

INTR_KEY4: .equ %INTR_KEY4
    reti    %ACK_KEY4             # Retorna da interrupção e reconhece estado de KEY4

INTR_TC0: .equ %INTR_TC0
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    lda     @SW9,           %dx   # Carrega SW9 no %dx
    ceqi    $TRUE,          %dx   # Compara se SW9 é TRUE
    jeq     .INTR_TC0__RETI       # Se sim, Desvia para INTR_TC0__RETI
    lda     @SW8,           %dx   # Se não, Carrega SW8 no %dx
    ceqi    $TRUE,          %dx   # Compara se SW8 é TRUE
    jeq     .INTR_TC0__DEC        # Se sim, Pula para INTR_TC0__DEC
INTR_TC0__INC:
    jsr     .INC_D0               # Se não, chama subrotina INC_D0
    jmp     .INTR_TC0__RETI       # Desvia para INTR_TC0__RETI
INTR_TC0__DEC:
    jsr     .DEC_D0               # Chama subrotina DEC_D0
INTR_TC0__RETI:
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_TC0              # Retorna da interrupção e reconhece estado de TC0

INTR_TC1: .equ %INTR_TC1
    sta     @intr_rec,      %dx   # Guarda estado do %dx no endereço de recuperação de interrupção
    lda     @SW9,           %dx   # Carrega SW9 no %dx
    ceqi    $FALSE,         %dx   # Compara se SW9 é FALSE
    jeq     .INTR_TC1__RETI       # Se sim, Desvia para INTR_TC1__RETI
    lda     @SW8,           %dx   # Se não, Carrega SW8 no %dx
    ceqi    $TRUE,          %dx   # Compara se SW8 é TRUE
    jeq     .INTR_TC1__DEC        # Se sim, Pula para INTR_TC1__DEC
INTR_TC1__INC:
    jsr     .INC_D0               # Se não, chama subrotina INC_D0
    jmp     .INTR_TC1__RETI       # Desvia para INTR_TC1__RETI
INTR_TC1__DEC:
    jsr     .DEC_D0               # Chama subrotina DEC_D0
INTR_TC1__RETI:
    lda     @intr_rec,      %dx   # Recupera estado do %dx do endereço de recuperação de interrupção
    reti    %ACK_TC1              # Retorna da interrupção e reconhece estado de TC1
