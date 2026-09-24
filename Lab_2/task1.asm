format ELF64

public _start
public exit
public print_symb

section '.data' writable
    string db "FLVHIfsCdaXtJEzRKmmBidg"
    str_len = $ - string
    char db 1 ; байтовая ячейка для вывода одного символа

section '.text' executable
    _start:
        mov rcx, str_len ; индекс выводимого символа (байта), начиная с конца строки
        .iter:
            dec rcx
            mov al, [string + rcx] ; сохраняем выводимый символ в al
            push rcx ; запоминаем значение индекса (кладем его в стек)
            call print_symb
            pop rcx
            cmp rcx, 0 ; пока не дошли до нулевого символа строки
            jne .iter
        jmp exit

print_symb:
    mov [char], al ; помещаем байт символа из регистра al в ячейку памяти по адресу char
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall
    ret ; извлекает адрес возврата из верхушки стека и переходит по нему

exit:
    mov rax, 60
    mov rdi, 0
    syscall
