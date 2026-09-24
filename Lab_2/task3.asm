format ELF64

public _start
public exit

section '.data' writable
    char db '&'
    nl db 10

section '.bss' writable
    buffer rb 120 ; резервируем буфер для символов
    cur_adr rq 1 ; переменная (8 байт) для хранения текущего адреса чтения из буфера

section '.text' executable
    _start:
        mov al, [char]
        xor rcx, rcx
        .iter1:
            mov [buffer + rcx], al
            inc rcx
            cmp rcx, 105
            jne .iter1
        xor rbx, rbx ; будет хранить количество выводимых символов в каждой строке
        mov rax, buffer
        mov [cur_adr], rax ; инициализируем указатель началом буфера
        .iter2:
            mov rax, 1
            mov rdi, 1
            add [cur_adr], rbx ; сдвигаем указатель вперед на количество выведенных в прошлый раз символов
            mov rsi, [cur_adr] ; адрес начала блока для вывода
            inc rbx ; увеличиваем количество выводимых символов на 1 (для новой строки)
            mov rdx, rbx
            syscall

            mov rax, 1
            mov rdi, 1
            mov rsi, nl
            mov rdx, 1
            syscall

            cmp rbx, 14 ; напечатали ли мы уже строку из 14 символов (последнюю)
            jne .iter2
        jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
