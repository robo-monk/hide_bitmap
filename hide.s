.global main

.include "helpers/rle.s"

.text 
	digit: .asciz "%d"
	char: .asciz "%c"
	pattern: .asciz "98C4S2E414480"

.data
	msg:	.ascii "CCCCCCCCSSSSEE1111444400000000"
		.ascii "TTThhe answer for exam question 42 is not F."
		.asciz  "CCCCCCCCSSSSEE1111444400000000"

main:
	pushq %rbp
	movq %rsp, %rbp
	

	movq $msg, %rdi
	call rle_encode # encodes a message

	call rle_decode # decodeds and for now pritns the message 



	movq %rbp, %rsp
	popq %rbp

	movq $0, %rdi
	call exit
