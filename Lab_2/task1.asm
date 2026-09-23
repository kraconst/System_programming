format ELF64

public _start
public exit
public print_symb

section '.data' writable
    string db "FLVHIfsCdaXtJEzRKmmBidg"
    str_len = $ - string
    char db 1

section '.text' executable
    _start:
        mov rcx, str_len
        .iter:
            dec rcx
            mov al, [string + rcx]
            push rcx
            call print_symb
            pop rcx
            cmp rcx, 0
            jne .iter
        jmp exit

print_symb:
    mov [char], al
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
