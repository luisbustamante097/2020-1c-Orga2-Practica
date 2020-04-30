	.file	"Ejercicio10.c"
	.text
	.comm	globalNoInit,8,8
	.globl	globalInit
	.data
	.align 8
	.type	globalInit, @object
	.size	globalInit, 8
globalInit:
	.quad	31416
	.globl	globalInitConst
	.section	.rodata
	.align 8
	.type	globalInitConst, @object
	.size	globalInitConst, 8
globalInitConst:
	.quad	14142
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	$27182, -8(%rbp)
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
