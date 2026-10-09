#include "CLib.h"

int is_non_decreasing(int n) {
    if (n < 0) {
        n = -n;
    }

    int next_digit = 9;

    while (n > 0) {
        int current_digit = n % 10;

        if (current_digit > next_digit) {
            return 0;
        }

        next_digit = current_digit;
        n /= 10;
    }

    return 1;
}

int main(void) {
    char input_buf[64];

    ssize_t bytes_read = read(STDIN_FILENO, input_buf, sizeof(input_buf));

    if (bytes_read <= 0) {
        print_str("Error while reading\n");
        return 1;
    }

    int n = parse_str(input_buf, bytes_read);

    int ans = is_non_decreasing(n);

    if (ans) {
        print_str("yes\n");
    } else {
        print_str("no\n");
    }

    return 0;
}
