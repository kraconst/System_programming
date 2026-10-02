format ELF64

public _start
public exit
public print_itoa

section '.data' writable
    nl db 10

section '.bss' writable
    string rb 4

section '.text' executable
    _start:
        pop rax ; извлекаем из стека количество переданных аргументов командной строки
        cmp rax, 2 ; если меньше 2, выходим
        jl exit

        pop rbx ; извлекаем имя программы
        pop rdi ; извлекаем адрес первого байта переданного символа
        xor rbx, rbx

        mov bl, byte [rdi] ; кладем в bl ASCII-код символа
        call print_itoa
        jmp exit

print_itoa:
    push rax ; пушим все регистры в стек, чтобы не изменять внешнее состояние программы
    push rdi
    push rsi
    push rcx
    push rdx
    mov rdx, 10 ; делитель
    xor rcx, rcx
    xor rax, rax
    mov ax, bx ; кладем делимое в ax
    @@: ; безымянная метка
        xor ah, ah ; обнуляем старшую часть делимого перед делением
        div dl ; беззнаковое деление на 10
        add ah, '0' ; переводим каждую цифру ASCII-кода в символ (ASCII-код символа)
        mov [string + rcx], ah ; помещаем в буфер строки для дальнейшего вывода
        inc rcx
        cmp al, 0 ; пока частное от деления не обнулится
        ja @b ; переходим на ближайшую сзади безымянную метку

    @@:
        dec rcx
        mov rax, string
        add rax, rcx
        mov rdi, 1
        mov rsi, rax
        mov rax, 1
        mov rdx, 1 ; побайтовый вывод строки с конца (в правильной последовательности цифр)
        push rcx
        syscall
        pop rcx
        cmp rcx, 0
        ja @b

    mov rax, 1
    mov rdi, 1
    mov rsi, nl ; переход на следующую строку
    mov rdx, 1
    syscall

    pop rdx
    pop rcx
    pop rsi ; возвращаем обратно исходные значения в регистрах
    pop rdi
    pop rax
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
