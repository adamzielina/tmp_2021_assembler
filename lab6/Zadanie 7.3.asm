.include"m328pbdef.inc"
//klawiatura c diody b
.cseg
.org 0
	jmp start
.org PCINT1addr
	rjmp keypad_ISR ;Keypad External Interrupt Request


;-----------------------------------------------------------------------------------
;Initialization
start:
; Set Stack Pointer to top of RAM
ldi r16, high(ramend)
out SPH, r16
ldi r16, low(ramend)
out SPL, r16
;SET UP 6 LEDS
;Set up port B as output for LED controls
ldi r16, 0x3F
out ddrb, r16
;SET UP KEYPAD, 2 rows x 4 cols
;Set rows as inputs and columns as outputs
ldi r20, 0x0f
out ddrc, r20
;Set rows to high (pull ups) and columns to low
ldi r20, 0x30
out portc, r20
;Select rows as interrupt triggers
ldi r20, (1<<pcint12)|(1<<pcint13)
sts pcmsk1, r20
;Enable pcint1
ldi r20, (1<<pcie1)
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
ldi r20, 0x30
out ddrc, r20
;Set columns to high (pull ups) and rows to low
ldi r20, 0x0f
out portc, r20
;Read Port C. Columns code in low nibble
in r16, pinc
;Store columns code to r18 on low nibble
mov r18, r16
andi r18, 0x0f
;Set rows as inputs and columns as outputs
ldi r20, 0x0f
out ddrc, r20
;Set rows to high (pull ups) and columns to low
ldi r20, 0x30
out portc, r20
;Read Port C. Rows code in high nibble
in r16, pinc
;Merge with previous read
andi r16, 0x30
add r18, r16
reti



;-----------------------------------------------------------------------------------
;display value from r18 on leds
led_display:
out portb,r18
ret
