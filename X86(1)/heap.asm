extern init_v
extern pop_v
extern push_v
extern size_v
extern get_element_v
extern resize_v
extern delete_v

section .text
global init_h
global delete_h
global size_h
global insert_h
global get_max
global pop_max
global heapify
global heapsort

init_h:
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
	; we'll initialize a vector object in the given space
	; rdi is the base of the heap object, which will coincide with the base of the vector object
	; initializing a vector at the base
		call init_v;
	; we're done for now, the size of the heap is same as the size of the vector
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

delete_h:
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
        ; we essentialy have to delete the vector, at the same base
		call delete_v;
	; done
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


size_h:
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
        ; size is the size of the vector
		mov rax, [rdi+8]
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


insert_h:
        push rbp
        mov rbp, rsp
        push rax; didn't get this
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
       	; first insert the element into the vector
		; rdi is the base of both the vector and the heap
		; rsi has the element to be inserted
		; do not change rdi throughout
		push rdi;
		mov rdx, rsi;
		call push_v
		pop rdi;
		; now we will do the swapping
		; index of this element is rax = size-1
		mov rax, [rdi+8]; rax = size
		add rax, -1; rax =index of the element
		mov r8, rax; r8 will store the index of the element, current
	loopie:
		cmp r8, $0;
		je inserted;
		; calculate the parent index in rbx = floor((r8-1)*0.5)
		mov rbx, r8;
		sub rbx, 1;
		shr rbx, 1; this is division by two
		; now rbx has the address of the parent
		; we need the value of the element at that address in our vector
		; rdi is still the base of the vector/ heap, we need to put the index of element we need into rsi
		push rdi;
		mov rsi, rbx; rsi has the index of parent =  rbx
		call get_element_v;
		mov rcx, [rax];
		pop rdi;
		; if the value in rcx is smaller we swap and loop otherwise we break to inserted
		cmp rdx, rcx;
		; we need to swap if rdx, rcx
		jbe inserted; i.e. if rdx is less than or equal to rcx it will jump
		; now we need to swap and at the end we need to put
	theswaproutine:
		; here rdi is base of the vector object and the heap too
		; r8 is the index of the element inserted
		; rbx is the index of its parent
		; rcx is the value of the parent(u)
		; rdx is the value of the element(u)
		; lets convert these to addresses
			push rbx;for the next iter
		mov rsi, r8;
		call get_element_v;
		mov r8, rax; r8 now has the address of the newly inserted element
			pop rbx;
			push rbx;
		mov rsi, rbx;
		call get_element_v;
		mov rbx, rax; rbx now has the address of the parent
		; place the values
		mov [r8], rcx;
		mov [rbx], rdx;
			pop r8; pop the index of the parent into r8
		jmp loopie;
	inserted:
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

get_max:
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
        ; return the value at zeroth index
	; rdi is the base of both the vector and the heap so
		mov rsi, 0;
		call get_element_v; returns the address of the rsi^{th} element
		mov rax, [rax]; 
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

pop_max:
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
        ; receives the base of the heap and the coincident base of the vector in rdi
		; we firstly have to get the last element then place it at the top and pop
		; we can simply use the pop_v function, it return the value of the last element too
		; rdi already has the base of the vector
		call pop_v; will return the value of popped in rax
		; place this at the zeroth index
		mov r8, rax; r8 has the popped value
		mov rsi, 0;
		call get_element_v; returns the address of the first element, or to say [rdi+16]
		mov rsi, [rax];
			push rsi; characteristic indent to prevent stackoverflows
		; put rbx at the address rax
		mov [rax], r8;
		; at this point
		; the top of the heap is r8, the heap has been shortend by the loss of the maximum element, which is pushed onto the stack
		; and let its index be rbx=0;
		mov rbx, 0;
	loopit:		
		; the left node has the index 2*i+1
		; the right node has the index 2*i+2
		; we'll check if the left doesn't exists and then if the right exists
		; again
		; rbx is the index of the bad root
		; r8 is the value of the bad root
		; let rcx and rdx be left and right indices
		; r9 and r10 be left and right values
		; calculate and check left child
		mov rcx, rbx;
		lea rcx, [rcx*2+1]; rcx = 2*r8+1
		; if size>=rcx, bad root is a leaf
		cmp [rdi+8], rcx;
		jbe this_is_done;
		; if we're here it means the left child exists
		; if only the left child exists there's only one operation left and we are done after that
		; firstly lets check for the right child
		mov rdx, rbx;
		lea rdx, [rdx*2+2]; rdx = 2*r8+1
		; if size>=rdx, no right child is present
		cmp [rdi+8], rdx;
		jbe no_right_child;
		;now we calculate for the point where both left and right children are present
		; firstly load the values of left and right elements into r9 and r10
		mov rsi, rcx;
		call get_element_v; returns the address of the left element in rax
		mov r9, [rax];	
		mov rsi, rdx;
		call get_element_v;
		mov r10, [rax];
		; now we have the left and right values in r9 and r10 respectively
		; if r8>=r9 and r8>=r10 we're done
		cmp r8, r9;
		jae r8gter9;
		; if we're here r8<r9; now we'll check the symmetric
		cmp r8, r10;
		jae r8gter10;
		; if we're here element is smaller than both left and right
		; now if left<right swap with right	
		cmp r10, r9;
		ja swap_with_right;
		; else swap with left
		ja swap_with_left;
	r8gter10:
		;write here for element<left but greater than right
		; simply swap with left
		jmp swap_with_left;
	r8gter9:
		;firstly check if r8>=r10, if yes then we're done
		cmp r8, r10;
		jae this_is_done;
		;write here for element>=left but smaller than right		
		jmp swap_with_right;
		;i.e. swap with right
	no_right_child:
		; surely rbx is the index of the bad node and rcx is the left index
		; r8 is the value of the bad root
		; first get the value stored in left into r9
		mov rsi, rcx;
		call get_element_v; returns the address of left in rax
		mov r9, [rax];
		; if r9>r8, we swap
		cmp r9, r8;
		ja swap_with_left;
		jmp this_is_done;
	swap_with_right:
		; load the addresses of the badroot and the right child
		; firstly push the index left child for next iteration
			push rdx;
		mov rsi, rbx;
		call get_element_v;returns the address of the bad node element
		mov rbx, rax;
		mov rsi, rdx;
		call get_element_v;returns the address of the right element;
		mov rdx, rax;
		; now we do the swap;
		mov [rbx], r10;
		mov [rdx], r8;
		; now we update the index of the bad root and loop
			pop rbx; pop into rbx
		jmp loopit;
	swap_with_left:
		; load the addresses of the badroot and the left child
		; firstly push the index left child for next iteration
			push rcx;
		mov rsi, rbx;
		call get_element_v;returns the address of the bad node element
		mov rbx, rax;
		mov rsi, rcx;
		call get_element_v;returns the address of the left element;
		mov rcx, rax;
		; now we do the swap;
		mov [rbx], r9;
		mov [rcx], r8;
		; now we update the index of the bad root and loop
			pop rbx; pop into rbx
		jmp loopit;
	this_is_done:
		pop rax; pop the value of the max element stored to rax
	
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


; I do not have the drive to do the optional stuff :)
heapify:
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

heapsort:
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
