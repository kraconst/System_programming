#include <stdio.h>

unsigned int sumOfDigits(unsigned long long num) {
    unsigned int sum = 0;

    while (num > 0) {
        sum += num % 10;
        num /= 10;
    }

    return sum;
}

int main(void) {
    unsigned long long number = 3469816182ULL;

    unsigned int ans = sumOfDigits(number);
    printf("%u\n", ans);
    return 0;
}
