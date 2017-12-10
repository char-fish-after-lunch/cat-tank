NOP
NOP
NOP
B START_PAD
NOP

B INT ; interrupt position 0x5
NOP

START_PAD:
    LLI R0 @START
    JR R0
    NOP

INT:
    ; ---------------- save the state -------------
    ADDSP 9

    SW_SP R0 0xffff
    SW_SP R1 0xfffe
    SW_SP R2 0xfffd
    SW_SP R3 0xfffc 
    SW_SP R4 0xfffb
    SW_SP R5 0xfffa
    SW_SP R6 0xfff9 
    SW_SP R7 0xfff8 

    MFT R0
    SW_SP R0 0xfff7

    ; ----------------------------------------

    MFCS R0 ; cause
    CMPI R0 0xa
    BTEQZ INT_PS2
    NOP

    B INT_SKIP
    NOP

    INT_PS2:
        LI R1 @GLOBAL_KEY
        LW R1 R1 0 ; last key
        
        SRL R1 R1 7
        BNEZ R1 INT_PS2_RET
        NOP

        LI R1 0xbf
        SLL R1 R1 0
        LW R1 R1 0x4
        CMPI R1 0x76
        BTNEZ INT_PS2_RET
        NOP
        
        LI R1 @GLOBAL_ESC
        LI R2 1
        SW R1 R2 0 

        INT_PS2_RET:
            LI R1 @GLOBAL_KEY
            LI R2 0xbf
            SLL R2 R2 0
            LW R2 R2 0x4
            SW R1 R2 0
   
    INT_SKIP: 
    LI R0 @GLOBAL_STATE
    LW R0 R1 0

    MFPC R7
    ADDIU R7 INT_RECOVER
    NOP
    
    CMPI R1 1
    BTEQZ INT_MENU_SCREEN_PAD
    NOP

    CMPI R1 2
    BTEQZ INT_TYPIST_PAD
    NOP

    CMPI R1 3
    BTEQZ INT_TANK_PAD
    NOP

    CMPI R1 4
    BTEQZ INT_SNAKE_PAD
    NOP

    CMPI R1 5
    BTEQZ INT_ABOUT_PAD
    NOP

    NOP
    NOP
    NOP
    INT_RECOVER:

    ; ------------------- restore the state ---------------
    LW_SP R0 0xfff7
    MTT R0

    LW_SP R0 0xffff
    LW_SP R1 0xfffe
    LW_SP R2 0xfffd
    LW_SP R3 0xfffc 
    LW_SP R4 0xfffb
    LW_SP R5 0xfffa
    LW_SP R6 0xfff9 
    LW_SP R7 0xfff8 

    ADDSP 0xfff7

    ERET
    NOP

INT_MENU_SCREEN_PAD:
    LLI R0 @INT_MENU_SCREEN
    JR R0
    NOP

INT_TYPIST_PAD:
    LLI R0 @INT_TYPIST
    JR R0
    NOP

INT_SNAKE_PAD:
    LLI R0 @INT_SNAKE
    JR R0
    NOP

INT_TANK_PAD:
    LLI R0 @INT_TANK
    JR R0
    NOP

INT_ABOUT_PAD:
    LLI R0 @INT_ABOUT
    JR R0
    NOP


; data section
DATA:
    GLOBAL_STATE:
        .word 0
    GLOBAL_ESC:
        .word 0
    GLOBAL_KEY:
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
    KEY_LAST: ; the last scan code
        .word 0
    DATA_MENU:
        DATA_MENU_TITLE:
            .ascii WELCOME TO CATPAD! 
        DATA_MENU_OPTION0:
            DATA_MENU_OPTION0_LEN:
            .word 6
            DATA_MENU_OPTION0_TEXT:
            .ascii Typist
        DATA_MENU_OPTION1:
            DATA_MENU_OPTION1_LEN:
            .word 4
            DATA_MENU_OPTION1_TEXT:
            .ascii Tank
        DATA_MENU_OPTION2:
            DATA_MENU_OPTION2_LEN:
            .word 5
            DATA_MENU_OPTION2_TEXT:
            .ascii Snake
        DATA_MENU_OPTION3:
            DATA_MENU_OPTION3_LEN:
            .word 5
            DATA_MENU_OPTION3_TEXT:
            .ascii About
        DATA_MENU_SELECTED:
            .word 0
        DATA_MENU_OK:
            .word 0
    DATA_TANK:

        DATA_TANK_MAP:
            .pad 256
    DATA_ABOUT:
        DATA_ABOUT_TITLE:
            .ascii ABOUT CATPAD
        DATA_ABOUT_INFO:
            .ascii CATPAD is a pipelined PC made by:
        DATA_ABOUT_AUTHOR1:
            .ascii Catfish,
        DATA_ABOUT_AUTHOR2:
            .ascii Jason_Yu, 
        DATA_ABOUT_AUTHOR3:
            .ascii and John_WJs.

    DATA_TYPIST:
        DATA_TYPIST_TITLE:
            .ascii Type these sentences!
        DATA_SENTENCE_POINTERS:
            .word 0
            .word 0
            .word 0 
        DATA_SENTENCE_LENGTHS:
            .word 11
            .word 30
            .word 28
        DATA_SENTENCE_XS:
            .word 0x70
            .word 0xA0
            .word 0xD0

        DATA_TYPIST_SENTENCE1:
            .ascii hello_world
        DATA_TYPIST_SENTENCE2:
            .ascii i_love_study,_i_love_deadlines
        DATA_TYPIST_SENTENCE3:
            .ascii typing_these_words_is_boring

        DATA_TYPIST_LAST_KEY:
            .word 0
        DATA_TYPIST_CUR_INPUT:
            .word 0
        DATA_TYPIST_CUR_SENTENCE:
            .word 0

        DATA_TYPIST_CUR_INDEX:
            .word 0 

    DATA_SNAKE:
        SNAKE_RANDOM:
            .word 0
        SNAKE_RANDOM_ADD:
            .word 0
        SNAKE_MAP:
            .pad 256
        SNAKE_QUEUE:
            .pad 256
        SNAKE_DIRECTION:
            .word 0

