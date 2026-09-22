format ELF64

public _start
public exit

section '.data' writable
    char db '&'
    nl db 10

section '.bss' writable
    buffer rb 120
    cur_adr rq 1

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
        mov rax, buffer
        mov [cur_adr], rax
        .iter2:
            mov rax, 1
            mov rdi, 1
            add [cur_adr], rbx
            mov rsi, [cur_adr]
            inc rbx
            mov rdx, rbx
            syscall

            mov rax, 1
            mov rdi, 1
            mov rsi, nl
            mov rdx, 1
            syscall

            cmp rbx, 14
            jne .iter2
        call exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
