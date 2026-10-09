format ELF64

public _start
public autentificate

include 'funcs.asm'

section '.bss' writable
    buf rb 255

section '.data' writable
    right db "Welcome", 0
    password db "ydlI840HsUkfns31", 0
    wrong db "wrong password, try again", 0
    failure db "access denied", 0

section '.text' executable
    _start:
        call autentificate
        jmp exit


autentificate:
    push rax
    push rbx
    push rcx
    push rsi

    xor rbx, rbx
    mov bl, 5
    .try:
        mov rsi, buf
        call input_keyboard
        mov rax, rsi
        call len_str
        push rbx
        mov rbx, rax ; длина введенного пароля
        mov rax, password
        call len_str ; в rax - длина заданного пароля
        cmp rax, rbx ; сначала сравниваем длины паролей
        pop rbx
        jne .ifwrong

        mov rcx, rax
        .loop:
            dec rcx ; идем с конца
            push rbx ; сохраняем счетчик попыток
            mov bl, byte [rsi + rcx]
            cmp bl, byte [password + rcx] ; посимвольное сравнение паролей
            pop rbx
            jne .ifwrong
            cmp rcx, 0
            ja .loop
            jmp .success ; если прошлись по всей строке и все символы совпали с правильным паролем, то успешный вход

    .ifwrong:
        dec bl
        cmp bl, 0 ; если вдруг закончились попытки, то вход запрещен
        je .fail

        mov rsi, wrong
        call print_str
        call new_line
        jmp .try ; снова пробуем ввести пароль
    .fail:
        mov rsi, failure
        call print_str
        call new_line
        jmp .restore
    .success:
        mov rsi, right
        call print_str
        call new_line
        jmp .restore

    .restore:
        pop rsi
        pop rcx
        pop rbx
        pop rax
        ret
