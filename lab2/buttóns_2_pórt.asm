; 2/1
; buttons_2_port.asm
; program ma czytać z portu c (przyciski) i wysyłać do portu b (ledy)
ust:
    ldi r16, $ff 
    out ddrb, r16 ;ustawianie portu b jako wyjście 
    out portc, r16 ; podciągnięcie rezystora podciągającego
    ldi r16, $00 
    out ddrc, r16 ; ustawienie portu c jako wejścia

start:

    in r16, pinc ; pobranie sygnału z przycisku do rejestru r16
    out portb, r16 ; przekzanie sygnału z przycisku r16 do diod

    rjmp start
