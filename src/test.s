lcd_data = $6000
lcd_ctrl = $6001

DDRB = $6002
DDRA = $6003

RS = %00000001
E  = %00000010
RW = %00000100

	.org $8000
reset:
	ldx #$ff
	txs

	lda #$ff
	sta DDRA
	sta DDRB

	lda #%00000001 ; Clear screen
	jsr lcd_send_instr
	lda #%00001111 ; Enable display, cursor, and blinking cursor
	jsr lcd_send_instr
	lda #%00111000 ; Function set - 8 bits, 2 lines, 5x8 dots
	jsr lcd_send_instr

	lda #'H'
	jsr lcd_send_data
	lda #'e'
	jsr lcd_send_data
	lda #'l'
	jsr lcd_send_data
	jsr lcd_send_data
	lda #'o'
	jsr lcd_send_data
	lda #','
	jsr lcd_send_data
	lda #' '
	jsr lcd_send_data
	lda #'W'
	jsr lcd_send_data
	lda #'o'
	jsr lcd_send_data
	lda #'r'
	jsr lcd_send_data
	lda #'l'
	jsr lcd_send_data
	lda #'d'
	jsr lcd_send_data
	lda #'.'
	jsr lcd_send_data
	
	jmp loop

lcd_send_instr:
	sta lcd_data
	lda #$0
	sta lcd_ctrl
	lda #E
	sta lcd_ctrl
	lda #$0
	sta lcd_ctrl
	rts

lcd_send_data:
	sta lcd_data
	lda #$0
	sta lcd_ctrl
	lda #(RS | E)
	sta lcd_ctrl
	lda #RS
	sta lcd_ctrl
	rts

lcd_wait:
	;
	rts

loop:
	jmp loop

	.org $fffc
	.word reset
	.word $0000
