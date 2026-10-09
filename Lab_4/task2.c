#include "CLib.h"

int main(void) {
    char input_buf[64];

    ssize_t bytes_read = read(STDIN_FILENO, input_buf, sizeof(input_buf));

    if (bytes_read <= 0) {
        print_str("Error while reading\n");
        return 1;
    }

    int n = parse_str(input_buf, bytes_read);

    if (n <= 0) {
        print_str("Error: number must be a positive integer\n");
        return 1;
    }

    int sum = 0;

    for (int x = 1; x <= n; x++) {
        int term = x * x;
        if (x % 2 != 0) {
            sum += term;
        } else {
            sum -= term;
        }
    }

    print_int(sum);
    print_str("\n");

    return 0;
}
