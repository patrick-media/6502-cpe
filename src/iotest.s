PORTA = $6001
PORTB = $6000

DDRB = $6002
DDRA = $6003

	.org $8000

reset:
	ldx #$ff
	txs
	lda #$ff
	sta DDRA
loop:
	ldx #$aa
	stx PORTA
	jsr wait
	ldx #$55
	stx PORTA
	jsr wait
	jmp loop

wait:
	ldy #$50
.loop1:
	lda #$ff
.loop2:
	dec
	bne .loop2
	dey
	bne .loop1
	rts

	.org $fffc
	.word reset
	.word $0000