START:
    LI R0 0x00bf
    SLL R0 R0 0x0000
    ADDIU R0 0x0010
    MTSP R0


    MAIN_LOOP:

                ; enter the menu screen
        MFPC R7
        ADDIU R7 3
        NOP
        B MENU_SCREEN
        ;B TYPIST_PAD
        NOP
 
        LI R1 @GLOBAL_ESC
        LI R0 0
        SW R1 R0 0
        

        ; R0 = choice
        LI R1 @DATA_MENU_SELECTED
        LW R1 R0 0


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

INT_MENU_SCREEN:
    MFCS R0
    CMPI R0 0xa
    BTEQZ INT_MENU_SCREEN_PS2
    NOP
    JR R7
    NOP

INT_MENU_SCREEN_PS2:
    ADDSP 1
    SW_SP R7 0xffff
    
    LI R0 0xbf
    SLL R0 R0 0 ; R0 = 0xbf00

    LW R0 R1 0x4 ; scan code
    
    ;SW R0 R1 0 ; for testing

    ; B INT_MENU_SCREEN_PS2_RET

    LI R0 @KEY_LAST
    LW R0 R2 0 ; last scan code

    
    LI R3 0xe0
    CMP R2 R3
    BTEQZ INT_MENU_SCREEN_PS2_PAD
    NOP
    LI R3 0xf0
    CMP R2 R3
    BTNEZ INT_MENU_SCREEN_PS2_RET_SKIP1
    NOP
    B INT_MENU_SCREEN_PS2_RET
    NOP
    INT_MENU_SCREEN_PS2_RET_SKIP1:

    NOP

    INT_MENU_SCREEN_PS2_NO_PAD:
    CMPI R1 0x5a

    BTNEZ INT_MENU_SCREEN_PS2_ENTER_SKIP1
    NOP
    B INT_MENU_SCREEN_PS2_ENTER
    NOP
    INT_MENU_SCREEN_PS2_ENTER_SKIP1:

    NOP
    B INT_MENU_SCREEN_PS2_RET
    NOP


    INT_MENU_SCREEN_PS2_PAD:
    CMPI R1 0x75 ; u arrow
    BTEQZ INT_MENU_SCREEN_PS2_UARROW
    NOP

    CMPI R1 0x72 ; d arrow
    BTEQZ INT_MENU_SCREEN_PS2_DARROW
    NOP
    
    B INT_MENU_SCREEN_PS2_RET
    NOP

    INT_MENU_SCREEN_PS2_UARROW:
        LI R0 @DATA_MENU_SELECTED
        LW R0 R4 0 ; currently selected

               ; at boundary
        CMPI R4 0
        BTNEZ INT_MENU_SCREEN_PS2_RET_SKIP2
        NOP
        B INT_MENU_SCREEN_PS2_RET
        NOP
        INT_MENU_SCREEN_PS2_RET_SKIP2:
        NOP

        ; --------------- clear the selected sign ----------------
        LI R0 0xbf
        SLL R0 R0 0

        SLL R5 R4 5
        ADDIU R5 90 ; position y
        ADDIU R5 90 ; position y

        LI R3 26
        SW R0 R3 0x8

        SW R0 R5 0xc

        LI R3 70
        SW R0 R3 0xd

        LLI R3 0xffff
        SW R0 R3 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP

        ; --------------------------
        LLI R3 0b0010001000000001 ; the type
        SW R0 R3 0xf


        LI R0 @DATA_MENU_SELECTED
        ADDIU R4 0xffff
        SW R0 R4 0



        ; --------------- draw the new selected sign ----------------
        LI R0 0xbf
        SLL R0 R0 0

        SLL R5 R4 5
        ADDIU R5 90 ; position y
        ADDIU R5 90 ; position y

        LI R0 0xbf
        SLL R0 R0 0

        LI R3 62
        SW R0 R3 0x8

        SW R0 R5 0xc

        LI R3 70
        SW R0 R3 0xd

        LI R3 0
        SW R0 R3 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP

        LLI R3 0b0010001000000001 ; the type
        SW R0 R3 0xf


        B INT_MENU_SCREEN_PS2_RET
        NOP

    INT_MENU_SCREEN_PS2_DARROW:
        LI R0 @DATA_MENU_SELECTED
        LW R0 R4 0

        LI R0 0xbf
        SLL R0 R0 0

        ; at boundary
        CMPI R4 3
        BTEQZ INT_MENU_SCREEN_PS2_RET
        NOP


       ; --------------- clear the selected sign ----------------

        LI R0 0xbf
        SLL R0 R0 0

        SLL R5 R4 5
        ADDIU R5 90 ; position y
        ADDIU R5 90 ; position y


        LI R3 62
        SW R0 R3 0x8

        SW R0 R5 0xc

        LI R3 70
        SW R0 R3 0xd

        LLI R3 0xffff
        SW R0 R3 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP
        ; --------------------------
        LLI R3 0b0010001000000001 ; the type
        SW R0 R3 0xf



        LI R0 @DATA_MENU_SELECTED
        ADDIU R4 0x1
        SW R0 R4 0
        ; --------------- draw the new selected sign ----------------
        LI R0 0xbf
        SLL R0 R0 0

        SLL R5 R4 5
        ADDIU R5 90 ; position y
        ADDIU R5 90 ; position y

        LI R0 0xbf
        SLL R0 R0 0

        LI R3 62
        SW R0 R3 0x8

        SW R0 R5 0xc

        LI R3 70
        SW R0 R3 0xd

        LI R3 0
        SW R0 R3 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP

        ; --------------------------
        LLI R3 0b0010001000000001 ; the type
        SW R0 R3 0xf

        B INT_MENU_SCREEN_PS2_RET
        NOP

    INT_MENU_SCREEN_PS2_ENTER:
        LI R4 1
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LI R0 @DATA_MENU_OK
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        SW R0 R4 0


        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

        B INT_MENU_SCREEN_PS2_RET
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

    INT_MENU_SCREEN_PS2_RET:
        LI R0 @KEY_LAST
        SW R0 R1 0 ; update


        LW_SP R7 0xffff
        ADDSP 0xffff

        JR R7
        NOP

