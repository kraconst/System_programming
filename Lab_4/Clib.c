#include "CLib.h"

void print_str(const char* str) {
    size_t len = 0;
    while (str[len] != '\0') {
        len++;
    }
    write(STDOUT_FILENO, str, len);
}

void print_int(int num) {
    char buf[32];
    int pos = 0;
    int is_negative = 0;

    if (num == 0) {
        write(STDOUT_FILENO, "0", 1);
        return;
    }

    if (num < 0) {
        is_negative = 1;
        num = -num;
    }

    while (num > 0) {
        buf[pos++] = '0' + (num % 10);
        num /= 10;
    }

    if (is_negative) {
        buf[pos++] = '-';
    }

    for (int i = 0; i < pos / 2; i++) {
        char temp = buf[i];
        buf[i] = buf[pos - 1 - i];
        buf[pos - 1 - i] = temp;
    }

    write(STDOUT_FILENO, buf, pos);
}

int parse_str(const char* buf, ssize_t bytes_read) {
    int val = 0;
    ssize_t i = 0;

    while (i < bytes_read && (buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == '\r')) {
        i++;
    }

    if (i >= bytes_read || buf[i] < '0' || buf[i] > '9') {
        return -1;
    }

    while (i < bytes_read && buf[i] >= '0' && buf[i] <= '9') {
        val = val * 10 + (buf[i] - '0');
        i++;
    }

    return val;
}
