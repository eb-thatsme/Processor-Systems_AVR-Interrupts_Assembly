.ORG 0x0;location for reset 
JMP MAIN
.ORG 0x24;location for Timer0 overflow
JMP T0_OV_ISR
;----main program for initialization
.ORG 0x100
MAIN:LDI R20,HIGH(RAMEND)
OUT SPH,R20
LDI R20,LOW(RAMEND)
OUT SPL,R20
LDI R20,$FF
OUT DDRA,R20;output
LDI R20,0
OUT DDRB, R20  //PortB as input
LDI R20,0xFF
OUT PORTB, r20 //For pullup resistors
OUT DDRD, R20 //Set as output
LDI R20,(1<<TOIE0)
;OUT TIMSK0,R20; doesn’t work
sts 0x006E,R20; does work
SEI
LDI R20,-41  ;value for 3kHz
OUT TCNT0,R20
LDI R20,0x03
OUT TCCR0B,R20
HERE: IN R20,PINB
OUT PORTA,R20   
JMP HERE
;--------ISR for Timer 0
T0_OV_ISR:
IN R16,PORTD
LDI R17,0xFF
EOR R16,R17
OUT PORTD,R16
LDI R20,-41  ;value for 3k Hz
OUT TCNT0,R20; load for next round
RETI
