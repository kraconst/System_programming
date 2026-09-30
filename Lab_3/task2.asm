format ELF64

public _start
public func_atoi
public calculate
public print_itoa
public exit

section '.data' writable
    nl db 10

section '.bss' writable
    result rb 20

section '.text' executable
    _start:
        pop rax
        cmp rax, 3
        jl exit

        pop rdx ; имя исполняемого файла
        pop rdi
        pop rsi
        xor rbx, rbx
        xor rcx, rcx

        call func_atoi
        mov rbx, rax

        mov rdi, rsi
        call func_atoi
        mov rcx, rax

        call calculate
        jmp exit

func_atoi:
    push r8
    push rbx
    push rcx
    push rsi

    xor rax, rax
    xor rbx, rbx
    mov rbx, 10
    xor rcx, rcx
    @@:
        xor r8, r8
        mov r8b, byte [rdi + rcx]

        cmp r8, '0'
        jb @f
        cmp r8, '9'
        ja @f

        sub r8, '0'
        mul rbx
        add rax, r8
        inc rcx
        jmp @b

    @@:
        pop rsi
        pop rcx
        pop rbx
        pop r8
        ret

calculate:
    push rax
    push rdx
    push rdi
    push rsi

    xor rax, rax
    mov rax, rcx
    add rax, rbx
    mul rbx
    sub rax, rcx
    call print_itoa
    pop rsi
    pop rdi
    pop rdx
    pop rax
    ret

print_itoa:
    push rbx
    push rdi
    push rsi
    push rcx
    push rdx
    xor rbx, rbx
    mov rbx, 10
    xor rcx, rcx
    @@:
        xor rdx, rdx
        div rbx
        add rdx, '0'
        mov [result + rcx], dl
        inc rcx
        cmp rax, 0
        ja @b

    @@:
        dec rcx
        mov rax, result
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
    pop rbx
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
