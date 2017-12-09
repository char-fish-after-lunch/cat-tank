NOP
NOP
NOP
B START
NOP

B INT ; interrupt position 0x5
NOP

; data section
DATA:
    GLOBAL_STATE:
        .word 0
    DATA_PATCH:
    PATCH_MASK:
        .pad 16
    PATCH_COLOR:
        .word 0
    PATCH_X:
        .word 0
    PATCH_Y:
        .word 0
    PATCH_TYPE:
        .word 0
    DATA_STRING:
    STRING_POINTER:
        .word 0
    STRING_LEN:
        .word 0
    STRING_COLOR:
        .word 0
    STRING_X:
        .word 0
    STRING_Y:
        .word 0
    STRING_TYPE:
        .word 0
    DATA_MENU:
        DATA_MENU_TITLE:
            .ascii WELCOME TO CATPAD! 
        DATA_MENU_SELECTED:
            .word 0
    DATA_TANK:

        DATA_TANK_MAP:
            .pad 225

START:
    LI R0 0x00bf
    SLL R0 R0 0x0000
    ADDIU R0 0x0010
    MTSP R0


    MAIN_LOOP:

        ; clear the screen
        MFPC R7
        ADDIU R7 3
        NOP
        B CLEAR_SCREEN
        NOP

        ; enter the menu screen
        MFPC R7
        ADDIU R7 3
        NOP
        B MENU_SCREEN
        NOP
        ; R0 = choice

        MFPC R7
        ADDIU R7 FUNC_RET

        CMPI R0 0
        BTEQZ TYPIST_PAD
        NOP

        CMPI R0 1
        BTEQZ TANK_PAD
        NOP

        CMPI R0 2
        BTEQZ SNAKE_PAD
        NOP

        CMPI R0 3
        BTEQZ ABOUT_PAD
        NOP

        NOP
        FUNC_RET:
            
    B MAIN_LOOP
    NOP

TYPIST_PAD:
    LLI R5 @TYPIST    
    JR R5
    NOP

TANK_PAD:
    LLI R5 @TANK
    JR R5
    NOP

SNAKE_PAD:
    LLI R5 @SNAKE
    JR R5
    NOP

ABOUT_PAD:
    LLI R5 @ABOUT
    JR R5
    NOP

INT:
    LI R0 @GLOBAL_STATE
    LW R0 R1 0 ; the current state

    CMPI R1 1
    BTEQZ INT_CLEAR_SCREEN
    NOP

    CMPI R1 1
    BTEQZ INT_MENU_SCREEN
    NOP

    CMPI R1 2
    BTEQZ INT_TYPIST
    NOP

    CMPI R1 3
    BTEQZ INT_TANK
    NOP

    CMPI R1 4
    BTEQZ INT_SNAKE
    NOP

    ERET

INT_CLEAR_SCREEN:
    ERET

INT_MENU_SCREEN:
    ERET

INT_TYPIST:
    ERET

INT_TANK:
    ERET

INT_SNAKE:
    ERET

    
CLEAR_SCREEN:
    LI R0 @GLOBAL_STATE
    LI R1 1
    SW R0 R1 0

    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0

    JR R7
    NOP

CLEARTOZERO:
    NOP
    LI R4 0x0000
    ADDIU R5 0x0008
    AND R5 R2
    BEQZ R5 TESTSHOWTEXT
    NOP

NONEEDRETURNZERO:
    NOP
    B CLEAR_SCREEN
    NOP

TESTPRINT:
    SW_SP R6 0
    SW_SP R0 1

    TESTPRINT_MID:
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x000b
    LW R6 R0 0x0000
    LI R6 0x0001
    AND R0 R6
    BEQZ R0 TESTPRINT_MID
    NOP

    LW_SP R6 0
    LW_SP R0 1


    JR R7
    NOP


; the menu screen returns the option in R0
MENU_SCREEN:
    LI R0 @GLOBAL_STATE
    LI R1 2
    SW R0 R1 0

    

    MENU_LOOP:
       
    B MENU_LOOP
    NOP

    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0

    JR R7
    NOP

TYPE:
    JR R7
    NOP
    

TANK:
    JR R7
    NOP

SNAKE:
    JR R7
    NOP

ABOUT:
    JR R7
    NOP

