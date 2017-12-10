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
            .ascii hello world
        DATA_TYPIST_SENTENCE2:
            .ascii i love study, i love deadlines
        DATA_TYPIST_SENTENCE3:
            .ascii typing these words is boring

        DATA_TYPIST_CUR_SENTENCE:
            .word 0

        DATA_TYPIST_CUR_INDEX:
            .word 0

    DATA_SNAKE:
        SNAKE_RANDOM:
            .word 0
        SNAKE_GAME_STATE:
            .word 0
        SNAKE_TIME_COUNTER:
            .word 0
        SNAKE_MAP:
            .pad 256
        SNAKE_QUEUE:
            .pad 256
        SNAKE_QUEUE_HEAD:
            .word 0
        SNAKE_QUEUE_TAIL:
            .word 0    
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
        NOP
        ; R0 = choice

        LI R1 @DATA_MENU_SELECTED
        LW R1 R0 0

        MFPC R7
        ADDIU R7 FUNC_RET
        
        
        ; B SNAKE_PAD
        NOP
        NOP


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

INT_TYPIST:
    JR R7
    NOP

INT_TANK:
    JR R7
    NOP

INT_SNAKE:

    ADDSP 1
    SW_SP R7 0xffff

    MFCS R0
    CMPI R0 0xa

    BTEQZ INT_SNAKE_PS2
    NOP
    NOP

    B INT_SNAKE_CLK
    NOP
    NOP

    JR R7
    NOP


INT_SNAKE_PS2:
    LI R0 0XBF
    SLL R0 R0 0

    LW R0 R1 0X4 ; scan code

    LI R0 @KEY_LAST
    LW R0 R2 0;

    LI R3 0XE0
    CMP R2 R3
    BTEQZ INT_SNAKE_PS2_PAD
    NOP
    LI R3 0XF0
    CMP R2 R3
    BTNEZ INT_SNAKE_PS2_RET_SKIP1
    NOP
    NOP
    B INT_SNAKE_PS2_RET
    NOP
    NOP
    NOP
    INT_SNAKE_PS2_RET_SKIP1:

    NOP

    INT_SNAKE_PS2_NO_PAD:
        CMPI R1 0X29
        BTEQZ INT_SNAKE_PS2_SPACE
        NOP

        B INT_SNAKE_PS2_RET
        NOP
    
    INT_SNAKE_PS2_PAD:
        CMPI R1 0X75
        BTEQZ INT_SNAKE_PS2_UARROW
        NOP

        CMPI R1 0X72
        BTEQZ INT_SNAKE_PS2_DARROW
        NOP
        
        CMPI R1 0X6B
        BTEQZ INT_SNAKE_PS2_LARROW
        NOP
        
        CMPI R1 0X74
        BTEQZ INT_SNAKE_PS2_RARROW
        NOP

        B INT_SNAKE_PS2_RET
        NOP
        NOP

        INT_SNAKE_PS2_SPACE:

            LLI R2 @SNAKE_GAME_STATE
            LI R3 1
            SW R2 R3 0
            
            B INT_SNAKE_PS2_RET
            NOP

        INT_SNAKE_PS2_UARROW:
            LLI R2 @SNAKE_DIRECTION
            LI R3 0
            SW R2 R3 0

            B INT_SNAKE_PS2_RET
            NOP


        INT_SNAKE_PS2_DARROW:
            LLI R2 @SNAKE_DIRECTION
            LI R3 1
            SW R2 R3 0

            B INT_SNAKE_PS2_RET
            NOP

        INT_SNAKE_PS2_LARROW:
            LLI R2 @SNAKE_DIRECTION
            LI R3 2
            SW R2 R3 0

            B INT_SNAKE_PS2_RET
            NOP

        INT_SNAKE_PS2_RARROW:
            LLI R2 @SNAKE_DIRECTION
            LI R3 3
            SW R2 R3 0

            B INT_SNAKE_PS2_RET
            NOP


INT_SNAKE_PS2_RET:
    LI R0 @KEY_LAST
    SW R0 R1 0 ; update

    LW_SP R7 0xffff
    ADDSP 0xffff

    JR R7
    NOP


INT_SNAKE_CLK:


    LLI R1 @SNAKE_GAME_STATE
    LW R1 R2 0

    CMPI R2 0 ; if state = 0, game is not good
    BTNEZ SNAKE_REFRESH_SCREEN 
    NOP
    NOP

    B SNAKE_PAINT_SCREEN
    NOP
    NOP

    LW_SP R7 0xffff
    ADDSP 0xffff

    JR R7
    NOP


