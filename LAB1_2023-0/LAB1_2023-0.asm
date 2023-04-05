section .data
    message_input db "Ingrese los numeros: "
    len_msg_input equ $ - message_input
    message_solut db "La solucion es: "
    len_msg_solut equ $ - message_solut
    signo db "-"
    var_a dq 0
    var_b dq 0
    var_c dq 0
    char dq 0
    solucion dq 0

section .text
    global _start

_start:
    ;parametros para activar el sys_write
    mov rax, 1
    mov rdi, 1 
    mov rsi, message_input
    mov rdx, len_msg_input
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, var_a
    mov rdx, 1
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, var_b
    mov rdx, 1
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, var_c
    mov rdx, 1
    syscall

    mov rax, 0
    mov rdi, 0 
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1 
    mov rsi, message_solut
    mov rdx, len_msg_solut
    syscall

solution:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    mov rax, [var_b]
    sub rax, 30h
    mul rax ;mul usa rax
    mov r8, rax ;b^2
error:
    mov rax, 4 ;constante 4
    mov r11, [var_a]
    sub r11, 30h
    mov r12, [var_c]
    sub r12, 30h
    mul r12
    mul r11
    mov r9, rax ;4ac

resta:
    sub r8, r9

 impresion:
    mov rax, r8
    cmp rax, 0
    jle impresionNegativo

    impresion_positivo:
    cmp rax, 10
    jle final
    mov rbx, 10
    div rbx ;separando el numero por digitos y el restante queda en rdx, lo muevo a r10
    mov r10, rdx
    add rax, 30h
    mov [solucion], rax

    mov rax, 1
    mov rdi, 1 
    mov rsi, solucion
    mov rdx, 1
    syscall

    mov rax, r10

final:
    add rax, 30h
    mov [solucion], rax

    mov rax, 1
    mov rdi, 1 
    mov rsi, solucion
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1 
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

impresionNegativo:    
    mov r13, rax
    mov r14, rdx

    mov rax, 1
    mov rdi, 1 
    mov rsi, signo
    mov rdx, 1
    syscall

    mov rdx, r14
    mov rax, r13
    neg rax
    cmp rax, 10

    jle final
    jmp impresion_positivo