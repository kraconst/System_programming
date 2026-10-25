#include <stdio.h>
#include <stdlib.h> // для atol

unsigned char* create_array(size_t size); // rdi - размер, rax - адрес массива
void generate_elems(void);
long sum_array(void); // rax - сумма
long count_even(void); // rax - количество четных
void reverse_array(void);
void free_memory(void);

void print_array(unsigned char *a, size_t n)
{
    for (int i = 0; i < n; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        printf("error while reading size\n");
        return 1;
    }
    long n = atol(argv[1]);
    if (n <= 0 || n > 100) {
        printf("size must be from 1 to 100\n");
        return 1;
    }

    printf("size = %ld\n", n); // буфер stdout выделяется в куче раньше массива

    unsigned char *a = create_array(n); // каждый элемент занимает 1 байт
    generate_elems();
    print_array(a, n);

    // считаем то же самое на C для сравнения
    long sum = 0, even = 0;
    unsigned char copy[100];
    for (int i = 0; i < n; i++) {
        sum += a[i];
        if (a[i] % 2 == 0) {
            even++;
        }
        copy[i] = a[i];
    }

    long asm_sum = sum_array();
    long asm_even = count_even();

    printf("sum:  asm = %ld, C = %ld\n", asm_sum, sum);
    printf("even: asm = %ld, C = %ld\n", asm_even, even);

    reverse_array();
    printf("reversed:\n");
    print_array(a, n);

    int ok = 1;
    for (int i = 0; i < n; i++) {
        if (a[i] != copy[n - 1 - i]) {
            ok = 0;
        }
    }

    if (ok) {
        printf("reverse OK\n");
    } else {
        printf("reverse FAIL\n");
    }

    free_memory();
    return 0;
}
