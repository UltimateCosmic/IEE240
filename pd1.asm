; nasm -f elf64 pd1.asm -o pd1.o
; ld pd1.o -o pd1
; ./pd1

section .data

    ; Mensajes
    firstMsg db "Peso de las practicas: "
    lenf equ $ - firstMsg
    secondMsg db "Peso de los laboratorios: "
    lens equ $ - secondMsg
    thirdMsg db "Peso del examen parcial: "
    lent equ $ - thirdMsg
    fourthMsg db "Peso del examen final: "
    lenfo equ $ - fourthMsg
    fifthMsg db "Nota final calculada: "
    lenfi equ $ - fifthMsg

    ; Arreglos
    arregloPesos dq 0, 0, 0, 0
    arregloNotas dd 15, 18, 12, 15

    ; Pesos
    pesoPractica dq 0
    pesoLaboratorio dq 0
    pesoExamenParcial dq 0
    pesoExamenFinal dq 0

    ; Extras
    solution dq 0
    char dq 0

section .text
    global _start

_start:

    ; Leer peso de practicas
    mov rax, 1
    mov rdi, 1
    mov rsi, firstMsg
    mov rdx, lenf
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, pesoPractica
    mov rdx, 1
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, char
    mov rdx, 1
    syscall

    ; Leer peso de laboratorios
    mov rax, 1
    mov rdi, 1
    mov rsi, secondMsg
    mov rdx, lens
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, pesoLaboratorio
    mov rdx, 1
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, char
    mov rdx, 1
    syscall

    ; Leer peso de examen parcial
    mov rax, 1
    mov rdi, 1
    mov rsi, thirdMsg
    mov rdx, lent
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, pesoExamenParcial
    mov rdx, 1
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, char
    mov rdx, 1
    syscall

    ; Leer peso de examen final
    mov rax, 1
    mov rdi, 1
    mov rsi, fourthMsg
    mov rdx, lenfo
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, pesoExamenFinal
    mov rdx, 1
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, char
    mov rdx, 1
    syscall

    ; Imprimir mensaje de nota final
    mov rax, 1
    mov rdi, 1
    mov rsi, fifthMsg
    mov rdx, lenfi
    syscall

    ; Limpieza de registros
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

inicio:
    
    ; Se llena el arreglo de Pesos
    mov rcx, [pesoPractica]
    sub rcx, 30H
    mov [arregloPesos], rcx
    mov rcx, [pesoLaboratorio]
    sub rcx, 30H
    mov [arregloPesos + 8], rcx
    mov rcx, [pesoExamenParcial]
    sub rcx, 30H
    mov [arregloPesos + 16], rcx
    mov rcx, [pesoExamenFinal]
    sub rcx, 30H
    mov [arregloPesos + 24], rcx

    ; Se inicializan las variables
    mov r8, 0   ; int sumaProm = 0;
    mov r9, 0   ; int sumaPesos = 0;
    mov rcx, 0  ; int cantEval = 0;

bucle:
    cmp rcx, 4
    jge division
    mov rax, [arregloPesos + 8 * rcx]
    add r9, rax
    mov ebx, [arregloNotas + 4 * rcx]
    mul rbx
    add r8, rax
    inc rcx
    jmp bucle

division:
    mov rax, r8
    div r9
    xor rdx, rdx

impresion:
    cmp rax, 10
    jl final
    mov rcx, 10
    div rcx
    mov r10, rdx
    add rax, 30H
    mov [solution], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, solution
    mov rdx, 1
    syscall
    mov rax, r10

final:
    add rax, 30H
    mov [solution], rax
    mov rax, 1
    mov rdi, 1
    mov rsi, solution
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    mov rdi, 0
    syscall