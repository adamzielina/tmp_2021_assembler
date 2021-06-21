// JG, AZ
; 2/3
ldi r16, 0xff
out ddrb, r16 ; rezystor podciągający

ldi r16, 0x00 ; będziemy liczyć od 5 

ldi r20, high(ramend)
out sph, r20
ldi r20, low(ramend)
out spl, r20

loop:
    out portb, r16 ; w każdym obiegu pętli będziemy wysyłać na wyjście zawartość r16
    inc r16 ; zwiększamy wartość w r16

	call podprogram
rjmp loop
; brne wykonywane jest w 2 taktach
    ;ponizej petle opozniajace
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