INT_ABOUT:
    JR R7
    NOP

INT_TYPIST_PS2_SKIP_PAD:
    B INT_TYPIST_PS2_SKIP
    NOP

INT_TYPIST_PS2_INPUT_SKIP_PAD:
    B INT_TYPIST_PS2_INPUT_SKIP
    NOP

INT_TYPIST:
    ADDSP 1

    LW_SP R7 0xffff

    MFCS R0
    CMPI R0 0xa
    BTNEZ INT_TYPIST_PS2_SKIP_PAD
    NOP
    
    LLI R0 @DATA_TYPIST_LAST_KEY
    LW R0 R0 0 ; last key

    SRL R0 R0 7
    BNEZ R0 INT_TYPIST_PS2_INPUT_SKIP_PAD
    NOP

    LI R0 0xbf
    SLL R0 R0 0
    LW R0 R2 0x4 ; R2 = scan code

    CMPI R2 41
    BTEQZ INT_TYPIST_PS2_SPACE
    NOP

    CMPI R2 65
    BTEQZ INT_TYPIST_PS2_COMMA
    NOP

    CMPI R2 28
    BTEQZ INT_TYPIST_PS2_a
    NOP

    CMPI R2 50
    BTEQZ INT_TYPIST_PS2_b
    NOP

    CMPI R2 33
    BTEQZ INT_TYPIST_PS2_c
    NOP

    CMPI R2 35
    BTEQZ INT_TYPIST_PS2_d
    NOP

    CMPI R2 36
    BTEQZ INT_TYPIST_PS2_e
    NOP

    CMPI R2 43
    BTEQZ INT_TYPIST_PS2_f
    NOP

    CMPI R2 52
    BTEQZ INT_TYPIST_PS2_g
    NOP

    CMPI R2 51
    BTEQZ INT_TYPIST_PS2_h
    NOP

    CMPI R2 67
    BTEQZ INT_TYPIST_PS2_i
    NOP

    CMPI R2 59
    BTEQZ INT_TYPIST_PS2_j
    NOP

    CMPI R2 66
    BTEQZ INT_TYPIST_PS2_k
    NOP

    CMPI R2 75
    BTEQZ INT_TYPIST_PS2_l
    NOP

    CMPI R2 58
    BTEQZ INT_TYPIST_PS2_m
    NOP

    CMPI R2 49
    BTEQZ INT_TYPIST_PS2_n
    NOP

    CMPI R2 68
    BTEQZ INT_TYPIST_PS2_o
    NOP

    CMPI R2 77
    BTEQZ INT_TYPIST_PS2_p
    NOP

    CMPI R2 21
    BTEQZ INT_TYPIST_PS2_q
    NOP

    CMPI R2 45
    BTEQZ INT_TYPIST_PS2_r
    NOP

    CMPI R2 27
    BTEQZ INT_TYPIST_PS2_s
    NOP

    CMPI R2 44
    BTEQZ INT_TYPIST_PS2_t
    NOP

    CMPI R2 60
    BTEQZ INT_TYPIST_PS2_u
    NOP

    CMPI R2 42
    BTEQZ INT_TYPIST_PS2_v
    NOP

    CMPI R2 29
    BTEQZ INT_TYPIST_PS2_w
    NOP

    CMPI R2 34
    BTEQZ INT_TYPIST_PS2_x
    NOP

    CMPI R2 53
    BTEQZ INT_TYPIST_PS2_y
    NOP

    CMPI R2 26
    BTEQZ INT_TYPIST_PS2_z
    NOP

    CMPI R2 69
    BTEQZ INT_TYPIST_PS2_0
    NOP

    CMPI R2 22
    BTEQZ INT_TYPIST_PS2_1
    NOP

    CMPI R2 30
    BTEQZ INT_TYPIST_PS2_2
    NOP

    CMPI R2 38
    BTEQZ INT_TYPIST_PS2_3
    NOP

    CMPI R2 37
    BTEQZ INT_TYPIST_PS2_4
    NOP

    CMPI R2 46
    BTEQZ INT_TYPIST_PS2_5
    NOP

    CMPI R2 54
    BTEQZ INT_TYPIST_PS2_6
    NOP

    CMPI R2 61
    BTEQZ INT_TYPIST_PS2_7
    NOP

    CMPI R2 62
    BTEQZ INT_TYPIST_PS2_8
    NOP

    CMPI R2 70
    BTEQZ INT_TYPIST_PS2_9
    NOP

    B INT_TYPIST_PS2_INPUT_SKIP
    NOP

    INT_TYPIST_PS2_SPACE:
    LI R1 32
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_COMMA:
    LI R1 44
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_a:
    LI R1 97
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_b:
    LI R1 98
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_c:
    LI R1 99
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_d:
    LI R1 100
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_e:
    LI R1 101
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_f:
    LI R1 102
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_g:
    LI R1 103
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_h:
    LI R1 104
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_i:
    LI R1 105
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_j:
    LI R1 106
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_k:
    LI R1 107
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_l:
    LI R1 108
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_m:
    LI R1 109
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_n:
    LI R1 110
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_o:
    LI R1 111
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_p:
    LI R1 112
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_q:
    LI R1 113
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_r:
    LI R1 114
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_s:
    LI R1 115
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_t:
    LI R1 116
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_u:
    LI R1 117
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_v:
    LI R1 118
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_w:
    LI R1 119
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_x:
    LI R1 120
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_y:
    LI R1 121
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_z:
    LI R1 122
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_0:
    LI R1 48
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_1:
    LI R1 49
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_2:
    LI R1 50
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_3:
    LI R1 51
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_4:
    LI R1 52
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_5:
    LI R1 53
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_6:
    LI R1 54
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_7:
    LI R1 55
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_8:
    LI R1 56
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_9:
    LI R1 57
    B INT_TYPIST_PS2_RECEIVE
    NOP

    INT_TYPIST_PS2_RECEIVE:

    LLI R0 @DATA_TYPIST_CUR_INPUT
    SW R0 R1 0

    MFPC R7
    ADDIU R7 3
    NOP
    B TYPIST_INPUT
    NOP


    INT_TYPIST_PS2_INPUT_SKIP:

    ; update the last scan code
    LLI R0 @DATA_TYPIST_LAST_KEY
    SW R0 R2 0

    INT_TYPIST_PS2_SKIP:

    LW_SP R7 0xffff
    ADDSP 0xffff

    JR R7
    NOP



