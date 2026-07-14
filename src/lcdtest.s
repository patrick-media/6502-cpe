lcd_data = $6000
lcd_ctrl = $6001

DDRB = $6002
DDRA = $6003

RS = %00000001
E  = %00000010

	.org $8000
reset:
	ldx #$ff
	txs
	stx DDRB
	stx DDRA

	lda #%00000001 ; clear screen
	jsr lcd_instruction
	lda #%00111000 ; function set (8 bits, 2 lines, 8x5 dots)
	jsr lcd_instruction
	lda #%00001111 ; display ctrl (on, cursor on, cursor blinking on)
	jsr lcd_instruction

	lda #'t'
	jsr lcd_print
	lda #'e'
	jsr lcd_print
	lda #'s'
	jsr lcd_print
	lda #'t'
	jsr lcd_print
loop:
	jmp loop

lcd_instruction:
	jsr lcd_wait
	sta lcd_data
	lda #$0
	sta lcd_ctrl
	lda #E
	sta lcd_ctrl
	lda #$0
	sta lcd_ctrl
	rts

lcd_print:
	jsr lcd_wait
	sta lcd_data
	lda #RS
	sta lcd_ctrl
	lda #(RS | E)
	sta lcd_ctrl
	lda #RS
	sta lcd_ctrl
	rts

lcd_wait:
	pha
	lda #$ff
.loop:
	dec
	bne .loop
	pla
	rts

	.org $fffc
	.word reset
	.word $0000