DRAW_M_PATCH:

    SW_SP R0 1
    SW_SP R1 2
    SW_SP R2 3
    SW_SP R3 4
    SW_SP R4 5
    SW_SP R5 6
    SW_SP R6 7

    ADDSP 0X10

    ; ----- set enlarged size shift
    LI R5 @PATCH_TYPE
    LW R5 R4 0
    SRL R4 R4 0
    SRL R4 R4 1  ; 
    --- R4 = enlarged x 8, also the
    --- actual coord shift between 4 patches

    ; ----- draw patch 0 (left upper)
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT
    NOP
    LI R0 0X00BF
    SLL R0 R0 0
    LI R5 @PATCH_MASK
    LW R5 R1 0
    SW R0 R1 0X8
    LW R5 R1 1
    SW R0 R1 0X9
    LW R5 R1 2
    SW R0 R1 0XA
    LW R5 R1 3
    SW R0 R1 0XB

    LI R5 @PATCH_X
    LW R5 R3 0
    SW R0 R3 0XC

    LI R5 @PATCH_Y
    LW R5 R3 0
    SW R0 R3 0XD

    LI R5 @PATCH_COLOR
    LW R5 R3 0
    SW R0 R3 0XE



    ; ----- draw patch 1 (right upper)

    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT
    NOP
    LI R0 0X00BF
    SLL R0 R0 0
    LI R5 @PATCH_MASK
    LW R5 R1 4
    SW R0 R1 0X8
    LW R5 R1 5
    SW R0 R1 0X9
    LW R5 R1 6
    SW R0 R1 0XA
    LW R5 R1 7
    SW R0 R1 0XB

    LI R5 @PATCH_X
    LW R5 R3 0
    SW R0 R3 0XC

    LI R5 @PATCH_Y
    LW R5 R3 0
    ADDU R4 R5 R5
    SW R0 R3 0XD

    LI R5 @PATCH_COLOR
    LW R5 R3 0
    SW R0 R3 0XE


    ; ----- draw patch 2 (left lower)
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT
    NOP
    LI R0 0X00BF
    SLL R0 R0 0
    LI R5 @PATCH_MASK
    LW R5 R1 0x8
    SW R0 R1 0X8
    LW R5 R1 0x9
    SW R0 R1 0X9
    LW R5 R1 0xA
    SW R0 R1 0XA
    LW R5 R1 0xB
    SW R0 R1 0XB

    LI R5 @PATCH_X
    LW R5 R3 0
    ADDU R4 R5 R5
    SW R0 R3 0XC

    LI R5 @PATCH_Y
    LW R5 R3 0
    SW R0 R3 0XD

    LI R5 @PATCH_COLOR
    LW R5 R3 0
    SW R0 R3 0XE


    ; ----- draw patch 3 (right bottom)
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT
    NOP
    LI R0 0X00BF
    SLL R0 R0 0
    LI R5 @PATCH_MASK
    LW R5 R1 0xC
    SW R0 R1 0X8
    LW R5 R1 0xD
    SW R0 R1 0X9
    LW R5 R1 0xE
    SW R0 R1 0XA
    LW R5 R1 0xF
    SW R0 R1 0XB

    LI R5 @PATCH_X
    LW R5 R3 0
    ADDU R4 R5 R5
    SW R0 R3 0XC

    LI R5 @PATCH_Y
    LW R5 R3 0
    ADDU R4 R5 R5
    SW R0 R3 0XD

    LI R5 @PATCH_COLOR
    LW R5 R3 0
    SW R0 R3 0XE

    ADDSP 0XFFF0
    LW_SP R0 1
    LW_SP R1 2
    LW_SP R2 3
    LW_SP R3 4
    LW_SP R4 5
    LW_SP R5 6
    LW_SP R6 7

    JR R7
    NOP 

PRINT_STRING:
    SW_SP R0 0
    SW_SP R1 0
    SW_SP R2 0
    SW_SP R3 0
    SW_SP R4 0
    SW_SP R5 0
    SW_SP R6 0
    SW_SP R7 0

    ADDSP 8


    LI R0 @DATA_STRING
    LW R0 R1 0 ; R1 = data pointer

    ; R4 is used to do everything

    LI R5 0xbf
    SLL R5 R5 0 ; R5 = 0xbf00

    LI R2 0 ; R2 = offset
    LOOP_PRINT_STRING:
        LW R1 R3 0 ; R3 = data
        
        SW R5 R3 0x8

        LW R0 R4 3 ; R4 = x
        SW R5 R4 0xc

        LW R0 R4 4 ; R4 = y
        SW R5 R4 0xd

        LW R0 R4 2 ; R4 = color
        SW R5 R4 0xe

        B TESTPRINT
        NOP

        LW R0 R4 5 ; R4 = type
        SW R5 R4 0xf

        ADDIU R2 1
        ADDIU R1 1

        LW R0 R4 1 ; R4 = len

        CMP R4 R1
        BTNEZ LOOP_PRINT_STRING
        NOP

    ADDSP 0xffe8

    LW_SP R0 0
    LW_SP R1 0
    LW_SP R2 0
    LW_SP R3 0
    LW_SP R4 0
    LW_SP R5 0
    LW_SP R6 0
    LW_SP R7 0


    JR R7
    NOP
    
