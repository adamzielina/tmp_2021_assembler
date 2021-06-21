; 2.4
; mod_cnt_jmp.asm
; zrealizować skok warunkowy
; należy zastosować odpowiednią kombinacje skoków warunkowego krótkiego i 
; bezwarunkowego długiego
; zmodyfikowany program z poprzedniego ćwiczenia

ldi r16, 0xff
out ddrb, r16 ; konfigurujemy rezystor podciągający

ldi r16, 5 ; będziemy liczyć od 5 
ldi r17, 15 ; do 15, stąd te wartości dajemy do rejestru
ldi r21, 0 ; do porownywania liczb

loop:
    out portb, r16 ; w każdym obiegu pętli będziemy wysyłać na wyjście zawartość r16
    inc r16 ; zwiększamy wartość w r16


    ldi r18, 200
    loop1:
        ldi r19, 100
        loop2:
            ldi r20, 200
            loop3:
                dec r20
                cpse r20, r21 ; porównuje rejestry, gdy są równe to pomija kolejną instrukcje
                jmp loop3 ; gdy r18==r20 to nie robimy skoku do r3, tylko przechodzimy do nastepnej linijki
            dec r19
            cpse r19, r21
            jmp loop2; j.w.
        dec r18
        cpse r18, r21
        jmp loop1 ; j. w.
    cpse r16, r17
    jmp loop
