#ifndef SERIAL_H
#define SERIAL_H

void uart_init();
void uart_send(char* str);
char rx_char();
void uart_recv(char* buf, int len);

#endif
