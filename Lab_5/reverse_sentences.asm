format elf64
public _start

include '../Lab_4/funcs.asm'

section '.data' writable
    buffer rb 1025 ; буфер для чтения (1024 байта + место под нуль-терминатор)

section '.text' executable
    _start:
        pop rcx
        cmp rcx, 3
        jl .l1

        mov rdi, [rsp+8] ; адрес имени входного файла
        mov rax, 2 ; sys_open
        mov rsi, 0o ; O_RDONLY
        syscall
        cmp rax, 0
        jl .l1 ; ошибка открытия
        mov r8, rax ; r8 = дескриптор входного файла

        mov rdi, [rsp+16] ; адрес имени выходного файла
        mov rax, 2 ; sys_open
        mov rsi, 577 ; O_WRONLY | O_CREAT | O_TRUNC
        mov rdx, 0644o ; права rw-r--r--
        syscall
        cmp rax, 0
        jl .close_input
        mov r9, rax ; r9 = дескриптор выходного файла

        xor r10, r10 ; r10 = сколько байт сейчас в буфере
        xor r14, r14 ; r14 = 1, если файл закончился

.read:
    mov rax, 0 ; sys_read
    mov rdi, r8
    mov rsi, buffer
    add rsi, r10 ; дописываем после недочитанного хвоста
    mov rdx, 1024
    sub rdx, r10 ; читаем сколько влезет в оставшееся место в буфере
    syscall
    cmp rax, 0
    jle .eof ; 0 - конец файла, <0 - ошибка
    add r10, rax ; новая длина данных в буфере
    xor r12, r12 ; r12 = начало текущего предложения
    xor r13, r13 ; r13 = позиция сканирования

.scan: ; ищем конец предложения
    cmp r13, r10
    je .scan_end ; буфер просмотрен
    mov bl, byte [buffer+r13]
    inc r13 ; r13 - позиция сразу за символом
    cmp bl, '.'
    je .flush
    cmp bl, '!'
    je .flush
    cmp bl, '?'
    je .flush
    jmp .scan

.flush: ; предложение - buffer[r12 .. r13)
    xor rbx, rbx
    mov bl, byte [buffer+r13]
    mov r15, rbx ; r15 = байт, который временно затрём нулём
    mov byte [buffer+r13], 0 ; ставим конец строки
    mov rsi, buffer
    add rsi, r12
    call reverse_string ; переворачиваем предложение
    mov rax, rsi ; rsi = адрес результата
    call len_str
    mov rdx, rax ; rdx = длина для записи
    mov rax, 1 ; sys_write
    mov rdi, r9
    syscall
    mov rbx, r15
    mov byte [buffer+r13], bl ; возвращаем затёртый байт
    mov r12, r13 ; следующее предложение начинается здесь
    cmp r14, 1
    je .close_both ; это был последний кусок файла
    jmp .scan

.scan_end: ; остался хвост buffer[r12 .. r10)
    cmp r12, 0
    je .no_shift
    mov rcx, r12 ; rcx = откуда копируем
    xor rdx, rdx ; rdx = куда копируем

.copy: ; сдвигаем хвост в начало буфера
    cmp rcx, r10
    je .copied
    mov bl, byte [buffer+rcx]
    mov byte [buffer+rdx], bl
    inc rcx
    inc rdx
    jmp .copy

.copied:
    mov r10, rdx ; длина хвоста
    jmp .read

.no_shift:
    cmp r10, 1024
    jl .read ; буфер не полон - дочитываем
    mov r13, r10 ; буфер полон, а конца предложения нет -
    jmp .flush ; выводим как есть

.eof:
    mov r14, 1 ; файл закончился
    cmp r10, 0
    je .close_both ; хвоста нет
    xor r12, r12 ; хвост с начала буфера
    mov r13, r10
    jmp .flush ; выводим последний кусок без . ! ?

.close_both:
    mov rdi, r9
    mov rax, 3 ; sys_close
    syscall

.close_input:
    mov rdi, r8
    mov rax, 3 ; sys_close
    syscall

.l1:
    call exit
