.include"m328PBdef.inc"
.org 0x00 ;dyrektywa org nie jest konieczna
rjmp prog_start ;skok do programu głównego
.org 0x32 ;adres początku listy danych dyrektywy DB
prime: .DB 2, 3, 5, 7, 11, 13, 17, 19, 23 ;stworzenie listy dziewięciu liczb pierwszych
;w przestrzeni pamięci programu
.org 0x100 ;adres początku programu
prog_start: ldi r30, low(2*prime) ;mnożenie przez dwa, celem uzyskania adresu
ldi r31, high(2*prime) 

;e4 e6 f0 e0
