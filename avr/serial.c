#include <avr/io.h>
#include <avr/interrupt.h>
#include <string.h>

#define FOSC 7372000 // Clock frequency
#define BAUD 9600 // Baud rate used
#define MYUBRR (FOSC/16/BAUD-1) // Value for UBRR0

char buf[3];
int bufIndex = 0;

void uart_init() {
  DDRD &= ~(1 << DD0); //RX input
  DDRD |= (1 << DD1); //TX output
  UBRR0 = MYUBRR;
  UCSR0B |= (1 << TXEN0 | 1 << RXEN0 | 1 << RXCIE0); // Enable RX and TX and RX Interrupts
  UCSR0C = (3 << UCSZ00); // Async., no parity,
  // 1 stop bit, 8 data bits

  sei();
}

void uart_send(char* str) {
  while(*str) {
    while ((UCSR0A & (1 << UDRE0)) == 0) { }
    UDR0 = *str;
    str++;
  }
}

void last_message(char* newBuf) {
  memcpy(newBuf, buf, sizeof(char) * 3);
}

void mark_as_read() {
  bufIndex = 0;
}

char message_available() {
  return bufIndex == 3;
}

ISR(USART_RX_vect) {
  char in = UDR0;
  //start byte
  if (in == 0x42) {
    bufIndex = 0;
  }
  buf[bufIndex] = in;
  bufIndex++;
}
