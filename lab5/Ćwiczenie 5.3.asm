; 5_3.asm

start:
ldi r20, 0xC2 ; pierwsza liczba, młodsza połówka
ldi r21, 0xFE  ; pierwsza liczba, starsza połówka
ldi r22, 0x0F   ; druga liczba, młodsza połówka
ldi r23, 0x01 ; druga liczba, starsza połówka

; The 16-bit subtraction
; Odejmujemy r21:r20 od r23:r22

sub r20, r22 ; Subtract low byte
sbc r21, r23 ; Subtract with carry, high byte

ldi r25,0
ldi r30,1
com r20
com r21
add r20,r30
adc r21,r25

rjmp start
; odejmowanie dziesiętne -318-271 = -589
; w r21 zapisano wartość 254 (0xfe) - starszy bit
; w r20 zapisano wartość 179 (0xb3) - młodszy bit
; przekształcając odpowiednio starszą i młodszą połówkę bitu na kod U2
; otrzymujemy wartość -77 - 2^9 = -589
