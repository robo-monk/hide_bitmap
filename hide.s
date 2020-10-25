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
		.ascii "TTThhe answer for exam question 42 is not F."
		.asciz  "CCCCCCCCSSSSEE1111444400000000"

main:
	pushq %rbp
	movq %rsp, %rbp
	

	movq $msg, %rdi
	/*call rle_encode # encodes a message*/

	/*call rle_decode # decodeds and for now pritns the message */

	call generate_barcode
	/*movq $3071, %r15*/
	/*movq $0, %rsi*/
	/*movb barcode(%r15), %sil*/
	/*movq $digit, %rdi*/
	/*movq $0, %rax*/
	/*call printf*/

	call write_file



	movq %rbp, %rsp
	popq %rbp

	movq $0, %rdi
	call exit
