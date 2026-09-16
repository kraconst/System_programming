format ELF
public _start

fio_msg db "Krasnov", 0xA, \
            "Kostantin", 0xA, \
            "Michailovich", 0xA
fio_len = $ - fio_msg

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, fio_msg
    mov edx, fio_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
