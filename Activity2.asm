.ORG	0x0	;location for reset 
	JMP	MAIN
.ORG	0x1C	;location for Timer1 compare match B
	JMP	T1_CM_ISR

;------main program for initialization and keeping CPU busy
MAIN:	LDI	R20,HIGH(RAMEND)
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20	;set up stack
	LDI R20, $ff
	OUT DDRA, r20 //set as OUTPUT
	OUT DDRD, r20 //set as OUTPUT
	OUT PORTB, r20 
	LDI r20, 0
	OUT DDRB, r20 ///set as INPUT

	LDI	R20,HIGH(7812)	;the high byte of value for 1Khz 
	STS	OCR1AH,R20		;Temp =(high byte of 7812)
	LDI	R20,LOW(7812)	;the low byte of value for 1Khz 
	STS	OCR1AL,R20		;OCR1A = 7812
	LDI	R20,0x00
	STS	TCCR1A,R20		
	LDI	R20,0xD		// = 0b00001101 (CTC mode, 1024 prescaler)
	STS	TCCR1B,R20		;prescaler 1:1024, CTC mode
	LDI	R20,(1<<OCIE1A)
	STS	TIMSK1,R20	;enable Timer1 compare match interrupt
	SEI			;set I (enable interrupts globally)

;--------------- Infinite loop
HERE:	IN	R20,PINB	;read from PORTB
	OUT 	PORTA,R20	;PORTA = R20
	JMP	HERE		;keeping CPU busy waiting for interrupt

;---ISR for Timer1 (It comes here after elapse of 1 second time)
T1_CM_ISR:
	IN	R16,PORTD	
	LDI	R17,$ff ; for toggling portD
	EOR	R16,R17
	OUT PORTD,R16	;toggle portD
	RETI			;return from interrupt
