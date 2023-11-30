extern realloc
extern free

section .text
global init_v
global delete_v
global resize_v
global get_element_v
global push_v
global pop_v
global size_v

init_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
	push rdi
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
	;assume the address for the base of data type is in rdi
		mov qword [rdi], 0
		mov qword [rdi+8], 0
		mov qword [rdi+16], 0x0
        pop rdi
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

delete_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
	push rdi
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
	; the pointer to the vector object is given as an input
	; thus rdi has the base of the object
		mov rax, rdi; rax now has the object base
		; first lets dealloc with realloc
		;mov [rax], 0;
		;mov [rax+8], 0; however these two are redundant
		mov rsi, 0; number of bytes
		mov rdi, [rax+16]; initial ptr
		call realloc
		; now the programmer is free to deallocate the 24bytes she lent to the vector
	pop rdi
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

resize_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
	push rdi
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
        ; Input is given in rsi/ which points to vector object base #no ist rdi, 2nd is rsi
	; for realloc rsi is the number of bytes
	; and rdi is the initial base
	; the new base is returned in rax after the syscall
		push rsi
		mov rax, rdi
		mov rbx, rax;
		mov rdi, [rax+8]; rdi = size0
		lea rdi, [2*rdi+1]; rdi = 2*rdi+1 = 2*size0+1
		lea rdi, [8*rdi]; rdi = 8*(2*size0+1)
		mov [rax], rdi; buff_size = 8*(2*size0+1)
		mov rsi, [rax]; rsi = number of bytes for realloc
		mov rdi, [rax+16]; rdi = initial ptr
		call realloc; call realloc
		mov [rbx+16], rax; update ptr; done
		pop rsi
	; void return
	pop rdi
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

get_element_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
        ; rdi is the first argument, rsi is the second. refer(https://cs61.seas.harvard.edu/site/2020/Asm/)
	; rdi is thus the base of vector object, rsi is the simple index
		push rdi
		lea rsi, [rsi*8]
		; rsi is now the address offset
		; now load the base of the store buffer
		mov rdi, [rdi+16]
		add rdi, rsi ; base + the offset
		mov rax, rdi ; return the base of the quad
		pop rdi
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

push_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
	push rdi
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
        ; we first need to check if the buffer was full, and if it was we'll resize
	; rdi is the provided pointer to the vector object and rsi is the element to be inserted
		push rsi ; push the element we'll restore it when we require
		mov rax, rdi ; rax is the base of the object now
		; check if 8*[rax+8] == [rax]
		; if yes then call resize; else continue
		mov rbx, [rax+8]; this now has the size
		lea rbx, [rbx*8]; rbx = 8*size
		; we need to check if 8*size==buff_size
		mov rcx, [rax]
		cmp rbx, rcx;rcx now has the buffersize
		je get_more;#changed
		jmp enough_space;
		get_more:
			push rax;		
			mov rdi, rax;
			call resize_v; void return, updates the bp of buffer by itself
			pop rax;
		enough_space:
			; now we've ensured we have enuf space at the back or to be more precise, we're using space that is allocated by the os to us
			; for example the size is now 4, we need to store at (4*8)(ptr) and then increase the size to be 5
			mov rbx, [rax+8]; rbx = size0
			add qword [rax+8], 1; size = size0+1
			lea rbx, [rbx*8]; rbx = 8*size0 < buff_size
			mov rax, [rax+16]; rax = ptr
			pop rsi; get the element that is to be stored
			mov [rax + rbx], rsi; store and done, void return
	pop rdi
	pop r15		
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

pop_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
	push rdi
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
        ; the function is quad return
	; the input is pointer to the vector object, rdi
	; first decrement the size by one, and the access the quad at address ptr+8*size
		mov rax, rdi
		add qword [rax+8], -1; size = size0-1
		mov rbx, [rax+16]; rbx is now the base
		mov rax, [rax+8];rax=size0-1
		lea rax, [rax*8];
		mov rax, [rax + rbx]; the return value
	pop rdi
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret

size_v:
        push rbp
        mov rbp, rsp
        push rax
        push rbx
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
        ; ENTER YOUR CODE HERE, DO NOT MODIFY EXTERNAL CODE
		mov rax, [rdi+8];	
	pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret
