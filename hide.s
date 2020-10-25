.global main

.include "helpers/rle.s"
.include "helpers/barcode.s"
.include "helpers/bitmap.s"

.text 
	digit: .asciz "%d"
	char: .asciz "%c"
	pattern: .asciz "98C4S2E414480"

.data
	msg:	.ascii "CCCCCCCCSSSSEE1111444400000000"
		.ascii "The answer for exam question 42 is not F."
		.asciz  "CCCCCCCCSSSSEE1111444400000000"

main:
	pushq %rbp
	movq %rsp, %rbp
	

	call generate_barcode

	movq $msg, %rdi
	call rle_encode # encodes a message

	call encode_barcode
	call write_file



	movq %rbp, %rsp
	popq %rbp

	movq $0, %rdi
	call exit
