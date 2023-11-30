.data
	N : .word 0;#max lenght of inputs is 10000, will fit, beleive me
	Q : .word 0;
	arr : .space 40000;
	leftarr : .word 0;
	cl : .word 0;
	rightarr : .word 0;
	cr : .word 0;
.text 

#first create a member to access the arrays by indexing, without have to computing offset everytime

#preserves $a0 and $v0 uses $t8, $t9
printSpace:
	add $t8, $v0, $0;
	add $t9, $a0, $0;
    	li $v0 11;  # syscall 11: print a character based on its ASCII value
    	li $a0 10;  # ASCII value of a newline is "10"
    	syscall
	add $v0, $t8, $0;
	add $a0, $t9, $0;
	jr $ra;

#receives $v0 as the index and $t0 as the base address of the array
valAt:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sll $v0, $v0, 2
	add $v0, $t0, $v0
	lw $v0, 0($v0)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#read an integer from the feed onto $v0
readCall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 5;
	syscall;
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#print the integer in $a0
printCall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 1;
	syscall;
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#receives $v0 as the index, $a0 as the value, $t0 as the base address of array
storeAt:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sll $v0, $v0, 2
	add $v0, $t0, $v0
	sw $a0, 0($v0)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#receives $a0 as the number of values, $t0 as the base address of array
printArr:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0;
	printloop:
		beq $t1, $a0, endprint;
		add $v0, $t1, $0;
		#la $t0, arr; is already taken care of
		jal valAt;
			addi $sp, $sp, -4
			sw $a0, 0($sp)
				add $a0, $v0, $0;
				jal printCall;
			lw $a0, 0($sp)
			addi $sp, $sp, 4
		addi $t1, $t1, 1;
		j printloop;
	endprint:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#exit the program
exit:
	li $v0, 10;		
	syscall;

# void merge(int arr[], int left[], int leftSize, int right[], int rightSize) {
#     int i = 0, j = 0, k = 0;
#     while (i < leftSize && j < rightSize) {
#         if (left[i] <= right[j]) {
#             arr[k++] = left[i++];
#         } else {
#             arr[k++] = right[j++];
#         }
#     }
#     while (i < leftSize) {
#         arr[k++] = left[i++];
#     }
#     while (j < rightSize) {
#         arr[k++] = right[j++];
#     }
# }: https://favtutor.com/blogs/merge-sort-cpp

#will require the starting index on array, passed as $s6
merge:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
		li $t1, 0;#left index, i
		li $t2, 0;#right index, j
		add $t3, $s6, $0;#common array index
		la $s1, cl;
		lw $s1, 0($s1);#elements in the left array
		la $s2, cr;
		lw $s2, 0($s2);#elements in right array

	loopy:
		beq $t1, $s1, exhausted;
		beq $t2, $s2, exhausted;
			#let $t4 be left[i] and $t5 be right[j];
			#fetch left[i]
			la $t0, leftarr;
			lw $t0, 0($t0);
			add $v0, $t1, $0;
			jal valAt;
			add $t4, $v0, $0;
			#fetch right[j]
			la $t0, rightarr;
			lw $t0, 0($t0);
			add $v0, $t2, $0;
			jal valAt;
			add $t5, $v0, $0;
			#now do the branching
			slt $t0, $t5, $t4;#slt $t0, right[j]<left[i]
			beq $t0, $0, rightgeqleft;
				#arr[k++] = right[j++];
				#store $t5 in arr at index $t3
				la $t0, arr;
				add $a0, $t5, $0;
				add $v0, $t3, $0;
				jal storeAt;
				#increment $t3 and $t2
				addi $t3, $t3, 1;
				addi $t2, $t2, 1;
				#to next iter
				j rightleleft;
			rightgeqleft:
				#arr[k++] = left[i++];
				#store $t4 in arr at index $t3
				la $t0, arr;
				add $a0, $t4, $0;
				add $v0, $t3, $0;
				jal storeAt;
				#increment $t1 and $t3
				addi $t1, $t1, 1;
				addi $t3, $t3, 1;
				#to next iter
			rightleleft:
		j loopy;
		exhausted:

	lloopy:
		beq $t1, $s1, exhaustedleft;
			#fetch left[i]
			la $t0, leftarr;
			lw $t0, 0($t0);
			add $v0, $t1, $0;
			jal valAt;
			add $t4, $v0, $0;
				#arr[k++] = left[i++];
				la $t0, arr;
				add $a0, $t4, $0;
				add $v0, $t3, $0;
				jal storeAt;
				#increment $t1 and $t3
				addi $t1, $t1, 1;
				addi $t3, $t3, 1;
		j lloopy;
		exhaustedleft:
	rloopy:
		beq $t2, $s2, exhaustedright;
			#fetch right[j]
			la $t0, rightarr;
			lw $t0, 0($t0);
			add $v0, $t2, $0;
			jal valAt;
			add $t5, $v0, $0;
				#arr[k++] = right[j++];
				la $t0, arr;
				add $a0, $t5, $0;
				add $v0, $t3, $0;
				jal storeAt;
				#increment $t2 and $t3
				addi $t2, $t2, 1;
				addi $t3, $t3, 1;
		j rloopy;
		exhaustedright:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# // Recursive Merge Sort function to sort the array
