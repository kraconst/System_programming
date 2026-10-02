format ELF64
public _start

fio_msg db "Krasnov", 0xA, \
            "Kostantin", 0xA, \
            "Michailovich", 0xA
fio_len = $ - fio_msg

_start:
    xor rcx, rcx
    @@:
        mov rsi, fio_msg
        add rsi, rcx
        inc rcx
        cmp byte [rsi], 0xA
        jne @b

    mov r8, rcx
    inc r8
    .loop:
        dec r8
        mov rax, 1
        mov rdi, 1
        mov rsi, fio_msg
        add rsi, r8
        mov rdx, 1
        syscall
        cmp r8, 0
        ja .loop

    mov rax, 60
    xor rdi, 0
    syscall
