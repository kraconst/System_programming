format ELF64

public _start
public exit

section '.data' writable
    num dd 3469816182
    ten db 1

section '.bss' writable
    result rb 2

section '.text' executable
    _start:
        xor ebx, ebx
        mov ecx, 10
        mov eax, [num]
        .iter1:
            xor edx, edx
            div ecx
            add ebx, edx
            cmp eax, 0
            jne .iter1

        xor eax, eax
        mov [ten], cl
        mov rcx, 2
        .iter2:
            dec rcx
            mov ax, bx
            xor ah, ah
            div [ten]
            mov bl, al
            add ah, '0'
            mov [result + rcx], ah
            cmp rcx, 0
            jne .iter2

        mov rax, 1
        mov rdi, 1
        mov rsi, result
        mov rdx, 2
        syscall
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
