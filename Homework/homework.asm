format elf64

public create_array
public generate_elems
public sum_array
public count_even
public reverse_array
public free_memory

section '.data' writable
    rnd db "/dev/random", 0

section '.bss' writable
    array_begin rq 1
    count rq 1

section '.text' executable
create_array: ; input rdi - размер массива, output rax - адрес массива
	mov [count], rdi
	;; Получаем начальное значение адреса кучи
	xor rdi,rdi
	mov rax, 12 ;brk
	syscall
	mov [array_begin], rax
	mov rdi, [array_begin]
	add rdi, [count]
	mov rax, 12 ; записываем новое значение адреса кучи
	syscall
	mov rax, [array_begin]
	ret

generate_elems:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi

    mov rax, 2
    mov rdi, rnd
    mov rsi, 0o
    syscall
    cmp rax, 0
    jl .done ; не удалось открыть /dev/random
    mov rdi, rax ; rdi = дескриптор /dev/random

    mov rax, 0 ; читаем сразу count байт в массив
    mov rsi, [array_begin]
    mov rdx, [count]
    syscall

    mov rax, 3 ; close
    syscall

    .done:
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax
    ret

sum_array: ; output rax - сумма элементов массива
    push rbx
    push rcx
    push rsi
    xor rbx, rbx
    xor rcx, rcx
    mov rsi, [array_begin]

    .loop:
        xor rax, rax
        mov al, byte [rsi+rcx]
        add rbx, rax
        inc rcx
        cmp rcx, [count]
        jb .loop

    mov rax, rbx
    pop rsi
    pop rcx
    pop rbx
    ret

count_even: ; output rax - количество четных чисел
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    xor rbx, rbx
    xor rcx, rcx
    mov rsi, [array_begin] ; rsi = адрес начала массива в куче
    mov rdi, 2

    .loop:
        xor rax, rax
        mov al, byte [rsi+rcx]
        xor rdx, rdx
        div rdi ; rdx = остаток от деления на 2
        cmp rdx, 0
        jne .next
        inc rbx
    .next:
        inc rcx
        cmp rcx, [count]
        jb .loop

    mov rax, rbx
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

reverse_array:
    push rax
    push rbx
    push rcx
    push rdx
    mov rax, [array_begin]
    xor rcx, rcx ; rcx - индекс с начала
    mov rdx, [count]
    dec rdx ; rdx - индекс с конца

    .loop:
        cmp rcx, rdx
        jge .done
        ; меняем местами элементы [rcx] и [rdx]
        mov bl, [rax+rcx]
        mov bh, [rax+rdx]
        mov [rax+rcx], bh
        mov [rax+rdx], bl
        inc rcx
        dec rdx
        jmp .loop

    .done:
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

free_memory:
	mov rdi, [array_begin] ; сбрасываем адрес кучи до исходного
	mov rax, 12
	syscall
	ret
