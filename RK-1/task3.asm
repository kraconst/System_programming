format elf64
public _start

include 'func.asm'

section '.data' writable
    rnd   db "/dev/random", 0
    error db "error occured while reading arguments", 0x0a, 0

section '.bss' writable
    buffer rb 100000 ; сюда читаем содержимое каталога
    old rb 4096
    new rb 4096
    number rq 1 ; сюда читаем случайный байт

section '.text' executable
    _start:
        pop rcx
        cmp rcx, 2
        jne .err

        mov rax, 2
        mov rdi, rnd
        mov rsi, 0o
        syscall
        cmp rax, 0
        jl .err
        mov r12, rax ; r12 = дескриптор /dev/random

        mov rax, 2
        mov rdi, [rsp+8]
        mov rsi, 65536 ; флаги O_RDONLY | O_DIRECTORY
        syscall
        cmp rax, 0
        jl .err
        mov r8, rax ; r8 = дескриптор каталога

        mov rax, 78 ; системный вызов getdents
        mov rdi, r8
        mov rsi, buffer
        mov rdx, 100000
        syscall
        mov r10, rax ; r10 = сколько байт прочитали

        ;закрываем каталог
        mov rax, 3
        mov rdi, r8
        syscall

        cmp r10, 0
        jle .end

        mov rsi, [rsp+8]
        mov rdi, old
        call copy_str ; возвращает в rdi адрес заверщающего нуля
        mov byte [rdi], '/' ; "каталог/старое_имя"
        inc rdi
        mov r13, rdi ; r13 = место для имени файла в old

        mov rsi, [rsp+8]
        mov rdi, new
        call copy_str
        mov byte [rdi], '/' ; "каталог/новое_имя"
        inc rdi
        mov r14, rdi ; r14 = место для имени файла в new

        xor r15, r15 ; r15 = текущая позиция в buffer

.loop:
    cmp r15, r10
    jge .end

    xor r9, r9
    mov r9w, word [buffer+16+r15] ; d_reclen - размер всей структуры linux_dirent

    mov al, byte [buffer+r9-1+r15]
    cmp al, 8
    jne .next ; пропускаем все файлы кроме обычных

    call random_byte
    and rax, 1 ;файл выбирается, если случайный байт нечётный
    cmp rax, 0
    je .next

    mov rsi, buffer
    add rsi, 18
    add rsi, r15 ; добавляем старое имя файла в путь (начинается со смещения 18)
    mov rdi, r13
    call copy_str

    mov rdi, r14
    mov rbx, 12 ; имя файла из 12 случайных букв

.gen:
    call random_byte
    xor rdx, rdx
    mov rcx, 26
    div rcx ; rdx = случайное число от 0 до 25
    add dl, 'a'
    mov byte [rdi], dl
    inc rdi
    dec rbx
    cmp rbx, 0
    jne .gen
    mov byte [rdi], 0

    mov rax, 82 ;системный вызов rename
    mov rdi, old
    mov rsi, new
    syscall
    cmp rax, 0
    jl .next

.next:
    add r15, r9 ; переходим к следующей записи
    jmp .loop

.end:
    mov rax, 3
    mov rdi, r12 ; закрываем /dev/random
    syscall
    call exit

.err:
    mov rsi, error
    call print_str
    call exit


;output rax - случайное число от 0 до 255
random_byte:
    push rdi
    push rsi
    push rdx
    mov rax, 0
    mov rdi, r12
    mov rsi, number
    mov rdx, 1
    syscall
    pop rdx
    pop rsi
    pop rdi
    mov rax, [number]
    ret
