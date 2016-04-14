#include <avr/io.h>
#include <util/delay.h>
#include "serial.h"

//Zones on PC1-4
#define ZONE_DDR DDRC
#define ZONE_PORT PORTC
#define ZONE_START PC1

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

  // cycle through turning on all zones on boot
  for (int zone=0; zone < 4; zone++) {
      ZONE_PORT |= (1 << (ZONE_START + zone));
      _delay_ms(200);
      ZONE_PORT &= ~(1 << (ZONE_START + zone));
  }

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

