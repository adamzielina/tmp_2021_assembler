#include "m328pbdef.inc" 
// dioda led port b pin 5 , klawiatura pin 2 port d 
.org 0 
	jmp main ;skip vector table 
.org INT0addr
	jmp int0_isr 
;------- main ---------- 
main: 
	ldi r16, LOW(RAMEND) ;initialize stack for ISR 
	out spl, r16 
	ldi r16, HIGH(RAMEND) 
	out sph, r16 

	sbi ddrb, 5 ;portb.5 is output (led0) 
	sbi portd, 2 ;pull-up enable for portd.2 
	ldi r20, (1<<int0) 
	out eimsk, r20 ;enable int0 
	ldi r20, (1<<isc01)
	sts eicra, r20 ;set int0 active on falling edge 
	sei ;enable interrupts 
stop: 
	jmp stop ;stay forever 
;------- int0 ISR ------- 
int0_isr: 
	in r21, pinb ;read portb
	ldi r22, 0x20 
	eor r21, r22 ;toggle bit 5 
	out portb,r21 
	reti
