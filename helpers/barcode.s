.data
	barcode: .skip 3072	# skip size of image
	barcode_row_fmt: .asciz "WWWWWWWWBBBBBBBBWWWWBBBBWWBBBWWRE" # basically the encryption key
	/*barcode_row_fmt: .asciz "BRWWWRBBBWBBWBBRBWWRBRBBWBBRRBWRE" # basically the encryption key*/
	/*barcode_row_fmt: .asciz "BBBRWRWWRWWWRBBBWBWWWWRBWRRRRWRRE" # basically the encryption key*/
	key: .skip 32
	output: .skip 3072


generate_barcode:
	pushq %rbp
	movq %rsp, %rbp
	

	movq $0, %r13 # cursor
	add_row:
		movq $barcode_row_fmt, %r14
		add_px:
			cmpb $'E', (%r14)
			je add_row


			cmpb $'W', (%r14)
			je add_white

			cmpb $'B', (%r14)
			je add_black

			cmpb $'R', (%r14)
			je add_red		
			add_white:
				movb $255, barcode(%r13)
				incq %r13
				movb $255, barcode(%r13)
				incq %r13
				movb $255, barcode(%r13)
				incq %r13
				jmp done_add
			add_red:
				movb $255, barcode(%r13)
				incq %r13
				movb $70, barcode(%r13)
				incq %r13
				movb $70, barcode(%r13)
				incq %r13
				jmp done_add

			add_black:
				movb $0, barcode(%r13)
				incq %r13
				movb $0, barcode(%r13)
				incq %r13
				movb $0, barcode(%r13)
				incq %r13

			done_add:
			incq %r14
			cmpq $3072, %r13
			jl add_px


	movq %rbp, %rsp
	popq %rbp
	ret
	
encode_barcode:
	pushq %rbp	
	movq %rsp, %rbp
	
	movq $0, %r15
	enc_px:
		movb encoded_string(%r15), %r13b
		cmpb $0, %r13b
		je enc_barcode_end

		movb barcode(%r15), %r14b

		xorb %r13b, %r14b
		movb %r14b, barcode(%r15)

		incq %r15
		cmpq $3072, %r15
		jl enc_px

	enc_barcode_end:	
	movq %rbp, %rsp
	popq %rbp
	ret


decode_barcode:
	pushq %rbp	
	movq %rsp, %rbp
	
	movq $54, %r15
	movq $0, %r11
	denc_px:
		movb dirty_barcode(%r15), %r13b

		movb barcode(%r11), %r14b

		xorb %r13b, %r14b

		movb %r14b, encoded_string(%r11) # remove dirty barcode's offset

		incq %r15
		incq %r11
		cmpq $FILESIZE, %r15
		jl denc_px

	denc_barcode_end:	
	movq %rbp, %rsp
	popq %rbp
	ret


	/*movq $0, %rsi*/
	/*movb dirty_barcode(%r15), %sil*/
	/*movq $digit, %rdi*/
	/*movq $0, %rax*/
	/*call printf*/