INT_TANK:
    JR R7
    NOP

INT_SNAKE:
    JR R7
    NOP

    
CLEAR_SCREEN:
    LI R0 @GLOBAL_STATE
    LI R1 1
    SW R0 R1 0

    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0


    ADDSP 0X10

    SW_SP R0 0xffff
    SW_SP R1 0xfffe
    SW_SP R2 0xfffd
    SW_SP R3 0xfffc 
    SW_SP R4 0xfffb
    SW_SP R5 0xfffa
    SW_SP R6 0xfff9 
    SW_SP R7 0xfff8 


    LI R4 0x0000
    LI R5 0x0000
    LI R1 0x0002
    SLL R1 R1 0x0000


START_OF_CLEAR_SCREEN_LOOP:

    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT

    
    NOP
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000
    LI R3 0xFF
    LI R0 0XFF
    SLL R0 R0 0
    ADDU R0 R3 R3
    SW R6 R3 0x8
    SW R6 R3 0x9
    SW R6 R3 0xA
    SW R6 R3 0xB

    SW R6 R4 0xC
    SW R6 R5 0xD

    LI R0 0X1
    SLL R0 R0 0
    LI R3 0XFF
    ADDU R3 R0 R0
    SW R6 R0 0XE

    LI R0 0X74
    SLL R0 R0 0
    LI R3 0XFF
    ADDU R3 R0 R0
    SW R6 R0 0XF


    ADDIU R4 0x0020
    CMP R4 R1

    BTEQZ CLR_CLEARTOZERO
    NOP
    B CLR_NONEEDRETURNZERO
    NOP

