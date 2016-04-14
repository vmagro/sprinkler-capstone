#ifndef SERIAL_H
#define SERIAL_H

void uart_init();
void uart_send(char* str);
char message_available();
void last_message(char* newBuf);
void mark_as_read();

#endif
