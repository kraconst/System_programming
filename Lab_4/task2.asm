format ELF64

public _start
public sum_of_series

include 'funcs.asm'

section '.bss' writable
    msg rb 20
    result rb 20

section '.text' executable
    _start:
        mov rsi, msg
        call input_keyboard
        call func_atoi
        call sum_of_series

        mov rsi, result
        call print_itoa
        jmp exit

; Вход:  rax = n
; Выход: rax = итоговая сумма ряда
sum_of_series:
    push rcx
    push rdx
    push r8
    push r9
    push rdi

    xor rcx, rcx
    xor r8, r8
    xor rdi, rdi
    mov rdi, 2
    mov r8, rax ; n
    xor rax, rax ; накопитель
    .loop:
        inc rcx
        push rax

        mov rax, rcx
        mul rcx ; rax = rcx * rcx
        mov r9, rax ; r9 = k²

        mov rax, rcx
        xor rdx, rdx
        div rdi ; rdx = остаток от деления k на 2

        pop rax ; Восстанавливаем сумму в rax
        cmp rdx, 0
        je .even
        add rax, r9 ; для нечетных
        jmp .next
        .even:
            sub rax, r9 ; для четных
        .next:
            cmp rcx, r8
            jl .loop

    pop rdi
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret
