;  rdi  rsi  rdx 
;  arr  n    moda

	global calcularModaASM
	section .text

calcularModaASM:
	xor	r8,	r8      ; mayor
	xor	r9, r9      ; cantidad
	xor r10, r10    ; num
    xor r11, r11    ; j
    xor r12, r12    ; arr[i]
    xor r13, r13    ; arr[j]

for_outer:    
    cmp	rsi, 0
    je	done
    xor r9, r9;
    mov r11, rsi
    dec r11
    mov r12, [rdi + rsi*4]
    
    for_inner:        
        cmp r11, 0
        je modificarMayor
        mov r13, [rdi + r11*4]        
        cmp r12, r13
        jne sonDiferentes
        inc r9
        sonDiferentes:
        dec r11
        jmp for_inner

    modificarMayor:
        cmp r9, r8
        jg existeCambio
        jmp proseguir

    existeCambio:
        mov r8, r9
        mov [rdx],	r12
        jmp proseguir

    proseguir:
        dec rsi
        jmp for_outer

done:
	ret