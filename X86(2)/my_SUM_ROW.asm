        section .text
        global  alt_sum

alt_sum:
        push rdi                       ; pointer to mat
        push rdx                       ; number of rows/ columns of the matrix (n)
        push r11  		       ;i
	push r12		       ;j
	push r13		       ;the parity
	push r9
; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Perform matrix alternate summation of elements in matrix and return the sum

; ; TODO - Fill your code here performing the matrix alternate summation in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){sum += (-1)^(i+j)*mat1[i][j];}}
	mov r9, rdx; r9=n
	mov r11, 0; i
	mov rdx, 0;accumulator
i_loop5:
	cmp r11, r9;
	je end_i5;
	mov r12, 0; j 
j_loop5:
	cmp r12, r9;
	je end_j5;
		push rdi
	mov rax, r9;
	mov rbx, r11;
	imul rax, rbx;n<=2048=2**11
		push r12
	add r12, rax;
	mov rdi, [rdi+8*r12];rdi=mat[i][j]
		pop r12
	mov r13, r12;
	add r13, r11;r13=i+j
	and r13, 0x1;
	cmp r13, 0x0;
	je parity0;
	mov r13, -1;
	imul rdi, r13;
parity0:
	add rdx, rdi;accumulation step
		pop rdi;
	add r12, 1; j++
	jmp j_loop5;
end_j5:
	add r11, 1; i++
	jmp i_loop5;
end_i5:
	mov rax, rdx; return value
; ; End of code to be filled
        pop r9
	pop r13
	pop r12
	pop r11
        pop rdx
        pop rdi
        ret
