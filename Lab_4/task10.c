#include "CLib.h"
#include <string.h>

int autentificate(const char* input, const char* password) {
    if (strcmp(input, password) == 0) {
        print_str("Welcome\n");
        return 0;
    } else {
        print_str("wrong password, try again\n");
        return -1;
    }
}

int main(void) {
    char input_buf[64];
    const char* password = "ydlI840HsUkfns31";

    int i = 0;
    int res = -1;
    while (i < 5 && res) {
        ssize_t bytes_read = read(STDIN_FILENO, input_buf, sizeof(input_buf)-1);

        if (bytes_read <= 0) {
            print_str("Error while reading\n");
            return 1;
        }

        input_buf[bytes_read - 1] = '\0';
        res = autentificate(input_buf, password);
        i++;
    }
    if (res) {
        print_str("access denied\n");
    }

    return 0;
}