# void recursiveMergeSort(int arr[], int left, int right) {
#     if (left >= right) {
#         return;
#     }
#     int mid = left + (right - left) / 2;
#     recursiveMergeSort(arr, left, mid);
#     recursiveMergeSort(arr, mid + 1, right);
#     int leftArr[mid - left + 1], rightArr[right - mid];
#     for (int i = 0; i < mid - left+1; i++) {
#         leftArr[i] = arr[left + i];
#     }
#     for (int i = 0; i < right - mid; i++) {
#         rightArr[i] = arr[mid + 1 + i];
#     }
#     merge(arr, leftArr, mid - left + 1, rightArr, right - mid);
# }: https://favtutor.com/blogs/merge-sort-cpp



#god forgive me, for what I am about to write!!
#will surely require the left and right indices
#pass $s6 and $s7 as left and right indices
recursiveMergeSort:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	slt $t0, $s6, $s7; #left<right
	beq $t0, $0, tixe;
	#calculate mid in $s5
	add $s5, $s6, $s7;
	li $t0, 2;
	div $s5, $t0;
	mflo $s5; #mflo stores the quotient of the above operation

	#now i have to recursivly apply rms on (left, mid) and (mid + 1, right)
	#its better to store the locals $s5, $s6 and $s7 onto the stack, the program looks cleaner at least. . .
	sw $s7, 0($sp);#store right
	sw $s5, 4($sp);#now store s5;
	sw $s6, 8($sp);#store left
		#for the first call, right is now mid, so
		add $s7, $s5, $0;
		jal recursiveMergeSort;
		lw $s7, 0($sp); #restore right
		lw $s5, 4($sp); #restore mid
		lw $s6, 8($sp); #restore left
		#for the second call, left is mid+1
		addi $s6, $s5, 1;
		jal recursiveMergeSort;
		lw $s7, 0($sp); #restore right
		lw $s5, 4($sp); #restore mid
		lw $s6, 8($sp); #restore left
		#i thought about this method after reading a bit of raw x86 code.
	add $sp, $sp, -20000;
	la $t0, leftarr;
	sw $sp, 0($t0);
	add $sp, $sp, -20000;
	la $t0, rightarr;
	sw $sp, 0($t0);
	#int leftArr[mid - left + 1], rightArr[right - mid];
	#for us the declarations are just length assignments.
	#cl = mid - left + 1 and cr = right - mid
	#r.w. s6=0, s5=2, s7=4;
	la $t0, cl;
	sub $s3, $0, $s6;#s3 = -left
	add $s3, $s3, $s5;#s3=-left+mid
	addi $s3, $s3, 1;#s3=mid-left+1 
	sw $s3, 0($t0); #cl is now mid-left+1 = s3(invariant) =3
	la $t0, cr;
	sub $s4, $s7, $s5;#t2 = right-mid
	sw $s4, 0($t0); #cr is now right-mid = s4(invariant) =2

	#i can use s2 as an iterator as merge is called at the end
	li $s2, 0;#iterator i
	#for (int i = 0; i < mid - left+1; i++)
	lefthand:
		beq $s2, $s3, leftfoot;
		#leftArr[i] = arr[left + i];
		#fetch arr[left+i]
		add $v0, $s6, $s2; #v0 = left + i
		la $t0, arr;
		jal valAt;
		#feed this value to leftarr
		add $a0, $v0, $0;#a0 = arr[left+i]
		add $v0, $s2, $0;
		la $t0, leftarr;
		lw $t0, 0($t0);
		jal storeAt;
		addi $s2, $s2, 1;
		j lefthand;
	leftfoot:
	#again
	li $s2, 0;#iterator i
	#for (int i = 0; i < right - mid; i++)
	addi $s5, $s5, 1;#we're using mid+1
	righthand:
		beq $s2, $s4, rightfoot;
		#rightArr[i] = arr[mid + 1 + i];
		#fetch arr[mid+1+i]
		add $v0, $s5, $s2;#v0 = mid+1+i
		la $t0, arr;
		jal valAt;
		#feed this value to rightarr
		add $a0, $v0, $0;#a0 = arr[mid+i+1]
		add $v0, $s2, $0;
		la $t0, rightarr;
		lw $t0, 0($t0);
		jal storeAt;#store a0 at rightarr[$v0]
		addi $s2, $s2, 1;
		j righthand;
	rightfoot:
	#merge(arr, leftArr, mid - left + 1, rightArr, right - mid);
	#$s6 is anyways the left index, will be passed as it is
	jal merge;
	add $sp, $sp, 40000;
	tixe:
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra


