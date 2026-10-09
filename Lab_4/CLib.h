#ifndef CLIB_H
#define CLIB_H

#include <unistd.h> // Необходимо для типа ssize_t

// Вывод null-терминированной строки в STDOUT через системный вызов write
void print_str(const char *str);

// Вывод числа типа int в STDOUT через системный вызов write
void print_int(int num);

// Преобразование строки в число (atoi) из буфера
int parse_str(const char *buf, ssize_t bytes_read);

#endif // CLIB_H
