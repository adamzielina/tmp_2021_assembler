.include"m328pbdef.inc"
.cseg
.org 0
	jmp start
.org PCINT3addr
	rjmp keypad_ISR ;Keypad External Interrupt Request
.org 0x50  
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47, 0x47 	   ;lista
.ORG 0x100 
;-----------------------------------------------------------------------------------
;Initialization
start:
; Set Stack Pointer to top of RAM
ldi r16, high(ramend)
out SPH, r16
ldi r16, low(ramend)
out SPL, r16
;SET UP 7seg
;Set up port B as output for LED controls
ldi r16, 0xff
out ddrd, r16
ldi r16, 0x03
out ddrc, r16
;SET UP KEYPAD, 2 rows x 4 cols
;Set rows as inputs and columns as outputs
ldi r20, 0xf0
out ddre, r20
ldi r20, 0x0f
out ddrb, r20
;Set rows to high (pull ups) and columns to low
ldi r20, 0x0f
out porte, r20
ldi r20, 0xf0
out portb, r20
;Select rows as interrupt triggers
ldi r20, (1<<pcint24)|(1<<pcint25)|(1<<pcint26)|(1<<pcint27)
sts pcmsk3, r20
;Enable pcint1
ldi r20, (1<<pcie3)
sts pcicr, r20
;Reset register for output
ldi r18, 0x00
;Global Enable Interrupt
Sei


;-----------------------------------------------------------------------------------
;Set up infinite loop
loop:
call led_display
rjmp loop


;-----------------------------------------------------------------------------------
;Keypad Interrupt Service Routine
keypad_ISR:
;Set rows as outputs and columns as inputs
ldi r20, 0x0f
out ddre, r20
ldi r20, 0xf0
out ddrb, r20
;Set columns to high (pull ups) and rows to low
ldi r20, 0xf0
out porte, r20
ldi r20, 0x0f
out portb, r20
;Read Port C. Columns code in low nibble
in r16, pinb
;Store columns code to r18 on low nibble
mov r18, r16
andi r18, 0x0f
;Set rows as inputs and columns as outputs
ldi r20, 0xf0
out ddre, r20
ldi r20, 0x0f
out ddrb, r20
;Set rows to high (pull ups) and columns to low
ldi r20, 0x0f
out porte, r20
ldi r20, 0xf0
out portb, r20
;Read Port C. Rows code in high nibble
in r16, pine
;Merge with previous read
swap r16
andi r16, 0xf0
add r18, r16
reti



;-----------------------------------------------------------------------------------
;display value from r18 on leds
led_display:
ldi zl, low(2*prime) ;mnożenie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
ldi zh, high(2*prime)
ldi r30, 0x01
com r30
out portc, r30

mov r20, r18
mov r21, r18
ldi r22, 0

andi r21, 0x0f
add zl, r21
adc zh, r22
lpm r16, z
com r16
out portd, r16

ldi zl, low(2*prime) ;mnożenie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
ldi zh, high(2*prime)
ldi r30, 0x02
com r30
out portc, r30

swap r20
andi r20, 0x0f
add zl, r20
adc zh, r22
lpm r16, z
com r16
out portd, r16
ret
