	.file	"C_sharedLib.c"
	.text
	.globl	row
	.bss
	.align 32
	.type	row, @object
	.size	row, 128
row:
	.zero	128
	.globl	column
	.align 32
	.type	column, @object
	.size	column, 128
column:
	.zero	128
	.globl	keys
	.align 32
	.type	keys, @object
	.size	keys, 128
keys:
	.zero	128
	.section	.rodata
.LC0:
	.string	"ENCRYPTION STARTED..."
.LC1:
	.string	"DECRYPTION STARTED..."
.LC2:
	.string	"idk wats wrong"
.LC3:
	.string	"ID: %d Fin\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -40(%rbp)
	movq	%rcx, -56(%rbp)
	movq	%r8, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-64(%rbp), %rax
	movl	$128, %edx
	movq	%rax, %rsi
	movq	keys@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	memcpy@PLT
	cmpl	$0, -40(%rbp)
	jne	.L2
	cmpl	$0, -36(%rbp)
	jne	.L3
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L3:
	movq	$0, -8(%rbp)
	jmp	.L4
.L5:
#APP
# 32 "C_sharedLib.c" 1
	pushfq
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq %rdi
	pushq %rbp
	pushq %rsp
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	xorq    %r11,%r11
	leaq    keys(%rip),%r13
	movq    -24(%rbp),%r14
	leaq    column(%rip),%r15
.Round42:
	movl    (%r13,%r11,4),%ecx
	xorq    %r8,%r8
.RowJump42:
	movl    (%r14,%r8,4),%eax
	rorl    %cl,%eax
	rorq    $7,%rcx
	movl    %eax,(%r14,%r8,4)
	incl    %r8d
	movl    (%r14,%r8,4),%eax
	roll    %cl,%eax
	rorq    $3,%rcx
	movl    %eax,(%r14,%r8,4)
	incl    %r8d
	cmp     $32,%r8
	jne    .RowJump42
	xorq    %r9,%r9
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14)
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14,%r11,4)
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14,%r11,4)
	.RowOuter42:
	xorq    %r8,%r8
.RowInner42:
	bt      %r9d,(%r14,%r8,4)
	jnc    .RowReset42
	bts     %r8d,%r10d
	jmp    .RowExit42
.RowReset42:
	btr     %r8d,%r10d
.RowExit42:
	incl    %r8d
	cmp     $32,%r8d
	jne    .RowInner42
	movl    %r10d,(%r15,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .RowOuter42
	xorq    %r8,%r8
incl    %r11d
	movl    (%r13,%r11,4),%ecx
	.ColJump42:
	movl    (%r15,%r8,4),%eax
	rorl    %cl,%eax
	rorq    $9,%rcx
	movl    %eax,(%r15,%r8,4)
	incl    %r8d
	movl    (%r15,%r8,4),%eax
	roll    %cl,%eax
	rorq    $11,%rcx
	movl    %eax,(%r15,%r8,4)
	incl    %r8d
	cmp     $32,%r8
	jne    .ColJump42
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15)
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15,%r11,4)
	incl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15,%r11,4)
	incl    %r11d
	cmp     $32,%r11
	je     .ExitRound42
	xorq    %r9,%r9
.ColOuter42:
	xorq    %r8,%r8
.ColInner42:
	bt      %r9,(%r15,%r8,4)
	jnc    .ColReset42
	bts     %r8d,%r10d
	jmp    .ColExit42
.ColReset42:
	btr     %r8d,%r10d
.ColExit42:
	incl    %r8d
	cmp     $32,%r8d
	jne    .ColInner42
	movl    %r10d,(%r14,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .ColOuter42
	jmp    .Round42
.ExitRound42:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rsp
	popq %rbp
	popq %rdi
	popq %rsi
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax
	popfq
	
# 0 "" 2
#NO_APP
	movq	-32(%rbp), %rax
	movl	$128, %edx
	movq	column@GOTPCREL(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movq	-32(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -24(%rbp)
	addq	$1, -8(%rbp)
.L4:
	movq	-8(%rbp), %rax
	cmpq	-48(%rbp), %rax
	jb	.L5
	jmp	.L6
.L2:
	cmpl	$0, -40(%rbp)
	jg	.L7
	cmpl	$0, -40(%rbp)
	je	.L8
.L7:
	cmpl	$0, -36(%rbp)
	jne	.L9
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L9:
	movq	$0, -16(%rbp)
	jmp	.L10
.L11:
#APP
# 233 "C_sharedLib.c" 1
	pushfq
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq %rdi
	pushq %rbp
	pushq %rsp
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	movq    $32,%r11
	leaq    keys(%rip),%r13
	leaq    row(%rip),%r14
	movq    -32(%rbp),%r15
.Round86:
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15,%r11,4)
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15,%r11,4)
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r15)
	xorq    %r8,%r8
decl    %r11d
	movl    (%r13,%r11,4),%ecx
	.ColJump86:
	movl    (%r15,%r8,4),%eax
	roll    %cl,%eax
	rorq    $9,%rcx
	movl    %eax,(%r15,%r8,4)
	incl    %r8d
	movl    (%r15,%r8,4),%eax
	rorl    %cl,%eax
	rorq    $11,%rcx
	movl    %eax,(%r15,%r8,4)
	incl    %r8d
	cmp     $32,%r8
	jne    .ColJump86
	xorq    %r9,%r9
.ColOuter86:
	xorq    %r8,%r8
.ColInner86:
	bt      %r9,(%r15,%r8,4)
	jnc    .ColReset86
	bts     %r8d,%r10d
	jmp    .ColExit86
.ColReset86:
	btr     %r8d,%r10d
.ColExit86:
	incl    %r8d
	cmp     $32,%r8
	jne    .ColInner86
	movl    %r10d,(%r14,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .ColOuter86
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14,%r11,4)
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14,%r11,4)
	decl    %r11d
	movl    (%r13,%r11,4),%r12d
	xorl    %r12d,(%r14)
	xorq    %r8,%r8
decl    %r11d
	movl    (%r13,%r11,4),%ecx
	.RowJump86:
	movl    (%r14,%r8,4),%eax
	roll    %cl,%eax
	rorq    $7,%rcx
	movl    %eax,(%r14,%r8,4)
	incl    %r8d
	movl    (%r14,%r8,4),%eax
	rorl    %cl,%eax
	rorq    $3,%rcx
	movl    %eax,(%r14,%r8,4)
	incl    %r8d
	cmp     $32,%r8
	jne    .RowJump86
	xorq    %r9,%r9
	cmp     $0,%r11
	jle     .ExitRound86
	.RowOuter86:
	xorq    %r8,%r8
.RowInner86:
	bt      %r9d,(%r14,%r8,4)
	jnc    .RowReset86
	bts     %r8d,%r10d
	jmp    .RowExit86
.RowReset86:
	btr     %r8d,%r10d
.RowExit86:
	incl    %r8d
	cmp     $32,%r8
	jne    .RowInner86
	movl    %r10d,(%r15,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .RowOuter86
	jmp    .Round86
.ExitRound86:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rsp
	popq %rbp
	popq %rdi
	popq %rsi
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax
	popfq
	
# 0 "" 2
#NO_APP
	movq	-24(%rbp), %rax
	movl	$128, %edx
	movq	row@GOTPCREL(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movq	-32(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
.L10:
	movq	-16(%rbp), %rax
	cmpq	-48(%rbp), %rax
	jb	.L11
	jmp	.L6
.L8:
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L6:
	movl	-36(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (GNU) 12.2.1 20221121 (Red Hat 12.2.1-4)"
	.section	.note.GNU-stack,"",@progbits