#searches only in arr, in complete bounds, for value $a3, returns $v0
binarySearch:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#use s6=0 for left, s7=n-1 for right and s5 for mid
	li $s6, 0;#left
	la $s7, N;#right
	lw $s7, ($s7);
	addi $s7, -1;

	loopdidyscoop:
		addi $t0, $s7, 1;#right+1
		beq $t0, $s6, trashcan;
			#calculate mid in $s5
			add $s5, $s6, $s7;
			li $t0, 2;
			div $s5, $t0;
			mflo $s5; #mflo stores the quotient of the above operation
			#fetch arr[mid]=$s4
			la $t0, arr;
			addi $v0, $s5, 0;
			jal valAt;
			add $s4, $v0, $0;
			add $v0, $s5, $0;
			#check if found
			beq $s4, $a3, exhit;
			
			#if not found
			slt $t0, $s4, $a3;
			beq $t0, $0, rightismidminus1;
				#left=mid+1
				#$s6=$s5+1
				addi $s6, $s5, 1;
				j leftismidplus1;
			rightismidminus1:
				#right=mid-1
				#$s7=$s5-1
				add $s7, $s5, $0;
				addi $s7, $s7, -1;
			leftismidplus1:
		j loopdidyscoop;

	trashcan: li $v0, -1;
	exhit:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	

main:
		#will fetch addresses in $to, always
		la $s0, N;
		jal readCall;
		sw $v0, 0($s0);

		add $s1, $v0, $0; 
		li $s0, 0;
	inputloop:
		beq $s0, $s1, gotInput; 
		jal readCall;
		add $a0, $v0, $0; #the value
		add $v0, $s0, $0; #the index
		la $t0, arr; #the array
		jal storeAt;
		addi $s0, 1;
		j inputloop;
		gotInput:
	
	li $s6, 0;
	la $s7, N;
	lw $s7, ($s7);
	sub $s7, $s7, 1;
	jal recursiveMergeSort;
	##the duplicate case!!!
	#for god's sake the elements are distinct!!

	#let the number of queries be Q = $s0
	
	#receives $a0 as the number of values, $t0 as the base address of array
	# la $a0, N;
	# lw $a0, 0($a0);
	# la $t0, arr;
	# jal printArr;

	jal readCall;
	add $s0, $v0, $0;
	li $t7, 0;
	queryloop:
		beq $t7, $s0, doneprocessing;
		jal readCall;
		add $a3, $v0, $0;
		jal binarySearch;
		add $a0, $v0, $0;
		jal printCall;
		jal printSpace;
		addi $t7, $t7, 1;
		j queryloop; 
	doneprocessing:
jal exit;

