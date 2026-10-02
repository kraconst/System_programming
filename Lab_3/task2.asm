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
        pop rdi ; указатель на строку с первым операндом - b
        pop rsi ; указатель на строку со вторым операндом - c
        xor rbx, rbx
        xor rcx, rcx

        call func_atoi ; на вход передается адрес первого байта первого аргумента в rdi
        mov rbx, rax ; сохраняем первый операнд в rbx

        mov rdi, rsi ; кладем адрес первого байта второго аргумента в rdi
        call func_atoi
        mov rcx, rax ; сохраняем второй операнд в rcx

        call calculate ; находим значение арифметического выражения
        jmp exit

func_atoi: ; парсит число из строки, принимая адрес начала строки в rdi и аккумулируя число в rax
    push r8
    push rbx
    push rcx
    push rsi

    xor rax, rax ; на выходе в rax будет лежать наше число
    xor rbx, rbx
    mov rbx, 10
    xor rcx, rcx
    @@: ; безымянная метка
        xor r8, r8
        mov r8b, byte [rdi + rcx] ; кладем каждый символ по адресу, начиная с rdi

        cmp r8, '0' ; проверяем, принадлежит ли символ нашему числу
        jb @f ; если это, к примеру, ' ', то переходим на ближайшую безымянную метку впереди
        cmp r8, '9'
        ja @f ; аналогично, это значит, что число уже сформировалось

        sub r8, '0' ; получаем саму цифру числа
        mul rbx ; умножает значение в rax на 10
        add rax, r8 ; и прибавляет следующую цифру, аккумулируя число
        inc rcx
        jmp @b ; переходим на ближайшую безымянную метку сзади, то есть на следующую итерацию цикла

    @@: ; безымянная метка
        pop rsi
        pop rcx
        pop rbx
        pop r8
        ret

calculate: ; считает значение арифметического выражения, сохраняя его в регистр rax
    push rax
    push rdx
    push rdi
    push rsi

    xor rax, rax
    mov rax, rcx
    add rax, rbx
    mul rbx
    sub rax, rcx
    call print_itoa ; и передаем управление функции вывода
    pop rsi
    pop rdi
    pop rdx
    pop rax
    ret ; берет из верхушки стека адрес возврата и переходит по нему

print_itoa: ; переводит число в последовательность символов, которую записывает в буфер для дальнейшего вывода на экран
    push rbx
    push rdi
    push rsi
    push rcx
    push rdx
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
