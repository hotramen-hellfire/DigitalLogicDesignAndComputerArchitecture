        section .text
        global lin_comb

lin_comb:
        push rdi                       ; pointer to mat1
        push rsi                       ; scaler 1
        push rdx                       ; pointer to mat2
        push rcx                       ; scaler 2
        push r8                        ; pointer to mat3
        push r9                        ; number of rows/ columns of the matrix (n)
        push r11		       ; let it be i
	push r12		       ; let it be j
; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Perform matrix linear combination of mat1, mat2 and save result in mat3
; ; Note : mat1, mat2 and mat3 here are not the same as one given in problem statement.
; ; They are just placeholders for any three matrices using this functionality.
; ; TODO - Fill your code here performing the matrix linear combination in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){mat3[j][i] = s1*mat1[j][i] + s2*mat2[j][i];}}
	mov r11, 0; i
i_loop1:
	cmp r11, r9;
	je end_i1;
	mov r12, 0; j 
j_loop1:
	cmp r12, r9;
	je end_j1;
		push rdi;
		push rdx;
	mov rax, r9;
	mov rbx, r12;
	imul rax, rbx;n<=2048=2**11; rax = r9*r12
		push r11;
	add r11, rax;r11=r9*r12+r11
	mov rdi, [rdi+8*r11];rdi=mat1[j][i]
	mov rdx, [rdx+8*r11];rdx=mat2[j][i]
	imul rdi, rsi;
	imul rdx, rcx;
	add rdi, rdx;
	mov [r8+8*r11], rdi;
		pop r11;
		pop rdx;
		pop rdi;
	add r12, 1; j++
	jmp j_loop1;
end_j1:
	add r11, 1; i++
	jmp i_loop1;
end_i1:
; ; End of code to be filled
	pop r12
	pop r11
        pop r9
        pop r8
        pop rcx
        pop rdx
        pop rsi
        pop rdi
        ret
