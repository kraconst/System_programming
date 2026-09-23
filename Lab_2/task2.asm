format ELF64

public _start
public exit

section '.data' writable
    char db '&'
    nl db 10

section '.bss' writable
    buffer rb 120

section '.text' executable
    _start:
        mov al, [char]
        xor rcx, rcx
        .iter1:
            mov [buffer + rcx], al
            inc rcx
            cmp rcx, 105
            jne .iter1
        xor rbx, rbx
        .iter2:
            mov rax, 1
            mov rdi, 1
            lea rsi, [buffer + rbx] ; вычисляет динамический адрес и кладет его в rsi
            mov rdx, 7
            syscall

            mov rax, 1
            mov rdi, 1
            mov rsi, nl
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
