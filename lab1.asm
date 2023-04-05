; nasm -f elf64 lab1.asm -o lab1.o
; ld lab1.o -o lab1
; ./lab1

section .data
	
    firstMsg db "Ingrese un numero: "
	lenf equ $ - firstMsg

    secondMsg db "La solucion es: "
    lens equ $ - secondMsg

    number db 0
    solution db 0

section .text
	global _start

_start:

    ; Imprime "Ingrese un numero: "
    mov rax, 1
	mov rdi, 1
	mov rsi, firstMsg
	mov rdx, lenf
	syscall

    ; Lee number
    mov rax, 0
	mov rdi, 0
	mov rsi, number
	mov rdx, 1
	syscall

    ; String to number
    mov rcx, [number]
    sub rcx, 30H

summation:

    ; while (i>0)
    cmp rcx, 0
    je printSolution

    ; Multiplicamos i*i
    mov rax, rcx
    mul rcx
    
    ; Sumamos i^2
    add [solution], rax

    ; i--;
    dec rcx
    jmp summation

printSolution:

    ; Imprime "La solucion es: "
    mov rax, 1
	mov rdi, 1
	mov rsi, secondMsg
	mov rdx, lens
	syscall

test:
    
    ; Pushea en la pila el resultado
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

final:                  ; sale del programa de forma exitosa

; SYS_EXIT
	mov rax, 60
	mov rdi, 0
	syscall