CLR_CLEARTOZERO:
    NOP
    LI R4 0x0000
    ADDIU R5 0x0020
    CMP R5 R1
    
    BTEQZ END_OF_CLEAR_SCREEN
    NOP

CLR_NONEEDRETURNZERO:
    NOP
    B START_OF_CLEAR_SCREEN_LOOP
    NOP


END_OF_CLEAR_SCREEN:
 
    LW_SP R0 0xffff
    LW_SP R1 0xfffe
    LW_SP R2 0xfffd
    LW_SP R3 0xfffc 
    LW_SP R4 0xfffb
    LW_SP R5 0xfffa
    LW_SP R6 0xfff9 
    LW_SP R7 0xfff8 

    ADDSP 0XFFF0

    JR R7
    NOP


TESTPRINT:
    ADDSP 2

    SW_SP R6 0xffff
    SW_SP R0 0xfffe

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


    LW_SP R6 0xffff
    LW_SP R0 0xfffe

    ADDSP 0xfffe


    JR R7
    NOP


DRAW_M_PATCH:
    ADDSP 0X10

    SW_SP R0 0xffff
    SW_SP R1 0xfffe
    SW_SP R2 0xfffd
    SW_SP R3 0xfffc 
    SW_SP R4 0xfffb
    SW_SP R5 0xfffa
    SW_SP R6 0xfff9 
    SW_SP R7 0xfff8 


    ; ----- set enlarged size shift
    LI R5 @PATCH_TYPE
    LW R5 R4 0
    SRL R4 R4 0
    SRL R4 R4 4
    SLL R4 R4 3 
    ;--- R4 = enlarged x 8, also the
    ;--- actual coord shift between 4 patches

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

 
    LW_SP R0 0xffff
    LW_SP R1 0xfffe
    LW_SP R2 0xfffd
    LW_SP R3 0xfffc 
    LW_SP R4 0xfffb
    LW_SP R5 0xfffa
    LW_SP R6 0xfff9 
    LW_SP R7 0xfff8 

    ADDSP 0XFFF0

    JR R7
    NOP 

PRINT_STRING:
    ADDSP 8

    SW_SP R0 0xffff
    SW_SP R1 0xfffe
    SW_SP R2 0xfffd
    SW_SP R3 0xfffc
    SW_SP R4 0xfffb
    SW_SP R5 0xfffa
    SW_SP R6 0xfff9
    SW_SP R7 0xfff8



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
        

 

        LW R0 R5 5 ; R2 = type
        SRL R5 R5 0
        SRL R5 R5 4
        SLL R5 R5 3

        ADDU R4 R5 R4 ; R0 = next position

        ; restore R5=0xbf00
        LI R5 0xbf
        SLL R5 R5 0

        SW R0 R4 4 ; update y


        LW R0 R4 2 ; R4 = color
        SW R5 R4 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP

        LW R0 R4 5 ; R4 = type
        SW R5 R4 0xf

        ADDIU R2 1
        ADDIU R1 1

        LW R0 R4 1 ; R4 = len

        CMP R4 R2
        BTNEZ LOOP_PRINT_STRING
        NOP


    LW_SP R0 0xffff
    LW_SP R1 0xfffe
    LW_SP R2 0xfffd
    LW_SP R3 0xfffc
    LW_SP R4 0xfffb
    LW_SP R5 0xfffa
    LW_SP R6 0xfff9
    LW_SP R7 0xfff8

    ADDSP 0xfff8

    JR R7
    NOP
    


; the menu screen returns the option in R0
MENU_SCREEN:
    ADDSP 1
    
    SW_SP R7 0xffff

    LI R0 @GLOBAL_STATE
    LI R1 1
    SW R0 R1 0

