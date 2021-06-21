// JG, AZ
; 2/3
ldi r16, 0xff
out ddrb, r16 ; rezystor podciągający

ldi r16, 5 ; będziemy liczyć od 5 
ldi r17, 15 ; do 15,do rejestru

loop:
    out portb, r16 ; w każdym obiegu pętli będziemy wysyłać na wyjście zawartość r16
    inc r16 ; zwiększamy wartość w r16

; brne wykonywane jest w 2 taktach
    ;ponizej petle opozniajace
    ldi r18, 200
    loop1:
        ldi r19, 100
        loop2:
            ldi r20, 200
            loop3:
                dec r20
            brne loop3 ; opuszczamy tą pętlę gdy w r20 jest 0
            dec r19
            brne loop2 ; opuszczamy tą pętlę gdy w r19 jest 0.
        dec r18
        brne loop1 ; opuszczamy tą pętlę gdy w r18 jest 0
    cp r16, r17
    brne loop
