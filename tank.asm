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
    MAP:
        .pad 225


START:

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
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x000b
    LW R6 R0 0x0000
    LI R6 0x0001
    AND R0 R6
    BEQZ R0 TESTPRINT
    NOP
    JR R7
    NOP


; the menu screen returns the option in R0
MENU_SCREEN:
    LI R0 @GLOBAL_STATE
    LI R1 2
    SW R0 R1 0

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

