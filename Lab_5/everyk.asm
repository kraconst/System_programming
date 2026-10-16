format elf64
public _start

include '../Lab_4/funcs.asm'

section '.data' writable
    buffer rb 1 ; буфер на 1 байт для побайтового чтения/записи

section '.text' executable
    _start:
        pop rcx
        cmp rcx, 4
        jl .l1

        mov rdi, [rsp+8] ; адрес имени входного файла
        mov rax, 2 ; sys_open
        mov rsi, 0o ; O_RDONLY, только чтение
        syscall
        cmp rax, 0 ; проверяем результат открытия
        jl .l1 ; rax < 0 - ошибка открытия, завершаем работу
        mov r8, rax ; r8 = дескриптор входного файла

        mov rdi, [rsp+16] ; адрес имени выходного файла
        mov rax, 2 ; sys_open
        mov rsi, 577 ; флаги: O_WRONLY | O_CREAT | O_TRUNC
        mov rdx, 0644o ; права создаваемого файла (rw-r--r--)
        syscall
        cmp rax, 0
        jl .close_input ; ошибка - закрываем уже открытый входной файл
        mov r9, rax ; r9 = дескриптор выходного файла

        mov rsi, [rsp+24] ; адрес строки с числом k
        call func_atoi ; переводим строку в число, результат в rax
        mov rbx, rax ; rbx = k

cmp rbx, 0 ; защита от деления на ноль
je .close_both

xor r10, r10 ; r10 = счётчик прочитанных символов (позиция в файле), изначально 0

.loop_read:
    mov rax, 0 ; sys_read
    mov rdi, r8 ; rdi = дескриптор входного файла
    mov rsi, buffer ; rsi = адрес буфера, куда запишется прочитанный байт
    mov rdx, 1 ; читаем по одному байту (смещение в файле сдвигается автоматически)
    syscall ; в rax вернётся число прочитанных байт
    cmp rax, 0 ; сравниваем с 0
    jle .close_both ; rax <= 0: конец файла (EOF) или ошибка - выходим из цикла

    inc r10 ; увеличиваем номер текущего символа

    mov rax, r10 ; rax = делимое (номер символа)
    xor rdx, rdx ; обнуляем старшую часть делимого rdx:rax перед div
    div rbx ; делим на k: частное в rax, остаток в rdx
    cmp rdx, 0 ; остаток 0 - номер символа кратен k
    jne .loop_read ; остаток не 0 - символ пропускаем, читаем следующий

    mov rax, 1 ; sys_write
    mov rdi, r9 ; rdi = дескриптор выходного файла
    mov rsi, buffer ; rsi = адрес буфера с символом
    mov rdx, 1 ; rdx = записываем 1 байт
    syscall ; пишем каждый k-й символ в выходной файл
    jmp .loop_read ; возвращаемся к чтению

.close_both:
    mov rdi, r9 ; rdi = дескриптор выходного файла
    mov rax, 3 ; sys_close
    syscall ; закрываем выходной файл

.close_input:
    mov rdi, r8 ; rdi = дескриптор входного файла
    mov rax, 3
    syscall ; закрываем входной файл

.l1:
    call exit
