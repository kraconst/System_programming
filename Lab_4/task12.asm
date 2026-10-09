format ELF64

public _start
public non_decreasing_order

include 'funcs.asm'

section '.bss' writable
    msg rb 255

section '.data' writable
    no db "no", 0
    yes db "yes", 0

section '.text' executable
    _start:
        mov rsi, msg
        call int_input_keyboard
        call non_decreasing_order
        jmp exit


non_decreasing_order:
    push rcx
    push rbx

    xor rax, rax ; предыдущая цифра
    xor rcx, rcx ; индекс текущего символа
    .loop:
        xor rbx, rbx
        mov bl, byte [rsi+rcx] ; текущий символ в строке
        cmp bl, 48 ; проверяем следующий символ на то, что он является цифрой
        jl .yes ; иначе это означает, что число закончилось, и оно прошло проверку
        cmp bl, 57
        jg .yes

        sub bl, 48 ; преобразуем ASCII-код в цифру
        cmp al, bl ; сравниваем предыдущую цифру с текущей
        ja .no ; и в случае если она больше, то это нарушает неубывание
        mov al, bl ; обновляем предыдущую цифру
        inc rcx
        jmp .loop

    .no:
        mov rsi, no
        jmp .end
    .yes:
        mov rsi, yes
        jmp .end

    .end:
        call print_str
        call new_line
        pop rbx
        pop rcx
        ret
