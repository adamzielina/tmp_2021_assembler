; 4.4
; SevenSegDisp4.asm
; zrealizować 16-bitowy programowalny licznik, którego wartość będzie wyświetlana
; na 4 wyświetlaczach 7 segmentowych

.org 0x00 ; dyrektywa org
 
ldi R16, HIGH(RAMEND)   ;incjalizacja wskaznika stosu
out SPH, R16
ldi R16, LOW(RAMEND)
out SPL, R16
 
rjmp start ;skok do programu głównego
.org 0x32 ;adres początku listy danych dyrektywy DB
prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47 ;stworzenie listy wizualizacji cyfr kodu 16
.org 0x100 ;adres początku programu
 
start:     
        ldi r16, 0x00
		ldi r17, 0xff
		out DDRD, r17           ;segmenty
		out DDRB, r17           ; wyswietlacze
		ldi Zl, low(2*prime) ;mnożenie przez dwa, celem uzyskania adresu w przestrzeni bajtowej
		ldi Zh, high(2*prime)
		ldi r18, 0x00 ; rejestry przechowujace stan licznika
		ldi r19, 0x00 ; jest ich 2, bo licznik ma być 16 bitowy

licznik:
	call wyswietl ; przywołujemy procedurę wyświetlenia
	inc r18  ; zwiększamy wartość licznika na pierwszym bicie
	brne licznik ; czekamy aż jego wartość osiągnie 0
	inc r19 ; wtedy zliczamy na drugim bicie
	brne licznik ; czekamy aż jego wartyość osiągnie 0
	jmp start ; gdy tak się stanie, procedura rozpoczyna się na nowo

                
wyswietl:
	push r16
	ldi r16, 5 ; żeby cyfry zmieniały się co 1/5 s
	petla:
		call segment1 ; wywołujemy poszczególne podprogramy odpowiadające za określony segment
		call segment2
		call segment3
		call segment4
		call delay1_20s
		dec r16 ; zmniejszamy watość r16 o jeden
		brne petla ; skok do etykiety petla jesli r16 rozne od 0
	pop r16 ; sciagniecie ze stosu r16
	ret
		       
 
delay1_20s:             ;petla opozniajaca, delay 1/20s
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

segment1:
	push r16
	push r18
	push r20
	push r21
	push r22
	mov r20, r18 ; kopiujemy zawartość licznika do r20
	ldi zl, low(2*prime)
	ldi zh, high(2*prime) ; ustawiamy wskaźnik na zerowy element tablicy
	ldi r16, 0b11111110 ; wybieramy wyświetlacz 1
						; który jest aktywny poziomem 0
	out portb, r16 ; wysłanie informacji na wyjście segmentu
	andi r20, 0x0f ; maska na zerowanie najstarszych 4 bitów (bo segment 1)
	ldi r21, 0x01 ; rejestr pomocniczy do przesunięcia się o 1 element dalej w tablicy
	add r20, r21 ; dodanie 2 rejestrów, wynik wpisujemy do r20
	petla1:
		lpm r22, z+ ; ładujemy z pamięci programu wskaźnik rejestru do r22
		dec r20
		brne petla1 ; petla1 zlicza nam wartosc r20
	com r22
	out portd, r22 ; wyswietla wynik pierwszego wyswietlacza
	pop r22
	pop r21
	pop r20
	pop r18
	pop r16
	ret

segment2:
	push r16
	push r18
	push r20
	push r21
	push r22
	mov r20, r18 ; kopiujemy zawartość licznika do r20
	ldi zl, low(2*prime)
	ldi zh, high(2*prime) ; ustawiamy wskaźnik na zerowy element tablicy
	ldi r16, 0b11111101 ; wybieramy wyświetlacz drugi
						; który jest aktywny poziomem 0
	out portb, r16 ; wysłanie informacji na wyjście segmentu
	andi r20, 0xf0 ; maska na zerowanie najmłodszych 4 bitów (bo segment 2)
	swap r20
	ldi r21, 0x01 ; rejestr pomocniczy do przesunięcia się o 1 element dalej w tablicy
	add r20, r21 ; dodanie 2 rejestrów, wynik wpisujemy do r20
	petla2:
		lpm r22, z+ ; ładujemy z pamięci programu wskaźnik rejestru do r22
		dec r20
		brne petla2 ; petla1 zlicza nam wartosc r20
	com r22
	out portd, r22 ; wyswietla wynik pierwszego wyswietlacza
	pop r22
	pop r21
	pop r20
	pop r18
	pop r16
	ret

segment3:
	push r16
	push r19
	push r20
	push r21
	push r22
	mov r20, r19 ; kopiujemy zawartość licznika do r20
	ldi zl, low(2*prime)
	ldi zh, high(2*prime) ; ustawiamy wskaźnik na zerowy element tablicy
	ldi r16, 0b11111011 ; wybieramy wyświetlacz 1
						; który jest aktywny poziomem 0
	out portb, r16 ; wysłanie informacji na wyjście segmentu
	andi r20, 0x0f ; maska na zerowanie najstarszych 4 bitów (bo segment 3)
	ldi r21, 0x01 ; rejestr pomocniczy do przesunięcia się o 1 element dalej w tablicy
	add r20, r21 ; dodanie 2 rejestrów, wynik wpisujemy do r20
	petla3:
		lpm r22, z+ ; ładujemy z pamięci programu wskaźnik rejestru do r22
		dec r20
		brne petla3 ; petla1 zlicza nam wartosc r20
	com r22
	out portd, r22 ; wyswietla wynik pierwszego wyswietlacza
	pop r22
	pop r21
	pop r20
	pop r19
	pop r16
	ret

segment4:
	push r16
	push r19
	push r20
	push r21
	push r22
	mov r20, r19 ; kopiujemy zawartość licznika do r20
	ldi zl, low(2*prime)
	ldi zh, high(2*prime) ; ustawiamy wskaźnik na zerowy element tablicy
	ldi r16, 0b11110111 ; wybieramy wyświetlacz 1
						; który jest aktywny poziomem 0
	out portb, r16 ; wysłanie informacji na wyjście segmentu
	andi r20, 0xf0 ; maska na zerowanie najmłodszych 4 bitów (bo segment 4)
	swap r20
	ldi r21, 0x01 ; rejestr pomocniczy do przesunięcia się o 1 element dalej w tablicy
	add r20, r21 ; dodanie 2 rejestrów, wynik wpisujemy do r20
	petla4:
		lpm r22, z+ ; ładujemy z pamięci programu wskaźnik rejestru do r22
		dec r20
		brne petla4 ; petla1 zlicza nam wartosc r20
	com r22
	out portd, r22 ; wyswietla wynik pierwszego wyswietlacza
	pop r22
	pop r21
	pop r20
	pop r19
	pop r16
	ret
