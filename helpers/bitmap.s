.equ FILESIZE, 3126 # + data length

.data
	filename: .asciz "barcode.bmp"
	file_header: 	.ascii "B", "M"	# file header 
			.long FILESIZE 	# file size
			.long 0x00000000# reserved field
			.long 1		# offset of pixel data
			# 14 bytes long

	bmp_header: 	.long 40	# file header 
			.long 32	# width
			.long 32	# height
			.word 1 	# reserved field
			.word 24	# bits per pixel
			.long 0		# compression
			.long 2835	# hz resolution (px/m)
			.long 2835	# vl resolution (px/m)
			.long 0		# color pallete
			.long 0		# important colors
			# 40 bytes long
			# bs 54 bytes long
	white_px: .byte 255, 255, 255
	red_px: .byte 255, 70, 70
	black_px: .byte 0, 0, 0

	dirty_barcode: .skip FILESIZE	# skip size of image

/*movq $3071, %r15*/
/*movq $0, %rsi*/
/*movb barcode(%r15), %sil*/
/*movq $digit, %rdi*/
/*movq $0, %rax*/
/*call printf*/
write_file:
# writes file & prepares barcode
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%r15
	movq	%rsp, %rbp		# copy stack pointer value to base pointer


	# create a new file with writing permissions
	movq $2, %rax	# we want sys_open
	movq $filename, %rdi
	movq $65, %rsi	# we want write only & create ( 1 + 64 )
	movq $420, %rdx
	syscall
	
	movq %rax, %r15 # save file descriptor to r15

	# use file descriptor from sys open as write out arg
	movq %r15, %rdi
	movq $1, %rax	# we want sys write
	movq $file_header, %rsi
	movq $14, %rdx	# write 14 bytes
	syscall

	movq %r15, %rdi
	movq $1, %rax	# we want sys write
	movq $bmp_header, %rsi
	movq $40, %rdx	# write 40 bytes
	syscall

	# write pixel data
	movq $0, %r13
	write_barcode:
		movq %r15, %rdi
		movq $1, %rax		# we want sys write
		movq $barcode, %rsi
		movq $3072, %rdx	# write all bytes
		syscall
	
	movq $3, %rax
	popq %rdi

	movq %rbp, %rsp
	popq %r15
	popq %rbp
	ret

read_file:
# reads file & prepares barcode
	pushq %rbp
	pushq %r15
	movq %rsp, %rbp
	
	movq $2, %rax# we want sys open
	movq $filename, %rdi
	movq $0, %rsi # we want read only
	movq $420, %rdx
	syscall
	movq %rax, %r15 # file descriptor
	read_barcode:
		movq %r15, %rdi
		movq $0, %rax		# we want sys read
		movq $dirty_barcode, %rsi
		movq $FILESIZE, %rdx	# write all bytes
		syscall

	movq $3, %rax # close file to be neat
	popq %rdi


	movq %rbp, %rsp
	popq %r15
	popq %rbp
	ret




