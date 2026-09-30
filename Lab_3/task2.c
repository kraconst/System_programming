#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("two arguments needed\n");
        return 1;
    }

    unsigned int b = atoi(argv[1]);
    unsigned int c = atoi(argv[2]);
    unsigned int result = (((c + b) * b) - c);

    printf("%u\n", result);

    return 0;
}
