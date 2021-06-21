// 4.4

.org 0

ldi R16, HIGH(RAMEND)
out SPH, R16
ldi R16, LOW(RAMEND)
out SPL, R16

;inicjalizacja portu a i d jako wyjsc
ldi r17, 0xFF
out ddrd, r17
out ddrb, r17
jmp start1

;inicjalizacja tablicy przechowujacej kolejno liczby 0 1 2... F na wyswietlacz 7-segmentowy
.org 0x32
prime: .DB ~0x7e, ~0x30, ~0x6d, ~0x79, ~0x33, ~0x5b, ~0x5f, ~0x70, ~0x7F, ~0x7B, ~0x77, ~0x1f, ~0x4e, ~0x3d, ~0x4f, ~0x47, ~0x47

.org 0x80

start1:
;inicjalizacja wskaznika (rejestru z) na tablice
ldi zl, low(2*prime);
ldi zh, high(2*prime);

;r20 i r21 sluza do przechowywania aktualnego polozenia licznika, przy czym r20 to mniejsza liczba
ldi r20, 0x00 
ldi r21, 0x00

;nasz licznik
l1: 
	call display
	inc r20
	brne l1
	inc r21
	brne l1
	jmp start

wait:	;ustawione na 1/20s
	ldi R16, 2
	loop1:
		ldi R17, 200
		loop2: 
			ldi R18, 10
			loop3:
				dec R18
				brne loop3
			dec R17
			brne loop2
		dec R16
		brne loop1
	ret


display:
	ldi r26,5 ; r26 sluzy aby cyfry zmienialy sie co 1/4s
	loop0:
		call seg1 
		call seg2
		call seg3
		call seg4
		call wait
		dec r26
		brne loop0
	ret

seg1:
	;ustawiamy wskaznik na zerowy element tablicy, pierwszy znak znajduje sie pod pierwszym elementem talbicy
	ldi zl, low(2*prime) 
	ldi zh, high(2*prime)
	;wybieramy wyswietlacz pierwszy pod portbm pc0
	ldi r25,0x01 
	com r25
	out portb, r25
	
	mov r23, r20 ;kopiujemy rejestr r20 (licznik) aby nie zgubic jego wartosci - mozna zrzucic na stos rownie dobrze
	andi r23, 0x0f ;wybieramy tylko 4 najnizsze bity 
	ldi r27, 0x01 ;te dwie komendy wlasnie maja nam pomoc przesunac sie o jeden element dalej w tablicy tzn. jesli r20 bylo 0 to przesuwamy sie
	add r23, r27 ;na pierwszy element tablicy czyli 0x7e, jesli r20 bylo 1 to dodajemy 1 i przesuwamy sie na drugi element tablicy czyli 0x30
	l2:
		lpm r24, z+ 
		dec r23
		brne l2
	out portd, r24 ;wyswietlamy dany element tablicy
	ret

seg2:
	ldi zl, low(2*prime);
	ldi zh, high(2*prime);
	
	ldi r25,0x02
	com r25
	out portb, r25
	
	mov r23, r20
	andi r23, 0xf0
	swap r23
	ldi r27, 0x01
	add r23, r27
	l3:
		lpm r24, z+
		dec r23
		brne l3
	out portd, r24
	ret
	
seg3:
	ldi zl, low(2*prime);
	ldi zh, high(2*prime);
	
	ldi r25,0x04
	com r25
	out portb, r25
	
	mov r23, r21
	andi r23, 0x0f
	ldi r27, 0x01
	add r23, r27
	l5:
		lpm r24, z+
		dec r23
		brne l5
	out portd, r24
	ret

seg4:
	ldi zl, low(2*prime);
	ldi zh, high(2*prime);
	
	ldi r25,0x08
	com r25
	out portb, r25
	
	mov r23, r21
	andi r23, 0xf0
	swap r23
	ldi r27, 0x01
	add r23, r27
	l7:
		lpm r24, z+
		dec r23
		brne l7
		out portd, r24
	ret
start:
	jmp start
