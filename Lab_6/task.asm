format ELF64

	public _start

	extrn initscr
	extrn start_color
	extrn init_pair
	extrn getmaxx
	extrn getmaxy
	extrn raw
	extrn noecho
	extrn keypad
	extrn stdscr
	extrn move
	extrn getch
	extrn clear
	extrn addch
	extrn refresh
	extrn endwin
	extrn exit
	extrn color_pair
	extrn cbreak
	extrn timeout
    extrn usleep


	section '.bss' writable

	xmax dq 1
	ymax dq 1
    x dq 1
    y dq 1
    delta_y dq 1
	palette dq 1
    delay dq 100000 ; начальная задержка — 100 мс

    section '.text' executable
        _start:
            ;; Инициализация
            call initscr
            call noecho
            call cbreak

            ;; Размеры экрана
            xor rdi, rdi
            mov rdi, [stdscr]
            call getmaxx
            mov [xmax], rax
            mov rdi, [stdscr]
            call getmaxy
            mov [ymax], rax

            call start_color

            ; init_pair(1, 3, 3) — жёлтая пара
            mov rdi, 1
            mov rsi, 3
            mov rdx, 3
            call init_pair

            ; init_pair(2, 2, 2) — зелёная пара
            mov rdi, 2
            mov rsi, 2
            mov rdx, 2
            call init_pair

            mov rax, 0x20
            or rax, 0x100
            mov [palette], rax

            mov rax, [xmax]
            dec rax
            mov [x], rax

            mov rax, [ymax]
            dec rax
            mov [y], rax

            mov qword [delta_y], -1

            mov edi, 0
            call timeout

        .main_loop:
            mov rdi, [y]
            mov rsi, [x]
            call move

            mov rdi, [palette]
            call addch
            call refresh

            mov rdi, [delay]
            call usleep
            ;; Сохраняем изображение до нажатия клавиши 'b'
            .wait_key:
                call getch ; опрос клавиатуры
                cmp eax, 'b'
                jne .accelerate

                call endwin
                xor rdi, rdi
                call exit

            .accelerate:
                cmp eax, 'o'
                jne .next

                cmp qword [delay], 10000  ; уже достигли максимальной скорости?
                jle .reset_delay

                sub qword [delay], 10000  ; уменьшить задержку на 10 мс
                jmp .next

                .reset_delay:
                    mov qword [delay], 100000
                    jmp .next

            .next:
                mov rbx, [y]
                add rbx, [delta_y]

                cmp rbx, 0
                jl .turn_left
                cmp rbx, [ymax]
                jge .turn_left
                mov [y], rbx
                jmp .main_loop

            .turn_left:
                cmp [x], 0
                jle .beginning
                sub [x], 1
                neg qword [delta_y]
                jmp .main_loop

            .beginning:
                mov rax, [xmax]
                dec rax
                mov [x], rax
                mov rax, [ymax]
                dec rax
                mov [y], rax
                mov qword [delta_y], -1

                xor qword [palette], 0x300
                jmp .main_loop
