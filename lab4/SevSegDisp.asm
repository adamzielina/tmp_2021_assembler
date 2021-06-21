; 4.2
; primesLED.asm
; program ma w sposób ciągły wyświetlać 10 kolejnych liczb pierwszych
; opoźnienie 1 s zrealizować za pomocą podprogramu


.include"m328PBdef.inc"
.org 0x00 ; dyrektywa początku programu

ldi r16, high(RAMEND) ; inicjalizacja wskażnika stosu
out sph, r16
ldi r16, low(RAMEND)
out spl, r16

	rjmp prog_start ; skok do początku wykonywania programu

.org 0x32 ; rezerwujemy pamięć dla dyrektywy DB pod adresem 0x32
; tworzymy tablicę 10 liczb pierwszych
prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47 

.org 0x100 ; adres w pamięci, gdzie rozpoczyna się wykonywanie kodu

prog_start:
	ldi r18, 16
	ldi r16, 0x00
	ldi r17, 0xff
	ldi r19, 0x01
	com r19
	out ddrb, r17 ; port b jako wyjście
	out ddrd, r17 ; port d na wyjscie
	out portb, r19
	ldi zl, low(2*prime) ; mnożenie przez 2, celem uzyskania adresu w przestrzeni bajtowej
	ldi zh, high(2*prime) ; tutaj mamy najwyższy, wyżej najniższy adres w tej przestrzeni

start:
	lpm r16, z+ ; ładujemy bajt z pamięci programu (z) do r16
				; jednocześnie zwiększamy jego wartość o 1
	com r16
	out portd, r16 ; wysyłamy wartość na wyjście
	call podprogram ; wywołujemy procedurę opoźniającą
	dec r18 ; porównujemy r16 i r17
	brne start ; jeśli r16 jest różny od r17 to skok do etykiety start
				; jeśli równe to wykonuje się następna instrukcja
	rjmp prog_start ; czyli skok do prog_start

podprogram:

	push r18
	push r19
	push r20

    ldi r18, 100
    loop1:
        ldi r19, 210 ; =(6*2)+1+(4*100-1)+(4*210*100-100)+(3*255*210*100-210*100) = 16128312 = ok. 16Mhz
        loop2:
            ldi r20, 255
            loop3:
                dec r20
				brne loop3 ; opuszczamy tą pętlę gdy w r20 jest 0
            dec r19
            brne loop2 ; opuszczamy tą pętlę gdy w r19 jest 0.
        dec r18
        brne loop1 ; opuszczamy tą pętlę gdy w r18 jest 0
	
	pop r20
	pop r19
	pop r18
	
	ret
