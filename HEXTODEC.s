#include <xc.inc>
global  HEXTODEC_input_high, HEXTODEC_input_low, HEXTODEC_convert, D_h, D_l

psect	udata_acs   ; named variables in access ram
HEX_h:		ds 1
HEX_l:		ds 1
k_low:		ds 1
k_high:		ds 1
S_1:	ds 1
S_2:	ds 1
S_3:	ds 1
S_4:	ds 1
N_1:	ds 1
N_2:	ds 1
N_3:	ds 1
N_4:	ds 1
MN_1:	ds 1
MN_2:	ds 1
MN_3:	ds 1
MN_4:	ds 1
F_1:	ds 1
F_2:	ds 1
F_3:	ds 1
F_4:	ds 1
D_h:	ds 1
D_l:	ds 1

;PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
psect	HEXTODEC_code,class=CODE
    
HEXTODEC_input_high:
    movwf   HEX_h, A
    return
HEXTODEC_input_low:
    movwf   HEX_l, A
    return
HEXTODEC_convert:
    movlw   0x41
    movwf   k_high, A
    movlw   0x00
    movwf   TRISC, A
    movff   k_high, LATC, A
    movlw   0x8a
    movwf   k_low, A
    movlw   0x00
    movwf   TRISC, A
    movff   k_low, LATC, A
    movlw   0x00
    movwf   S_1, A
    movwf   S_2, A
    movwf   S_3, A
    movwf   S_4, A

Mult_by_k:
    movf    k_low, W, A
    mulwf   HEX_l, A
    movf    PRODL, W, A
    addwf   S_1, A
    movf    PRODH, W, A 
    addwfc  S_2, A
    movlw   0x00
    addwfc  S_3, A
    addwfc  S_4, A
    
    movf    k_low, W, A
    mulwf   HEX_h, A
    movlw   0x00
    movf    PRODL, W, A
    addwf   S_2, A
    movf    PRODH, W, A
    addwfc  S_3, A
    movlw   0x00
    addwfc  S_4, A
    
    movf    k_high, W, A
    mulwf   HEX_l, A
    movlw   0x00
    movf    PRODL, W, A
    addwf   S_2, A
    movf    PRODH, W, A
    addwfc  S_3, A
    movlw   0x00
    addwfc  S_4, A
    
    movwf   k_high, W, A
    mulwf   HEX_h, A
    movf    PRODL, W, A
    addwf   S_3, A
    movf    PRODH, W, A
    addwfc  S_4, A

Control_loop:
    movff   S_1, N_1, A
    movff   S_2, N_2, A
    movff   S_3, N_3, A
    
    rlcf    S_4, A
    rlcf    S_4, A
    rlcf    S_4, A
    rlcf    S_4, A
    movff   S_4, F_4, A
    
    call    Mult_by_10
    
    movff   MN_1, N_1, A
    movff   MN_2, N_2, A
    movff   MN_3, N_3, A
 
    movff   MN_4, F_3, A   
    
    call    Mult_by_10
    
    movff   MN_1, N_1, A
    movff   MN_2, N_2, A
    movff   MN_3, N_3, A
    
    rlcf    MN_4, A
    rlcf    MN_4, A
    rlcf    MN_4, A
    rlcf    MN_4, A
    movff   MN_4, F_2, A
    
    call    Mult_by_10
    
    movff   MN_4, F_1, A   
    
    movff   F_4, D_h, A
    movf    F_3, W, A
    addwf   D_h, A
    
    movff   F_2, D_l, A
    movf    F_1, W, A
    addwf   D_l, A
    
    movlw   0x00
    movwf   TRISC, A
    movff   D_h, LATC, A
    movff   D_l, LATC, A
 
    return
    
Mult_by_10:
    clrf    MN_1, A
    clrf    MN_2, A
    clrf    MN_3, A
    clrf    MN_4, A
     
    movlw   0x0a
    mulwf   N_1, A
    movf    PRODL, W, A
    addwf   MN_1, A
    movf    PRODH, W, A
    addwfc  MN_2, A
    movlw   0x00
    addwfc  MN_3, A
    addwfc  MN_4, A
   
    movlw   0x0a
    mulwf   N_2, A
    movf    PRODL, W, A
    addwf   MN_2, A
    movf    PRODH, W, A
    addwfc  MN_3, A
    movlw   0x00
    addwfc  MN_4, A
    
    movlw   0x0a
    mulwf   N_3, A
    movf    PRODL, W, A
    addwf   MN_3, A
    movf    PRODH, W, A
    addwfc  MN_4, A
    
    movlw   0x00
    movwf   TRISC, A
    movff   MN_1, LATC, A
    movff   MN_2, LATC, A
    movff   MN_3, LATC, A
    movff   MN_4, LATC, A
    
    return