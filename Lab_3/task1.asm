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
        pop rax
        cmp rax, 2
        jl exit

        pop rbx
        pop rdi
        xor rbx, rbx

        mov bl, byte [rdi]
        call print_itoa
        jmp exit

print_itoa:
    push rax
    push rdi
    push rsi
    push rcx
    push rdx
    mov rdx, 10
    xor rcx, rcx
    xor rax, rax
    mov ax, bx
    @@:
        xor ah, ah
        div dl
        add ah, '0'
        mov [string + rcx], ah
        inc rcx
        cmp al, 0
        ja @b

    @@:
        dec rcx
        mov rax, string
        add rax, rcx
        mov rdi, 1
        mov rsi, rax
        mov rax, 1
        mov rdx, 1
        push rcx
        syscall
        pop rcx
        cmp rcx, 0
        ja @b

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    pop rdx
    pop rcx
    pop rsi
    pop rdi
    pop rax
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
