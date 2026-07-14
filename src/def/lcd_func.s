;
; LCD functions for 6502 breadboard computer. "def/lcd_defines.s" is required (separate to avoid overlap).
;

; Send instruction to lCD (RS = 0)
lcd_instr:
	jsr lcd_wait	; Wait until LCD is ready
	sta lcd_data	; Store A (parameter) to the LCD data lines (PORTB)
	lda #$0		; Clear LCD control lines
	sta lcd_ctrl	; Send to LCD control lines (PORTA)
	lda #E		; Pulse the enable (E) signal
	sta lcd_ctrl
	lda #$0		; Clear LCD control lines
	sta lcd_ctrl
	rts

; Send character to print to LCD (RS = 1)
lcd_print:
	jsr lcd_wait	; Wait until LCD is ready
	sta lcd_data	; Store A (parameter) to the LCD data lines (PORTB)
	lda #RS		; Clear LCD control lines except for RS
	sta lcd_ctrl	; Send to LCD control lines (PORTA)
	lda #(RS | E)	; Pulse the enable (E) signal (with RS enabled)
	sta lcd_ctrl
	lda #RS		; Clear LCD control lines except for RS
	sta lcd_ctrl
	rts

; Wait for LCD to be ready (this is currently not checking the LCD's busy flag, just a timer counting down)
lcd_wait:
	pha		; Save A
	lda #$ff	; Start counting down from a large value (0xFF)
.loop:
	dec		; Decrement A
	bne .loop	; Branch back to ".loop" if A > 0 ("bne" checks the zero flag)
	pla		; Restore A ("bne" fell through since A = 0)
	rts
