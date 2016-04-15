#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "serial.h"

#define DEBUG 1

//Zones on PC1-4
#define ZONE_DDR DDRC
#define ZONE_PORT PORTC
#define ZONE_START PC1
#define MOIST_DDR DDRD
#define MOIST_PORT PORTD

void decode_zone_msg(char* msg, char* zone, char* on) {
  //ignore start byte, assuming it's already present due to the check in serial.c
  *zone = msg[1];
  *on = msg[2] == 0x01;
  return;
}

int main(void) {
  uart_init();
  DDRC |= (1 << PC0);
  ZONE_DDR |= (0b1111 << ZONE_START);
  MOIST_DDR &= ~(1<<PD5); //PORTD pin 5 as input
  MOIST_PORT |= (1<<PD5); //activate pull-ups in PORTD pin5?
  
  // cycle through turning on all zones on boot
  for (int zone=0; zone < 4; zone++) {
      ZONE_PORT |= (1 << (ZONE_START + zone));
      _delay_ms(200);
      ZONE_PORT &= ~(1 << (ZONE_START + zone));
  }

  char buf[3];

  while(1) {
#if DEBUG
    uart_send("Waiting for data\r\n");
#endif

    //wait for a message to be available
    while (!message_available()) {}
    char zone, on;
    last_message(buf);
    mark_as_read();
    decode_zone_msg(buf, &zone, &on);

#if DEBUG
    char str[16];
    if (on) {
      snprintf(str, 16, "Turning on %d\n", zone);
    } else {
      snprintf(str, 16, "Turning off %d\n", zone);
    }
    uart_send(str);
#endif

    if (on) {
      ZONE_PORT |= (1 << (zone + ZONE_START));
    } else {
      ZONE_PORT &= ~(1 << (zone + ZONE_START));
    }


    /* decode_zone_msg(buf, &zone, &on); */
    /* if (zone != -1) { */
    /*   // if message has a valid zone */
    /*   if (on) { */
    /*     ZONE_PORT |= (1 << (ZONE_START + zone)); */
    /*   } else { */
    /*     ZONE_PORT &= ~(1 << (ZONE_START + zone)); */
    /*   } */
    /* } */
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
