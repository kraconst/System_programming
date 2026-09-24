format ELF64

public _start
public exit

section '.data' writable
    num dd 3469816182 ; беззнаковое представление, укладывается в 32 бита
    ten db 1

section '.bss' writable
    result rb 2 ; буфер для строки, состоящей из цифр ответа (суммы)

section '.text' executable
    _start:
        xor ebx, ebx ; будет аккумулировать сумму цифр числа
        mov ecx, 10
        mov eax, [num] ; кладем делимое в eax (оттуда его будет использовать div)
        .iter1:
            xor edx, edx ; обнуляем edx для корректного считывания делимого
            div ecx ; делит число, хранящееся в edx:eax на число, которое лежит в ecx (10)
            add ebx, edx ; прибавляем к сумме остаток от деления числа на 10
            cmp eax, 0 ; в eax сохраняется результат деления
            jne .iter1
        ; посимвольный вывод ответа
        xor eax, eax
        mov [ten], cl ; теперь делитель должен быть 8-битный
        mov rcx, 2 ; счетчик для вывода цифр суммы
        .iter2:
            dec rcx
            mov ax, bx ; кладем предыдущий результат в ax
            xor ah, ah ; обнуляем ah для корректного считывания делимого
            div [ten] ; делит число в ax на 10, сохраняя результат в al и остаток в ah
            mov bl, al ; сохраняет результат
            add ah, '0' ; к остатку прибавляем '0', получаем ASCII-код цифры числа
            mov [result + rcx], ah ; записываем цифру в буфер с конца
            cmp rcx, 0
            jne .iter2

        mov rax, 1
        mov rdi, 1
        mov rsi, result ; выводим последовательность символов суммы в виде строки
        mov rdx, 2
        syscall
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
