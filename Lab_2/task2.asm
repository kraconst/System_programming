format ELF64

public _start
public exit

section '.data' writable
    char db '&'
    nl db 10 ; \n

section '.bss' writable
    buffer rb 120 ; специально аллоцируем буфер для заполнения символами (включая \n)

section '.text' executable
    _start:
        mov al, [char] ; сохраняем наш символ в al
        xor rcx, rcx ; счетчик с 0
        .iter1:
            mov [buffer + rcx], al ; последовательно заполняем предварительно выделенный буфер в памяти нашими символами
            inc rcx
            cmp rcx, 105
            jne .iter1
        xor rbx, rbx ; счетчик с шагом 7 для вывода символов блоками
        .iter2:
            mov rax, 1
            mov rdi, 1
            lea rsi, [buffer + rbx] ; вычисляет динамический адрес и кладет его в rsi
            mov rdx, 7 ; выводим по 7 символов за раз в одной строке
            syscall

            mov rax, 1
            mov rdi, 1
            mov rsi, nl ; \n
            mov rdx, 1
            syscall

            add rbx, 7
            cmp rbx, 105
            jne .iter2
        jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
