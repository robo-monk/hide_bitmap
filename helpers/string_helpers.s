.data
	ch_table: .asciz "0123456789%-"

# params: memory_andress, relative_byte 
# ret: the byte 
get_byte:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq 	%r11
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	
	movq $1, %rax			# 8 for 8 bits
	mulq %rsi			# 8bits * relative address stored in rsi
	addq %rax, %rdi			# go to the correct block
	movq (%rdi), %rax		# contents of calculated address to rax

	shl $56, %rax			# chop off address + times
	shr $56, %rax			# shift right to compensate for the previous chopping

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq    %r11
	popq	%rbp			# restore base pointer location 
	ret


count: # (string to count)
# ret how many bytes a string is

	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%rbx			# push contents of rbx
	pushq 	%r11

	movq $0, %rsi
	call find			# find the 0 ( strings are 0 terminated )

	movq $-1, %r11
	mulq %r11

	# epilogue
	popq    %r11
	popq	%rbx			# restore og rbx 
	popq	%rbp			# restore base pointer location 
	ret

find_first_not: # ( string andress to search, ascii)
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%r11
	pushq	%r12			
	pushq	%r13
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq %rdi, %r11			# move the og thing to search to r12
	movq $0, %r12			# start scanning from the first byte			
	movq %rsi, %r13			# mov ascii character to find

	not_get_next_byte:

		movq %r11, %rdi		# address for stream byte			
		movq %r12, %rsi		# byte count as displacement
		call get_byte

		incq %r12		# incremenet byte_count

		cmpq $0, %rax 		# string is over and we dindt find shit 
		je did_not_find

		cmpq %rax, %r13
		je not_get_next_byte

	not_return_index:
		movq %r12, %rax
		jmp find_epilogue

	not_find_epilogue:
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%r13
	popq	%r12
	popq	%r11
	popq	%rbp			# restore base pointer location 
	ret

# ascii: | % - 32 | 0 - 0 | d - 64 | u - 32 | s - 74 |
find: # ( string andress to search, ascii to search )
# rets index, or -length of string if no match

	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%r11
	pushq	%r12			
	pushq	%r13
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq %rdi, %r11			# move the og thing to search to r12
	movq $0, %r12			# start scanning from the first byte			
	movq %rsi, %r13			# mov ascii character to find

	get_next_byte:

		movq %r11, %rdi		# address for stream byte			
		movq %r12, %rsi		# byte count as displacement
		call get_byte

		incq %r12		# incremenet byte_count

		cmpq $0, %rax 		# string is over and we dindt find shit 
		je did_not_find

		cmpq %rax, %r13
		jne get_next_byte

	return_index:
		movq %r12, %rax
		jmp find_epilogue

	did_not_find:
		movq $-1, %rax
		mulq %r12		# return -%r12, aka -length of string

	find_epilogue:
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%r13
	popq	%r12
	popq	%r11
	popq	%rbp			# restore base pointer location 
	ret