; clear the screen

    MFPC R7
    ADDIU R7 3
    NOP
    B CLEAR_SCREEN
    NOP

    LI R1 @DATA_STRING ; to write the data for printing the title

    ; --------------------- PRINT THE TITLE -------------------
    LI R0 @DATA_MENU_TITLE ; the title
    SW R1 R0 0

    LI R0 18 ; the length of the string
    SW R1 R0 1
    
    LI R0 0 ; the color
    SW R1 R0 2

    LI R0 100 ; X
    SW R1 R0 3

    LI R0 100 ; Y
    SW R1 R0 4

    LLI R0 0b0010001000000001 ; the type
    SW R1 R0 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    ; ----------------- PRINT THE OPTIONS -------------------
    LI R2 @DATA_MENU_OPTION0 ; R2=address of the first option
    LI R4 0

    LI R5 180 ; x
    SW R1 R5 3

    LI R5 100 ; y
    SW R1 R5 4

    LLI R5 0b0010001000000001 ; the type
    SW R1 R5 5

    MENU_OPTION_LOOP: 
        LW R2 R3 0 ; R3=length
        SW R1 R3 1

        ADDIU R2 1

        SW R1 R2 0 ; text


        LI R5 0 ; color
        SW R1 R5 2

        MFPC R7
        ADDIU R7 3
        NOP
        B PRINT_STRING
        NOP
        
        ; set the next x position
        LW R1 R5 3
        ADDIU R5 32
        SW R1 R5 3

        ; reset the y position
        LI R5 100 ; y
        SW R1 R5 4

        ADDU R2 R3 R2 ; move to the next option
        ADDIU R4 1
        
        CMPI R4 4
        BTNEZ MENU_OPTION_LOOP
        NOP
    
    ; ------- set the selection state -------

    LI R1 0

    LI R0 @DATA_MENU_SELECTED
    SW R0 R1 0

    LI R0 @DATA_MENU_OK
    SW R0 R1 0

    ; ---------- draw the selected sign ----------
        LI R0 0xbf
        SLL R0 R0 0

        LI R1 62
        SW R0 R1 0x8

        LI R1 180
        SW R0 R1 0xc

        LI R1 70
        SW R0 R1 0xd

        LI R1 0
        SW R0 R1 0xe

        MFPC R7
        ADDIU R7 3
        NOP
        B TESTPRINT
        NOP

        LLI R1 0b0010001000000001 ; the type
        SW R0 R1 0xf

    ; ------------------------------

    LI R0 @GLOBAL_STATE
    LI R1 1
    SW R0 R1 0

    MENU_LOOP:
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LI R5 @DATA_MENU_OK
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LW R5 R4 0
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        BEQZ R4 MENU_LOOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0


    LW_SP R7 0xffff
    ADDSP 0xffff

    JR R7
    NOP

