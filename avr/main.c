#include <avr/io.h>
#include <util/delay.h>
#include "serial.h"

int main(void) {

  while(1) {
    uart_send("Hello world");
    _delay_ms(500);
  }

  return 0;
}

