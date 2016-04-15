#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "serial.h"

#define DEBUG 1

//Zones on PC1-4
#define ZONE_DDR DDRC
#define ZONE_PORT PORTC
#define ZONE_START PC1

//Moisture link on PD5
#define MOIST_DDR DDRD
#define MOIST_PORT PORTD
#define MOIST_PINR PIND
#define MOIST_PIN PD5

void decode_zone_msg(char* msg, char* zone, char* on) {
  //ignore start byte, assuming it's already present due to the check in serial.c
  *zone = msg[1];
  *on = msg[2] == 0x01;
  return;
}

char desiredZones = 0x00;

void init_timer1(unsigned short m) {
  TCCR1B |= (1 << WGM12);
  TIMSK1 |= (1 << OCIE1A);
  OCR1A = m;
  TCCR1B |= (1 << CS12);
}

int main(void) {
  uart_init();
  init_timer1(15625);

  sei();

  DDRC |= (1 << PC0);
  ZONE_DDR |= (0b1111 << ZONE_START);
  MOIST_DDR &= ~(1<<MOIST_PIN); //PORTD pin 5 as input
  MOIST_PORT |= (1<<MOIST_PIN); //activate pull-ups in PORTD pin5?

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
      desiredZones |= (1 << (zone + ZONE_START));
    } else {
      ZONE_PORT &= ~(1 << (zone + ZONE_START));
      desiredZones &= ~(1 << (zone + ZONE_START));
    }

  }

  return 0;
}

ISR(TIMER1_COMPA_vect) {
#if DEBUG
  /* if(MOIST_PINR & (1 << MOIST_PIN)) { */
  /*   uart_send("T1\n"); */
  /* } else { */
  /*   uart_send("T0\n"); */
  /* } */
#endif
  if(MOIST_PINR & (1 << MOIST_PIN)) {
    PORTC |= (1 << PC0);
    ZONE_PORT &= ~(0b1111 << ZONE_START);
  } else {
    PORTC &= ~(1 << PC0);
    ZONE_PORT |= (desiredZones);
  }
}