TYPIST_INPUT:
    ADDSP 8
    SW_SP R0 0xffff
    SW_SP R1 0xfffe
    SW_SP R2 0xfffd
    SW_SP R3 0xfffc 
    SW_SP R4 0xfffb
    SW_SP R5 0xfffa
    SW_SP R6 0xfff9 
    SW_SP R7 0xfff8 

    LLI R0 @DATA_TYPIST_CUR_SENTENCE
    LW R0 R1 0 ; R1 = cur sentence
    LW R0 R2 1 ; R2 = cur index

    CMPI R1 3
    BTEQZ TYPIST_INPUT_NEXT_SKIP
    NOP

    ; ----------- render the next word --------------
    LLI R0 @DATA_SENTENCE_POINTERS
    ADDU R0 R1 R0 
    LW R0 R0 0

    ADDU R0 R2 R0 
    ; R0 = pointer to the current(next) character

    LI R3 @STRING_POINTER
    SW R3 R0 0 ; pointer
    LI R0 1
    SW R3 R0 1 ; len
    LI R0 0
    SW R3 R0 2 ; color

    LLI R0 @DATA_SENTENCE_XS
    ADDU R0 R1 R0
    LW R0 R0 0 ; R0 = x
    SW R3 R0 3

    SLL R0 R2 3
    LI R4 136
    ADDU R0 R4 R0 ; R0 = y
    SW R3 R0 4
     
    LLI R0 0x12ff
    SW R3 R0 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    ; ---------------------

    TYPIST_INPUT_NEXT_SKIP:
    ADDU R1 R2 R3
    BEQZ R3 TYPIST_INPUT_CLEAR_SKIP ; this means we are now 
    ; in the initial state
    NOP

    ; go the the previous position

    BNEZ R2 TYPIST_INPUT_CL_SKIP
    NOP
    ; change line

    ADDIU R1 0xffff
    LLI R2 @DATA_SENTENCE_LENGTHS
    ADDU R1 R2 R2
    LW R2 R2 0 ; R2 = length of the previous sentence
    ADDIU R2 0xffff

    TYPIST_INPUT_CL_SKIP:

    ; fetch the data
    LI R5 @STRING_POINTER

    LLI R0 @DATA_SENTENCE_POINTERS
    ADDU R0 R1 R0
    LW R0 R0 0
    ADDU R0 R2 R0

    SW R5 R0 0 ; pointer

    LW R0 R0 0 ; the ascii of the previous character
    
    LLI R3 @DATA_TYPIST_CUR_INPUT
    LW R3 R3 0 ; the input

    LI R4 1
    SW R5 R4 1 ; length

    LLI R4 @DATA_SENTENCE_XS
    ADDU R4 R1 R4
    SW R5 R4 3 ; x

    SLL R2 R2 3
    LI R4 136
    ADDU R2 R4 R2
    SW R5 R4 4 ; y

    LLI R4 0x12ff
    SW R5 R4 5 ; type

    CMP R0 R3

    ; set the color
    LLI R4 0b000111000
    SW R5 R4 2

    BTEQZ TYPIST_INPUT_CORRECT
    NOP
    LLI R4 0b111000000
    SW R5 R4 2

    TYPIST_INPUT_CORRECT:
    
    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP
     
    ; ------- clear the last position ---------

    TYPIST_INPUT_CLEAR_SKIP:
    

    LLI R0 @DATA_TYPIST_CUR_SENTENCE
    LW R0 R1 0 ; R1 = cur sentence
    LW R0 R2 1 ; R2 = cur index

    LLI R0 @DATA_SENTENCE_LENGTHS
    ADDU R0 R1 R0 ; length of the current line
    
    ADDIU R2 1
    
    CMP R2 R0
    BTNEZ TYPIST_INPUT_NEXT_CL_SKIP
    NOP
    ; move to the next line
    ADDIU R1 1
    LI R2 0

    TYPIST_INPUT_NEXT_CL_SKIP:

    LLI R0 @DATA_TYPIST_CUR_SENTENCE
    SW R0 R1 0 ; R1 = next sentence
    SW R0 R2 1 ; R2 = next index

    LW_SP R0 0xffff
    LW_SP R1 0xfffe
    LW_SP R2 0xfffd
    LW_SP R3 0xfffc 
    LW_SP R4 0xfffb
    LW_SP R5 0xfffa
    LW_SP R6 0xfff9 
    LW_SP R7 0xfff8 

    ADDSP 0xfff8

    JR R7
    NOP


TYPIST:
    ADDSP 10
    SW_SP R7 0XFFFE

    ; whatever, clear screen first
    MFPC R7
    ADDIU R7 3
    NOP
    B CLEAR_SCREEN
    NOP

    ; init pointers
    LLI R1 @DATA_TYPIST_SENTENCE1
    LLI R2 @DATA_SENTENCE_POINTERS
    SW R2 R1 0

    LLI R1 @DATA_TYPIST_SENTENCE2
    LLI R2 @DATA_SENTENCE_POINTERS
    SW R2 R1 1

    LLI R1 @DATA_TYPIST_SENTENCE3
    LLI R2 @DATA_SENTENCE_POINTERS
    SW R2 R1 2
    
    ; init user state
    LLI R2 @DATA_TYPIST_CUR_INDEX
    LLI R1 0
    SW R2 R1 0

    LLI R2 @DATA_TYPIST_CUR_SENTENCE
    LLI R1 0
    SW R2 R1 0


    

    ; print typist title
    LI R1 @DATA_STRING
    LLI R2 @DATA_TYPIST_TITLE
    SW R1 R2 0
    LI R2 21
    SW R1 R2 1
    LI R2 0B10010010 ; COLOR: GRAY CLOSE TO BLACK
    SW R1 R2 2
    LI R2 0X30
    SW R1 R2 3
    LI R2 88
    SW R1 R2 4

    LI R2 0X22 ; TWICE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP



    LI R4 0 ; sentence number

    TYPE_PRINT_SENTENCE_LOOP:
        ; print 1 sentence

        LI R1 @DATA_STRING
        LLI R3 @DATA_SENTENCE_POINTERS
        ADDU R3 R4 R3
        LW R3 R2 0 ; R2 points to real str
        SW R1 R2 0

        LLI R3 @DATA_SENTENCE_LENGTHS
        ADDU R3 R4 R3
        LW R3 R2 0 ; sentence length 
        SW R1 R2 1

        LLI R2 0B101101101 ; COLOR: SUPER LIGHT GRAY
        SW R1 R2 2

        LLI R3 @DATA_SENTENCE_XS
        ADDU R3 R4 R3
        LW R3 R2 0 ; sentence position (x) 
        SW R1 R2 3

        LI R2 136 ; sentence position (y, fixed)
        SW R1 R2 4

        LI R2 0X12 ; single size
        SLL R2 R2 0
        LI R3 0XFF
        ADDU R3 R2 R2
        SW R1 R2 5

        MFPC R7
        ADDIU R7 3
        NOP
        B PRINT_STRING
        NOP

        ADDIU R4 1
        CMPI R4 3
        BTNEZ TYPE_PRINT_SENTENCE_LOOP
        NOP

        ; clear the state
        LLI R1 @DATA_TYPIST_CUR_SENTENCE
        LI R2 0
        SW R1 R2 0
        SW R1 R2 1

        MFPC R7
        ADDIU R7 3
        NOP
        B TYPIST_INPUT
        NOP

        ; enter the loop
        LI R0 @GLOBAL_STATE
        LI R1 2
        SW R0 R1 0 

