;
; General I/O definitions for 6502 breadboard computer.
;

; VIA PB0-7 lines
PORTB = $6000
; VIA PA0-7 lines
PORTA = $6001
; [D]ata [D]irection [R]egister for PORT[B] (RS = 2, 0010)
DDRB = $6002
; [D]ata [D]irection [R]egister for PORT[A] (RS = 3, 0011)
DDRA = $6003
