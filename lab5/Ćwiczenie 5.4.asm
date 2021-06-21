.CSEG 
.ORG 0 
	ldi R16, HIGH(RAMEND)    
	out SPH, R16    
	ldi R16, LOW(RAMEND)    ;stos
	out SPL, R16    

	rjmp prog_start     
    .org 0x32  
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47, 0x47 	   ;lista
 .DSEG 
.ORG 0x100 
	var1: .BYTE 1  
	var2: .BYTE 1	;parametry do podprogramu
	var3: .BYTE 1 
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddrb, r16    
	out ddrd, r16
	out ddrc, r16 

	;-318
	ldi r16, 0xC2 ;mlodsze
	ldi r17, 0xFE	;starsze
	
	;271
	subi r16,0x0F
	sbci r17,0x01		;-318 - 271 = -589
    brvs przepelnienie
	brpl znak
znak:
		ldi r31,0
		ldi r30,1
		com r16
		com r17
		add r16, r30
		adc r17, r31	
	brvs obie
        ldi r22, 0b100000
        out portc, r22
		rjmp start
przepelnienie:
	brpl obie
        ldi r23, 0b000100
        out portc, r23
		rjmp start
obie:
       ldi r23, 0b100100
        out portc, r23
	
start:
	call wyswietlanie 
	rjmp prog_start 
wyswietlanie: 
	ldi r18, 2 ; r18 sluzy aby cyfry zmienialy sie co 1/5s 
	petla: 
		call wait_sec 
		dec r18 
	brne petla 
								 ;wysw1 
		ldi r19,0x01 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1  
			call wait_sec 
								 ;wysw2
		ldi r19,0x02 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
								;wysw3 
		ldi r19,0x04 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
								;wysw4 
		ldi r19,0x08 
		ldi r20,0 
		sts var1, r19 
		sts var2, r20	
		sts var3, r17
		call seg1 
			call wait_sec 
	ret 

	;delay
wait_sec:   
	push r16   
	push r17   
	push r18   
	push r19   
	ldi r16,1  
		ldi r17,5
		opoznienie_1:   
		ldi r18, 25
			opoznienie_2:   
			ldi r19, 100
				opoznienie_3:   
				dec r19   
				brne opoznienie_3	   
			dec r18   
			brne opoznienie_2   
		dec r17  
		brne opoznienie_1   
	dec r16     
	brne wait_sec   
pop r19  
pop r18   
pop r17   
pop r16   

Ret  
		;podprogram wyswietlacze
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) ;mnożenie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
	ldi zh, high(2*prime)    

	lds r16, var1	;wyswietlacz
	com r16                     
	out portb, r16  

	ldi r16, 0	;segment
	lds r18, var2 
	cp r18, r16 
	lds r17, var3
	brne noswap 
	swap r17  
noswap: 
	andi r17, 0x0f  
	add zl, r17  
	adc zh, r16 
	lpm r16, z  
	com r16  
	out portd, r16 

	pop r18 
	pop r17  
	pop r16  

	ret  
stop: rjmp stop