SNAKE_REFRESH_SCREEN:

    SNAKE_GAME_LOGIC:
        LLI R5 @SNAKE_QUEUE_HEAD
        LW R5 R4 0 ;  R4 - grid number of the snake head
        LLI R5 @SNAKE_DIRECTION
        LW R5 R3 0 ;  R3 - snake direction, u d l r
        ADDIU3 R4 R2 0 ; R2 - prepare to be next grid of snake head

        ADDIU3 R4 R1 0
        LI R0 0XF0
        AND R1 R0 ; R1 - x grid number
        LI R0 0X0F
        AND R0 R4 ; R0 - y grid number

        CMPI R3 0
        BTEQZ SNAKE_MOVES_UP
        NOP

        CMPI R3 1
        BTEQZ SNAKE_MOVES_DOWN
        NOP

        CMPI R3 2
        BTEQZ SNAKE_MOVES_LEFT
        NOP

        CMPI R3 3
        BTEQZ SNAKE_MOVES_RIGHT
        NOP

        SNAKE_MOVES_UP:
        ADDIU R2 0XF0
        B SNAKE_CHECK_NEXT_GRID
        NOP

        SNAKE_MOVES_DOWN:
        ADDIU R2 0X10
        B SNAKE_CHECK_NEXT_GRID
        NOP

        SNAKE_MOVES_LEFT:
        ADDIU R0 0XFF
        LI R2 0X0F
        AND R2 R0
        ADDU R0 R1 R2
        B SNAKE_CHECK_NEXT_GRID
        NOP

        SNAKE_MOVES_RIGHT:
        ADDIU R0 1
        LI R2 0X0F
        AND R2 R0
        ADDU R0 R1 R2
        B SNAKE_CHECK_NEXT_GRID
        NOP
        NOP

        SNAKE_CHECK_NEXT_GRID:
        LLI R3 @SNAKE_MAP
        ADDU R3 R2 R3 ; R3 - the next grid addr


        LLI R0 @SNAKE_QUEUE_HEAD
        LW R0 R1 0 ; R1 -> cur queue head
        ADDIU R1 1 ; head++
        LI R5 0XFF
        AND R1 R5 ; head &= 0xff
        SW R0 R1 0

        LLI R0 @SNAKE_QUEUE
        ADDU R0 R1 R1
        SW R1 R2 0 ; queue[head] = next grid number


        LLI R0 @SNAKE_QUEUE_TAIL
        LW R0 R1 0 ; R1 -> cur queue tail

        LLI R0 @SNAKE_QUEUE
        ADDU R0 R1 R0  ; R0 -> the grid of tail
        LI R1 0
        SW R0 R1 0 ; grid of tail set as ground

        LW R3 R2 0 ; R2 - the item on the next grid

        LI R1 2
        SW R3 R1 0 ; next grid -> set to head
        LI R1 0
        SW R4 R1 1 ; current grid -> set to body 

        CMPI R2 1
        BTEQZ SNAKE_MET_SNAKE_BODY
        NOP

        CMPI R2 2
        BTEQZ SNAKE_MET_SNAKE_HEAD
        NOP

        CMPI R2 3
        BTEQZ SNAKE_MET_APPLE
        NOP

        SNAKE_MET_SNAKE_BODY:
        SNAKE_MET_SNAKE_HEAD:

        LLI R0 @SNAKE_GAME_STATE
        LI R1 0
        SW R0 R1 0 ; game state set to 0, GAME OVER!

        B SNAKE_GAME_LOGIC_END_GROWTH
        NOP  

        SNAKE_MET_APPLE:

        ; TODO: GENERATE NEW APPLE
        B SNAKE_GAME_LOGIC_END_GROWTH
        NOP


    SNAKE_GAME_LOGIC_END:

    LLI R0 @SNAKE_QUEUE_TAIL
    LW R0 R1 0 ; R1 -> cur queue tail
    ADDIU R1 1
    LI R2 0XFF
    AND R1 R2 ; R1 -> (R1 + 1) % 256
    SW R0 R1 0 ; queue tail <= q1

    

    SNAKE_GAME_LOGIC_END_GROWTH:

