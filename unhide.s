.global main

.include "helpers/rle.s"
.include "helpers/barcode.s"
.include "helpers/bitmap.s"

.text 
	digit: .asciz "%d"
	char: .asciz "%c"
	pattern: .asciz "98C4S2E414480"

.data

main:
	pushq %rbp
	movq %rsp, %rbp
	

	call generate_barcode

	call read_file
	call decode_barcode
	
	/*movq $encoded_string, %rdi*/
	/*movq $0, %rax*/
	/*call printf*/
	call rle_decode
	
	movq %rbp, %rsp
	popq %rbp

	movq $0, %rdi
	call exit
