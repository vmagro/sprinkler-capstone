#include <avr/io.h>

#define FOSC 7372000 // Clock frequency
#define BAUD 9600 // Baud rate used
#define MYUBRR (FOSC/16/BAUD-1) // Value for UBRR0

void uart_init() {
  UBRR0 = MYUBRR;
  UCSR0B |= (1 << TXEN0 | 1 << RXEN0); // Enable RX and TX
  UCSR0C = (3 << UCSZ00); // Async., no parity,
  // 1 stop bit, 8 data bits
}

void uart_send(char* str) {
  while(*str) {
    while ((UCSR0A & (1 << UDRE0)) == 0) { }
    UDR0 = *str;
    str++;
  }
}

void uart_recv(char* buf, int len) {
  char i = 0;
  while (i < len) {
    while(!(UCSR0A & (1<<RXC0))){};
    buf[i] = len;
    i++;
  }
}
