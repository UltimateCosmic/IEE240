global asmModa

section .text

asmModa:

; asmNorm(float* v, int N) -> float moda
; v -> rdi, N -> rsi, xmm0 -> moda

    cmp rsi, 0
    je done

    mov rax, rsi            ; N_COPIA = N
    mov rbx, 0              ; MAX_CANT_REPETICIONES = 0
    mov rcx, rdi            ; V_COPIA = v

    outer_loop:
        movss xmm1, [rdi]   ; NUMERO_1 = v[i]
        mov rdx, 0          ; CANT_REPETICIONES = 0
        mov r8, rax         ; N_INTERNO = N_COPIA
        mov r9, rcx         ; V_INTERNO = V_COPIA

        inner_loop:
            movss xmm2, [r9] ; NUMERO_2 = v[j]
            
            ucomiss xmm1, xmm2
            jne end_inner_loop

            inc rdx

            end_inner_loop:
            add r9, 4
            dec r8
            jnz inner_loop

        cmp rbx, rdx
        jg end_outer_loop

        mov rbx, rdx
        movss xmm0, xmm1

        end_outer_loop:
        add rdi, 4
        dec rsi
        jnz outer_loop
done:
    ret