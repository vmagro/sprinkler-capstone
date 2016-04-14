#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "serial.h"

//Zones on PC1-4
#define ZONE_DDR DDRC
#define ZONE_PORT PORTC
#define ZONE_START PC1
#define MOIST_DDR DDRD
#define MOIST_PORT PORTD

void decode_zone_msg(char* msg, char* zone, char* on) {
  //check to make sure start byte is present
  if (msg[0] != 0xff) {
    *zone = -1;
    *on = -1;
    return;
  }
  *zone = msg[0];
  *on = msg[1] == 0x01;
  return;
}

int main(void) {
  uart_init();
  ZONE_DDR |= (0b1111 << ZONE_START);
  MOIST_DDR &= ~(1<<PD5); //PORTD pin 5 as input
  MOIST_PORT |= (1<<PD5); //activate pull-ups in PORTD pin5?
  
  // cycle through turning on all zones on boot
  for (int zone=0; zone < 4; zone++) {
      ZONE_PORT |= (1 << (ZONE_START + zone));
      _delay_ms(200);
      ZONE_PORT &= ~(1 << (ZONE_START + zone));
  }
 
 //interrupt timer
 OCR1A = 0x8CA0; //count up to 36000
 TCCR1B |= (1<<WGM12); // mode 4, CTC on OCR1A
 TIMSK1 |= (1<<OCIE1A); //set interrupt on compare match
 TCCR1B |= (1<<CS12)|(1<<CS10); //set prescaler to 1024 and start the timer
 sei(); //enable interrupts
 
  char buf[3];

  while(1) {
    uart_send("Hello\r\n");
    /* uart_recv(buf, 3); */
    /* char zone, on; */
    /* decode_zone_msg(buf, &zone, &on); */
    /* if (zone != -1) { */
    /*   // if message has a valid zone */
    /*   if (on) { */
    /*     ZONE_PORT |= (1 << (ZONE_START + zone)); */
    /*   } else { */
    /*     ZONE_PORT &= ~(1 << (ZONE_START + zone)); */
    /*   } */
    /* } */
    /* _delay_ms(500); */
  }

  return 0;
}

ISR (TIMER1_COMPA_vect){
  if(PIND & (1<<PD5)){
    ZONE_PORT &= ~(1<<PC1);
    ZONE_PORT &= ~(1<<PC2);
    ZONE_PORT &= ~(1<<PC3);
    ZONE_PORT &= ~(1<<PC4);
  }
}
