.data
	filename: .asciz "barcode.bmp"

write_file:
	movq $2, %rax	# we want sys_open
	movq $filename, %rdi
	movq $65, %rsi# we want write only & create ( 1 + 64 )
	movq $420, %rdx
	syscall
	ret
