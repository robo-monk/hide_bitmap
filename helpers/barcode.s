.data
	barcode: .skip 3072	# skip size of image
	/*barcode_row_fmt: .asciz "WWWWWWWWBBBBBBBBWWWWBBBBWWBBBWWR"*/
	barcode_row_fmt: .asciz "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWR"
	key: .skip 32


generate_barcode:
	pushq %rbp
	movq %rsp, %rbp
	

	movq $0, %r13 # cursor
	add_row:
		movq $barcode_row_fmt, %r14
		add_px:
			cmpb $0, (%r14)
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
