; библиотека необходимых функций

func_atoi:
    push rcx
    push rbx

    xor rax, rax
    xor rcx, rcx
    .loop:
        xor rbx, rbx
        mov bl, byte [rsi+rcx]
        cmp bl, 48
        jl .end
        cmp bl, 57
        jg .end

        sub bl, 48
        add rax, rbx
        mov rbx, 10
        mul rbx
        inc rcx
        jmp .loop

    .end:
        cmp rcx, 0
        je .restore
        mov rbx, 10
        div rbx

    .restore:
        pop rbx
        pop rcx
        ret

int_input_keyboard:
    push rax
    push rdi
    push rdx

    mov rax, 0
    mov rdi, 0
    mov rdx, 255
    syscall

    pop rdx
    pop rdi
    pop rax
    ret

input_keyboard:
    push rax
    push rdi
    push rdx

    mov rax, 0
    mov rdi, 0
    mov rdx, 20
    syscall

    xor rcx, rcx
    .loop:
        mov al, [rsi+rcx]
        inc rcx
        cmp al, 0x0A
        jne .loop
    dec rcx
    mov byte [rsi+rcx], 0

    pop rdx
    pop rdi
    pop rax
    ret

; Функция реверса строки
; Вход: rsi — указатель на строку (заканчивается байтом 0)
; Выход: строка по адресу rsi развернута в обратном порядке
reverse_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    ; Проверка: если указатель равен нулю, выходим
    mov rax, rsi
    cmp rax, 0
    je .done

    mov rcx, rsi        ; rcx — левый указатель (начало строки)
    mov rdx, rsi        ; rdx — правый указатель (будем искать конец)

    .find_end:
        mov al, byte [rdx]
        cmp al, 0
        je .found_end
        inc rdx
        jmp .find_end

    .found_end:
        ; Если строка пустая (начало совпадает с концом)
        cmp rcx, rdx
        je .done

        dec rdx             ; rdx теперь указывает на последний реальный символ строки (перед '\0')

    .swap_loop:
        cmp rcx, rdx
        jge .done           ; если левый указатель дошел до правого или перешагнул его — закончили

        mov al, byte [rcx]  ; читаем символ слева
        mov bl, byte [rdx]  ; читаем символ справа
        mov byte [rcx], bl  ; записываем правый символ на место левого
        mov byte [rdx], al  ; записываем левый символ на место правого

        inc rcx             ; сдвигаем левый указатель вправо
        dec rdx             ; сдвигаем правый указатель влево
        jmp .swap_loop

    .done:
        pop rdi
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

print_itoa:
    push rbx
    push rdi
    push rsi
    push rcx
    push rdx
    push r8

    mov r8, rsi

    cmp rax, 0
    jge .positive
    push rax

    push '-'
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax

    pop rax
    neg rax

    .positive:
        xor rbx, rbx
        mov rbx, 10
        xor rcx, rcx
        @@:
            xor rdx, rdx
            div rbx
            add rdx, '0'
            mov [r8 + rcx], dl
            inc rcx
            cmp rax, 0
            ja @b

        @@:
            dec rcx
            mov rax, r8
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

    push 10
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax

    pop r8
    pop rdx
    pop rcx
    pop rsi
    pop rdi
    pop rbx
    ret

len_str:
    push rdx
    mov rdx, rax
    .iter:
        cmp byte [rax], 0
        je .next
        inc rax
        jmp .iter
    .next:
        sub rax, rdx
        pop rdx
        ret

print_str:
    push rax
    push rdi
    push rdx
    push rcx
    mov rax, rsi
    call len_str
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    pop rcx
    pop rdx
    pop rdi
    pop rax
    ret

new_line:
    push rax
    push rdi
    push rsi
    push rdx
    push rcx
    mov rax, 0xA
    push rax
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    mov rax, 1
    syscall
    pop rax
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
