format elf64
public _start

include 'func.asm'

section '.bss' writable
    buffer rb 64

section '.data' writable
    error db "error occured while reading arguments", 0

section '.text' executable
    _start:
        pop rcx
        cmp rcx, 2
        jl .err

        mov rsi, [rsp+8]
        call str_number
        mov r8, rax
        xor r9, r9
        xor r10, r10
        xor rcx, rcx
        mov rbx, 10

.loop:
    cmp rcx, r8
    ja .done

    mov rax, r10
    mul rbx
    inc rax
    mov r10, rax
    add r9, r10
    inc rcx
    jmp .loop

.done:
    mov rax, r9
    mov rsi, buffer
    call number_str
    call print_str
    call new_line
    call exit

.err:
    mov rsi, error
    call print_str
    call exit
