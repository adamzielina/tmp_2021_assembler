; 2/2
; button_2_led.asm
; program testuje stan przycisku na porcie c i włącza lub wyłącza diodę na porcie b
 
.include "m328PBdef.inc"
ldi r16, 0xff
out portb, r16 ; konfigurujemy rezystor podciągający 
ldi r16, 0xff
out ddrb, r16 ; ustawiamy port b jako wyjscie
ldi r16, 0x00
out portb, r16 ; na początku chcemy żeby na wyjściu było 0

ldi r16, 0xff
out portc, r16 ; konfigurujemy rezystor podciągający
ldi r16, 0x00
out ddrc, r16 ; ustawiamy port c jako wejscie
in r16, pinc ; przesyłamy dane z wejścia (przycisku) do r16

start:
    sbis pinc, 0 ; jeśli bit na przycisku jest ustawiony, to pomijamy instrukcję zerowania bitu diody
    cbi portb, 0 ; ta instrukcja zeruje bit na diodzie

    sbic pinc, 0 ; jeśli bit na przycisku jest wyzerowany, to pomijamy instrukcję ustawiania bitu diody
    sbi portb, 0 ; ta instrukcja ustawia bit na diodzie
stop: rjmp start ; skok do startu, bo program będzie pracował niejako w kółko
