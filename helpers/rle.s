.include "helpers/string_helpers.s"
.data 
	encoded_string: .skip 5000

	
rle_encode: # (string andress)
	    # ret encoded string andress
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%r15
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	
	movq $0, %r13 # byte counter
	/*movq $'[', encoded_string(%r13)*/
	/*addq $8, %r13*/
	/*movq $']', encoded_string(%r13)*/
	encode_bytes:
		/*[>movq (%rdi), %r12 	# grab<]*/
		movq $0, %r15
		movb (%rdi), %r15b
		
		movq %r15, %rsi
		call find_first_not
		cmpq $0, %rax
		jl rle_encode_end

		decq %rax
		movq %rax, encoded_string(%r13)
		incq %r13

		movq %r15, encoded_string(%r13)

		/*addq %rax, %rdi*/

		incq %r13
		jmp encode_bytes


	/*movq encoded, %rax*/

	rle_encode_end:
	incq %r13
	movq $0, encoded_string(%r13)

	movq %rbp, %rax # return the andress of the stack andresses we used
	movq %rbp, %rsp
	popq %r15
	popq %rbp
	ret

rle_decode: # (string andress)
	    # ret decoded string andress

	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%r15
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	
	movq $12, %r15
	movq $0, %r14
	movq $0, %r12

	movq $0, %rsi
	decode_bytes:
		movq %r15, %r12
		addq $12, %r12
		cmpq $0, encoded_string(%r12)
		
		je rle_decode_end

		movb encoded_string(%r15), %r14b 	# grab times
		incq %r15
		
		process_char:
			movb encoded_string(%r15), %sil 	# grab char
			movq $char, %rdi
			movq $0, %rax
			call printf

			decq %r14
			cmpq $0, %r14
			jg process_char

		incq %r15
		jmp decode_bytes

	rle_decode_end:
	movq %rbp, %rax # return the andress of the stack andresses we used
	movq %rbp, %rsp
	popq %r15
	popq %rbp
	ret

