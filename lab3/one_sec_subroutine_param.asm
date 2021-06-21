.cseg ; inicjalizujemy pamięć programu
.org 0  ; ustawiamy licznik lokacji w pamieci programu

.dseg  ; inicjalizujemy pamięć danych
.org 0x100 ; inicjalizujemy licznik lokacji w pamieci danych
count1: .byte 1 ; rezerwujemy 1 bajt do zmiennej count1

.cseg ; przełączamy się na pamięć programu znowu
ldi R16, HIGH(RAMEND)  
out SPH, R16
ldi R16, LOW(RAMEND)   ; inicjalizacja wskaźnika stosu, odpowiednio starszy i młodszy bajt
out SPL, R16			; adresu największej możliwej lokacji w pamięci RAM  

ldi r16, 0xff
out ddrb, r16 ; ddrb jako wyjście
ldi r16, 0x00
out portb, r16 ; na wyjściu na początku ma być 0

ldi r17, 5 ; co ile sekund ma nastąpić zmiana liczby
sts count1, r17 ; zapisujemy wartość rejestru r17 pod adres zmiennej count1
				; w pamięci SRAM

start:
	call delay ; wywołujemy procedurę opoźnienia
	inc r16 ; zwiększamy wartość r16
	out portb, r16 ; wysyłamy ją na wyjście
	jmp start ; skok do etykiety start

delay:

	push r18
	push r19
	push r20
	push r21 ; wrzucamy na stos rejestry używane w podprogramie

	lds r21, count1 ; z przestrzeni pamięci danych ładujemy zawartość count1 do r21
					; dzięki temu nie modyfikujemy części programu, z którego podprocedura jest wywołana
	
	loop1:			; procedura opóżniająca z poprzedniego labu uzupełniona o pętlę wydłużającą opóźnienie
		ldi r18, 100   ; o zadaną ilość sekund
		loop2:
			ldi r19, 210
			loop3:
				ldi r20, 255
				loop4:
					dec r20
					brne loop4	;=(6*2)+1+(4*100-1)+(4*210*100-100)+(3*255*210*100-210*100) = 16128312 = ok. 16Mhz (1 sek opoznienia)
				dec r19
				brne loop3 
			dec r18
			brne loop2
		dec r21
		brne loop1	 
	
	pop r21
	pop r20
	pop r19
	pop r18 ; ściągamy zmienne ze stosu

	ret ; koniec podprogramu
