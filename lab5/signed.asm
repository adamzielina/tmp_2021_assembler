
start:

	ldi r20, 0x60 ;0110 0000 (+96)
	ldi r21, 0x46 ;0100 0110 (+70)
	add r20, r21 ;(+96) +(+70) = 1010 0110
	;flagi V i N

	ldi r20, 70
	ldi r21, 96
	add r20, r21
	; flagi V i N ustawiono status 1
	; bin: 0b10100110 unsigned: 166  signed: -90

	ldi r20, -70
	ldi r21, -96 
	add r20, r21 
	;flagi S, V, C
	;bin: 0b01011010 unsigned: 90  signed: 90

	ldi r20, -126
	ldi r21, 30
	add r20, r21 
	;flagi H, S, N
	;bin: 0b10100000 unsigned: 160  signed: -96

	ldi r20, 126
	ldi r21, -6
	add r20, r21 
	;flagi H, C
	;bin: 0b01111000 unsigned: 120  signed: 120

	ldi r20, -2
	ldi r21, -5 
	add r20, r21 
	;flagi H, S, N, C
	;bin: 0b11111001 unsigned:249  signed:-7
	rjmp start
