; nasm -f elf64 stringlength.asm -o stringlength.o
; ld stringlength.o -o stringlength
; ./stringlength

section .data
message db "Hello World",10,0
    solution dq 0

section .text
global _start

_start:
mov rax, message
mov rbx, 0

_countLoop:
inc rax
inc rbx
mov cl, [rax]
cmp cl, 0
jne _countLoop

    dec rbx
    mov [solution], rbx

test:                   ; pushea en la pila el resultado
    xor rcx, rcx
    mov r8, 10
    mov rcx, [solution]
    mov rbx, 0
    xor rdx, rdx

division:
    mov rax, rcx
    cmp rax, r8
    jl aux

    div r8              ; rdx resudio / rax cociente
    inc rbx
    push rdx
    mov rcx, rax
    jmp division

aux:
    push rax
    inc rbx

loopPrint:

    cmp rbx, 0
    je final
    dec rbx
    pop rcx

    add rcx, 30H        ; (+48) int to char
    mov [solution], rcx

    mov rax, 1
    mov rdi, 1
    mov rsi, solution
    mov rdx, 1
    syscall
    jmp loopPrint
   
    mov rax, 1
mov rdi, 1
mov rsi, rbx
mov    rdx, 2
syscall


final:
; SYS_EXIT
mov rax, 60
mov rdi, 0
syscall