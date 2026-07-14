	.include "def/lcd_defines.s"
	.include "def/io_defines.s"

	.org $8000
reset:
	ldx #$ff
	txs
	stx DDRA
	stx DDRB

	; setup
	lda #%00001111 ; display ctrl
	jsr lcd_instr
	lda #%00111000 ; function set
	jsr lcd_instr
	lda #%00000001 ; clear screen
	jsr lcd_instr

; "Patrick is very cool"
stage1:
	lda #"P"
	jsr lcd_print
	lda #"a"
	jsr lcd_print
	lda #"t"
	jsr lcd_print
	lda #"r"
	jsr lcd_print
	lda #"i"
	jsr lcd_print
	lda #"c"
	jsr lcd_print
	lda #"k"
	jsr lcd_print
	lda #" "
	jsr lcd_print
	lda #"i"
	jsr lcd_print
	lda #"s"
	jsr lcd_print
	lda #" "
	jsr lcd_print
	lda #"c"
	jsr lcd_print
	lda #"o"
	jsr lcd_print
	jsr lcd_print
	lda #"l"
	jsr lcd_print
	lda #"."
	jsr lcd_print

loop:
	lda #$aa
	sta PORTA
	jsr .wait
	lda #$55
	sta PORTA
	jsr .wait
	jmp loop
.wait:
	ldy #$30
.w1:
	ldx #$ff
.wloop:
	dex
	bne .wloop
	dey
	bne .w1
	rts


	.include "def/lcd_func.s"
	
	.org $fffc
	.word reset
	.word $0000
