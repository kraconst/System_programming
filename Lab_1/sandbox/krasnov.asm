format ELF64
public _start

section '.data' writable
public fio_msg
fio_msg db "Krasnov", 0xA, \
            "Kostantin", 0xA, \
            "Michailovich", 0xA
fio_len = $ - fio_msg

_start:
    mov rbx, fio_msg
.word:
    xor rcx, rcx
    mov rcx, 1
    @@:
        mov rsi, rbx
        add rsi, rcx
        inc rcx
        cmp byte [rsi], 0xA
        jne @b

    mov r8, rcx
    dec r8
    mov r9, r8

    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx, 1
    syscall

    .loop:
        dec r8
        mov rax, 1
        mov rdi, 1
        mov rsi, rbx
        add rsi, r8
        mov rdx, 1
        syscall
        cmp r8, 1
        ja .loop

    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    add rsi, r9
    mov rdx, 1
    syscall

    add rbx, r9
    inc rbx ; хранит адрес начала текущего слова
    cmp rbx, fio_msg + fio_len
    jb .word

    mov rax, 60
    xor rdi, rdi
    syscall
