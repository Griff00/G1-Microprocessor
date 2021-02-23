		#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start
	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0xff
	movwf	LATD, A
	movlw 	0x0
	movwf	TRISD, A	    ; Port C all outputs
	OE1 EQU	0x01
	CP1 EQU	0x02
	test_read EQU 0x05
	movlw	0x02
	movwf	0x07, A
	bra 	test

delay:
	decfsz	0x08, A		; Decrement location 0x08 (skip if 0)
	bra	delay		; While not zero, branch to delay
	return			; When zero, return
	
prep_delay:
	movlw	0x02		;Literal 0xff to W
	movwf	0x08, A		;W to 0x08
	call	delay		;Call delay subroutine
	decfsz	0x07, A
	bra	prep_delay
	movlw	0x02
	movwf	0x07, A
	return
	
set_OE1_output:	;Set pin0 low
    movlw   0x00
    movwf   OE1, A
    return
set_OE1_no_output: ;Set pin0 high
    movlw   0x01
    movwf   OE1, A
    return
set_clock1_low:
    movlw   0x00
    movwf   CP1, A
    return
set_clock1_high:
    movlw   0x02
    movwf   CP1, A
    return
Update_LATD:
    movf    OE1, W, A
    addwf   CP1, W, A
    movwf   LATD, A
    return
set_PORTE_output:
    movlw   0x00
    movwf   TRISE, A
    return
set_PORTE_input:
    movlw   0xff
    movwf   TRISE, A
    return
    
Write:
    call    set_OE1_no_output
    call    set_clock1_high
    call    Update_LATD

    call    prep_delay
    movlw   0xaa
    movwf   LATE, A
    call    set_PORTE_output
    call    prep_delay
    call    set_clock1_low
    call    Update_LATD
    call    prep_delay
    call    set_clock1_high
    call    Update_LATD
    call    prep_delay
    return

Read:
    call    set_PORTE_input
    call    prep_delay
    call    set_OE1_output
    call    Update_LATD
    call    prep_delay
    movf    PORTE, W, A
    movwf   test_read, A
    movlw   0x00
    movwf   TRISC, A
    movf    test_read, W, A
    movwf   LATC, W
    return
    
test:
    call    set_OE1_no_output
    call    set_clock1_high
    call    Update_LATD
    
    call    Write
    call    Read  
    
    goto    0x00
    end	    main