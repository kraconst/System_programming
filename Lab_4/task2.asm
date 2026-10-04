format ELF64

public _start

section '.bss' writable
    msg rb 20
    result rb 20

section '.data' writable
    nl db 10
    minus db '-'

section '.text' executable
    _start:
        mov rsi, msg
        call input_keyboard
        call func_atoi
        call sum_of_series
        call print_itoa
        jmp exit


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
        mul rcx
        mov r9, rax

        mov rax, rcx
        xor rdx, rdx
        div rdi

        pop rax
        cmp rdx, 0
        je .even
        add rax, r9    ; для нечетных
        jmp .next
        .even:
            sub rax, r9    ; для четных
        .next:
            cmp rcx, r8
            jl .loop

    pop rdi
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret


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

print_itoa: ; переводит число в последовательность символов, которую записывает в буфер для дальнейшего вывода на экран
    push rbx
    push rdi
    push rsi
    push rcx
    push rdx

    cmp rax, 0
    jge .positive
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, minus
    mov rdx, 1
    syscall
    pop rax
    neg rax

    .positive:
        xor rbx, rbx
        mov rbx, 10
        xor rcx, rcx
        @@: ; безымянная метка
            xor rdx, rdx ; очищаем для остатка
            div rbx ; 8-байтовый делитель
            add rdx, '0' ; переводим каждую цифру в символ
            mov [result + rcx], dl ; записываем в обратном порядке в буфер
            inc rcx
            cmp rax, 0 ; пока частное не обнулится
            ja @b

        @@: ; безымянная метка
            dec rcx
            mov rax, result
            add rax, rcx
            mov rdi, 1
            mov rsi, rax
            mov rax, 1
            mov rdx, 1
            push rcx
            syscall ; побайтовый вывод ответа из буфера
            pop rcx
            cmp rcx, 0
            ja @b ; переход на ближайшую безымянную метку назад

    mov rax, 1
    mov rdi, 1
    mov rsi, nl ; вывод \n
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
