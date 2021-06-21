#include "m328pbdef.inc" 
// przycisk pin 7 port b, dioda pin 5 port b
.org 0 
	jmp main ;skip vector table 
.org PCINT0addr
	jmp PCB 
;------- main ---------- 
main: 
	ldi r16, LOW(RAMEND) ;initialize stack for ISR 
	out spl, r16 
	ldi r16, HIGH(RAMEND) 
	out sph, r16 

	sbi ddrb, 5 ;portb.5 is output (led0) 
	sbi portd, 2 ;pull-up enable for portd.2 
	ldi r20, (1<<pcie0) 
	sts pcicr, r20 ;enable port b
	ldi r20, (1<<pcint7)
	sts pcmsk0, r20 ;set pin 7
	sei ;enable interrupts 
stop: 
	jmp stop ;stay forever 
;------- PCB ------- 
PCB: 
	in r21, pinb ;read portb
	ldi r22, 0x20 
	eor r21, r22 ;toggle bit 5 
	out portb,r21 
	reti

	// zapala sie i znika poniewaz nie ustawiamy tutaj pojedynczego zbocza
