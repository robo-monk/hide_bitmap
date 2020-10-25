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
	

	call read_file
	call decode_barcode
	
	call rle_decode
	movq $13, %r15
	movq $0, %rsi
	movb encoded_string(%r15), %sil
	movq $char, %rdi
	movq $0, %rax
	call printf





	movq %rbp, %rsp
	popq %rbp

	movq $0, %rdi
	call exit