SNAKE_PAINT_SCREEN:

    NOP

    LI R4 0 ; grid number (0-255)
    


    SNAKE_REFRESH_SCREEN_LOOP:

        ADDIU3 R4 R2 0
        SRL R2 R2 4
        LI R3 0X0F

        AND R2 R3 ; R2 - x grid number
        SLL R2 R2 5 ; R2 - x coordinate
        AND R3 R4 ; R3 - y grid number
        SLL R3 R3 5 ; R3 - y coordinate

        ; paint background color
        MFPC R7
        ADDIU R7 0x0003 
        NOP
        B TESTPRINT
        NOP

        LI R0 0xbf
        SLL R0 R0 0 ; R0 : the start addr for graphic

        LI R1 26
        SW R0 R1 0x8 ; space
        SW R0 R2 0xc ; coord
        SW R0 R3 0xd ; coord
        LLI R1 0b101101101
        SW R0 R1 0xe ; color
        LLI R1 0b0100001011111111 ; type
        SW R0 R1 0xf

        LLI R1 @SNAKE_MAP
        ADDU R1 R4 R1
        LW R1 R5 0 ; R5 - item on cur grid
        ; items: 0 - ground, 1 - snake body, 2 - snake head, 3 - apple

        CMPI R5 1
        BTEQZ SNAKE_PRINT_SNAKE_BODY
        NOP

        CMPI R5 2
        BTEQZ SNAKE_PRINT_SNAKE_HEAD
        NOP

        CMPI R5 3
        BTEQZ SNAKE_PRINT_APPLE
        NOP

        B SNAKE_READY_NEXT_LOOP
        NOP

        SNAKE_PRINT_SNAKE_BODY:
            LI R5 0B00100000
            B SNAKE_PRINT_APPENDIX
            NOP

        SNAKE_PRINT_SNAKE_HEAD:
            LI R5 0B00111000
            B SNAKE_PRINT_APPENDIX
            NOP

        SNAKE_PRINT_APPLE:
            LI R5 1
            SLL R5 R5 0
            B SNAKE_PRINT_APPENDIX
            NOP

        SNAKE_PRINT_APPENDIX:
            ; paint appendix things on ground
            MFPC R7
            ADDIU R7 0x0003 
            NOP
            B TESTPRINT
            NOP

            LI R0 0xbf
            SLL R0 R0 0 ; R0 : the start addr for graphic

            LI R1 26
            SW R0 R1 0x8 ; space
            SW R0 R2 0xc ; coord
            SW R0 R3 0xd ; coord
            SW R0 R5 0xe ; color
            LLI R1 0b0100001011111111 ; type
            SW R0 R1 0xf

    SNAKE_READY_NEXT_LOOP:

        LI R5 0XFF
        CMP R4 R5
        BTEQZ SNAKE_REFRESH_SCREEN_LOOP_END
        NOP
        ADDIU R4 1
        B SNAKE_REFRESH_SCREEN_LOOP
        NOP
    
    SNAKE_REFRESH_SCREEN_LOOP_END:
    

CLEAR_SCREEN:
    LI R0 @GLOBAL_STATE
    LI R1 1
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



    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0
    
     
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

    LI R0 17 ; the length of the string
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

    LI R0 0xbf
    SLL R0 R0 0
    SW R0 R4 0

    LI R0 @GLOBAL_STATE
    LI R1 0
    SW R0 R1 0


    LW_SP R7 0xffff
    ADDSP 0xffff

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


TYPIST_STUCK_LOOP:
    NOP
    NOP
    NOP
    NOP

    LI R2 @GLOBAL_ESC
    LW R2 R1 0
    NOP
    BEQZ R1 TYPIST_STUCK_LOOP
    NOP
    NOP
    LI R1 0
    SW R2 R1 0
    NOP
    NOP


    LW_SP R7 0XFFFE
    ADDSP 0XFFF0
    JR R7
    NOP
    

TANK:
    JR R7
    NOP

SNAKE:

    ; TEST
    LI R0 0XBF
    SLL R0 R0 0
    LI R1 0X99
    SW R0 R1 0

    ADDSP 10
    SW_SP R7 0XFFFE

    ; whatever, clear screen first
    MFPC R7
    ADDIU R7 3
    NOP
    B CLEAR_SCREEN
    NOP


SNAKE_INIT_GAME:

    LLI R2 @SNAKE_GAME_STATE
    LI R1 0
    SW R2 R1 0 ; game is not started

    ; clear the map and snake
    LI R1 4
    LLI R2 @SNAKE_QUEUE_HEAD
    SW R2 R1 0
    LI R1 0
    LLI R2 @SNAKE_QUEUE_TAIL
    SW R2 R1 0


    LI R1 0
    LI R2 1
    SLL R2 R2 0
    CLEAR_SNAKE_LOOP:
        LLI R3 @SNAKE_MAP
        ADDU R3 R1 R3
        LI R4 0
        SW R3 R4 0
        ADDIU R1 1
        CMP R1 R2
        BTNEZ CLEAR_SNAKE_LOOP
        NOP

    ; add initial snake on map and queue
    LLI R2 @SNAKE_QUEUE
    LLI R4 @SNAKE_MAP 

    LI R1 0X33
    SW R2 R1 0
    ADDU R4 R1 R5
    LI R6 1
    SW R5 R6 0

    LI R1 0X34
    SW R2 R1 1
    ADDU R4 R1 R5
    LI R6 1
    SW R5 R6 0

    LI R1 0X35
    SW R2 R1 2
    ADDU R4 R1 R5
    LI R6 1
    SW R5 R6 0

    LI R1 0X36
    SW R2 R1 3
    ADDU R4 R1 R5
    LI R6 2        ; head here
    SW R5 R6 0
    


    LI R0 @GLOBAL_STATE
    LI R1 4
    SW R0 R1 0
    NOP

    
    SNAKE_STUCK_LOOP:
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
    LW R2 R1 0
    NOP
    NOP
    NOP
    NOP
    NOP
    BEQZ R1 SNAKE_STUCK_LOOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    LI R1 0
    NOP
    NOP
    NOP
    NOP
    NOP
    SW R2 R1 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP


    LI R0 @GLOBAL_STATE
    NOP
    NOP
    NOP
    NOP
    NOP
    LI R1 0
    NOP
    NOP
    NOP
    SW R0 R1 0
    NOP
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
    NOP
    NOP

    LW_SP R7 0XFFFE
    ADDSP 0XFFF0
    JR R7
    NOP
