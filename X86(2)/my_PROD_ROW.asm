        section .text
        global hadarmard_prod

hadarmard_prod:
        push rdi                       ; pointer to mat1
        push rsi                       ; scaler 1
        push rdx                       ; pointer to mat2
        push rcx                       ; scaler 2
        push r8                        ; pointer to mat3
        push r9                        ; number of rows/ columns of the matrix (n)
        push r11
	push r12
; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Compute hadarmard product of of mat1, mat2 and save the result in mat3
; ; Note : mat1, mat2 and mat3 here are not the same as one given in problem statement.
; ; They are just placeholders for any three matrices using this functionality.
; ; TODO - Fill your code here performing the hadarmard product in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){mat3[i][j] = mat1[i][j] * mat2[i][j];}}
	mov r11, 0; i
i_loop4:
	cmp r11, r9; exit id i==n
	je end_i4;
	mov r12, 0; r12=j 
j_loop4:
	cmp r12, r9; exit if j==n
	je end_j4; 
		push rdi; load the addersses onto the stack
		push rdx;
	mov rax, r9; move r9=n to rax
	mov rbx, r11; move r11 =i to rbx
	imul rax, rbx;n<=2048=2**11; rax=r9*r12
		push r12; push j onto the stack
	add r12, rax;r12=rax+r12; j = n*i+j
	mov rdi, [rdi+8*r12];rdi=mat1[i][j]
	mov rdx, [rdx+8*r12];rdx=mat2[i][j]
	imul rdi, rdx;
	mov [r8+8*r12], rdi;
		pop r12;
		pop rdx;
		pop rdi;
	add r12, 1; j++
	jmp j_loop4;
end_j4:
	add r11, 1; i++
	jmp i_loop4;
end_i4:
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