TYPIST_STUCK_LOOP:
    NOP
    NOP
    NOP
    NOP

    LI R2 @GLOBAL_ESC
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LW R2 R1 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BEQZ R1 TYPIST_STUCK_LOOP
    NOP
    NOP
    LI R1 0
    SW R2 R1 0
    NOP
    NOP

    
    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0 



    LW_SP R7 0XFFFE
    ADDSP 0XFFF0
    JR R7
    NOP
    

TANK:
    JR R7
    NOP

SNAKE:
    
    ADDSP 10
    SW_SP R7 0XFFFE

    ; whatever, clear screen first
    MFPC R7
    ADDIU R7 3
    NOP
    B CLEAR_SCREEN
    NOP

    ; clear the map and snake
    LI R1 0
    
;    CLEAR_SNAKE_LOOP:
;
 ;       ADDIU R1 1
  ;      CMPI 


    
    SNAKE_STUCK_LOOP:
    NOP
    NOP
    NOP

    LI R2 @GLOBAL_ESC
    LW R2 R1 0
    BEQZ R1 SNAKE_STUCK_LOOP
    NOP

    LI R1 0
    SW R2 R1 0
    NOP
    NOP

    LW_SP R7 0XFFFE
    ADDSP 0XFFF0
    JR R7
    NOP


ABOUT:

    ADDSP 10
    SW_SP R7 0XFFFE

    ; whatever, clear screen first
    MFPC R7
    ADDIU R7 3
    NOP
    B CLEAR_SCREEN
    NOP

    LI R1 @DATA_STRING

    ; print about title
    LLI R2 @DATA_ABOUT_TITLE
    SW R1 R2 0
    LI R2 12
    SW R1 R2 1
    LI R2 0B10010010 ; COLOR: GRAY CLOSE TO BLACK
    SW R1 R2 2
    LI R2 0X50
    SW R1 R2 3
    LI R2 112
    SW R1 R2 4

    LI R2 0X32 ; TRIPLE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    
    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    ; print about info
    LLI R2 @DATA_ABOUT_INFO
    SW R1 R2 0
    LI R2 33
    SW R1 R2 1
    LI R2 0B11011011 ; COLOR: BRIGHT GRAY
    SW R1 R2 2
    LI R2 0XA0
    SW R1 R2 3
    LI R2 0X7C
    SW R1 R2 4

    LI R2 0X12 ; SINGLE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    ; print about author1
    LLI R2 @DATA_ABOUT_AUTHOR1
    SW R1 R2 0
    LI R2 8
    SW R1 R2 1
    LI R2 0B11011011 ; COLOR: BRIGHT GRAY
    SW R1 R2 2
    LI R2 0XC0
    SW R1 R2 3
    LI R2 0XC0
    SW R1 R2 4

    LI R2 0X22 ; DOUBLE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP


    ; print about author2
    LLI R2 @DATA_ABOUT_AUTHOR2
    SW R1 R2 0
    LI R2 9
    SW R1 R2 1
    LI R2 0B11011011 ; COLOR: BRIGHT GRAY
    SW R1 R2 2
    LI R2 0XE0
    SW R1 R2 3
    LI R2 0Xb8
    SW R1 R2 4

    LI R2 0X22 ; DOUBLE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    
    ; print about author3
    LLI R2 @DATA_ABOUT_AUTHOR3
    SW R1 R2 0
    LI R2 13
    SW R1 R2 1
    LI R2 0B11011011 ; COLOR: BRIGHT GRAY
    SW R1 R2 2
    LI R2 0X1
    SLL R2 R2 0
    SW R1 R2 3
    LI R2 0X98
    SW R1 R2 4

    LI R2 0X22 ; DOUBLE SIZE
    SLL R2 R2 0
    LI R3 0XFF
    ADDU R3 R2 R2
    SW R1 R2 5

    MFPC R7
    ADDIU R7 3
    NOP
    B PRINT_STRING
    NOP

    ABOUT_STUCK_LOOP:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    LI R2 @GLOBAL_ESC
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LW R2 R1 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BEQZ R1 ABOUT_STUCK_LOOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    LI R1 0
    SW R2 R1 0
    LW_SP R7 0XFFFE
    ADDSP 0XFFF0
    JR R7
    NOP
