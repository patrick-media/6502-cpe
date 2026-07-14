;
; LCD general definitions for 6502 breadboard computer.
;

; LCD data port (PORTB)
lcd_data = $6000
; LCD control line port (PORTA)
lcd_ctrl = $6001

; Register Select bit on LCD control lines (PORTA)
RS = %00000001
; Enable bit on LCD control lines (PORTA)
E  = %00000010
; Read/Write bit on LCD control lines (PORTA)
RW = %00000100
