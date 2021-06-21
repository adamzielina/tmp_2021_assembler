;
; stoper - projekt.asm
;
; Created: 01.05.2021 21:59:17
; Author : Adam Zielina , Jakub Guza
;

#include "m328pbdef.inc"
.org 0x00 
	jmp ustawianie

.org PCINT2addr
	rjmp guzik1

.org 0x32
	heksa: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47

.DSEG

.org 0x100
	wysw: .BYTE 1		;parametry podprogramu segmenty
	num: .BYTE 1

.CSEG

ustawianie: 

	ldi r16, high(ramend)	;stos
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

	ldi r16, 0x0f			;ustawianie portów 
	out ddre, r16			;segmenty gfed port e [0-3]
	out ddrb, r16			;wyswietlacz 4321 port b [0-3]
	ldi r16, 0xf0
	out ddrd, r16			;segmenty cba. port d [4-7] , przyciski 4321 port d [0-3]

	ldi r16, (1<<pcie2)
	sts pcicr, r16
	ldi r16, (1<<pcint19)	;ustawianie przerwania na D3
	sts pcmsk2, r16

	ldi r16, 10		;warunki compare
	ldi r17,0
	ldi r19, 0
	sei

reset:
	ldi r20, 0x00			; ustawianie licznika
	ldi r21, 0x00
	ldi r22, 0x00
	ldi r23, 0x00

start:

		cli
		call display		; licznik
		sei

		cpi r17,0
		brne stop

		inc r20
		cp r20,r16
		brne start

		ldi r20, 0
		inc r21
		cp r21,r16
		brne start

		ldi r21,0
		inc r22
		cp r22,r16
		brne start

		ldi r22,0
		inc r23
		cp r23,r16
		brne start

		rjmp reset

stop: 

	cli
	call display		;bez licznika
	sei

	cpi r17,1
	brne start
rjmp stop

guzik1:

	push r16

	inc r19
	cpi r19, 1
	breq skok

	ldi r16,1
	eor r17,r16
	ldi r19,0

	skok:

	ldi r16, (1<<pcif2)
	sts pcifr, r16

	pop r16

	reti


delay:             ;petla opozniajaca, delay 1/20s
   push r16
        push r17
    ldi r16,246                 ;50*(1+1+2)*246+246*3=49938
    loop:
        ldi r17,50
        loop2:
            nop
            dec r17
            brne loop2
        dec r16
        brne loop
        pop r17
        pop r16
ret

display:			; wyświetlanie

	push r26
	push r18

	ldi r26, 3
	wait:				; czestotliwosc modyfikacji licznika
		
		call delay
		dec r26
		brne wait

	ldi r18, 1
	sts wysw,r18
	sts num,r20
	call seg
	call delay

	ldi r18, 2
	sts wysw,r18
	sts num,r21	
	call seg
	call delay

	ldi r18, 4
	sts wysw,r18
	sts num,r22
	call seg
	call delay

	ldi r18, 8
	sts wysw,r18
	sts num,r23
	call seg
	call delay

	pop r18
	pop r26

	ret


seg:
	push r20
	push r25

	ldi zl, low(2*heksa)
	ldi zh, high(2*heksa)

	lds r25, wysw
	com r25
	out portb, r25

	lds r20, num
	add zl, r20
	lpm r25, z
	com r25
	mov r20, r25
	andi r20, 0x0f
	andi r25, 0xf0
	out portd, r25
	out porte, r20

	pop r25
	pop r20

	ret



