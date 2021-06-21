;
; projekt_1.asm
;
; Created: 15.03.2021 12:09:38
; Author : asus
;


; Replace with your application code
label:  .EQU output = 255
    ldi r16, output
	sts 0x24, r16
	;	.EQU led = 0b101010 przy sbi my ustalamy kazdy bit
start:

	sbi $5, 5
	sbi $5, 3
	sbi $5, 1
stop: rjmp start
