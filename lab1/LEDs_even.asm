;
; projekt_1.asm
;
; Created: 15.03.2021 12:09:38
; Author : asus
;


; Replace with your application code
label:  .EQU output = 255
		.EQU led = 0b101010
start:
    ldi r16, output
	ldi r17, led
	sts 0x24, r16
	sts 0x25, r17
stop: rjmp stop
