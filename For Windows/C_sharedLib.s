	.file	"C_sharedLib.c"
	.text
	.globl	row
	.bss
	.align 32
row:
	.space 128
	.globl	column
	.align 32
column:
	.space 128
	.globl	keys
	.align 32
keys:
	.space 128
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC0:
	.ascii "ENCRYPTION STARTED...\0"
.LC1:
	.ascii "DECRYPTION STARTED...\0"
.LC2:
	.ascii "idk whats wrong\0"
.LC3:
	.ascii "ID: %d Fin\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	%ecx, 16(%rbp)
	movq	%rdx, 24(%rbp)
	movl	%r8d, 32(%rbp)
	movq	%r9, 40(%rbp)
	call	__main
	movq	40(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	40(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	48(%rbp), %rax
	movl	$128, %r8d
	movq	%rax, %rdx
	leaq	keys(%rip), %rax
	movq	%rax, %rcx
	call	memcpy
	cmpl	$0, 32(%rbp)
	jne	.L2
	cmpl	$0, 16(%rbp)
	jne	.L3
	leaq	.LC0(%rip), %rax
	movq	%rax, %rcx
	call	puts
.L3:
	movq	$0, -8(%rbp)
	jmp	.L4
.L5:
/APP
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
.Round40:
	movl    (%r13,%r11,4),%ecx
	xorq    %r8,%r8
.RowJump40:
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
	jne    .RowJump40
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
	.RowOuter40:
	xorq    %r8,%r8
.RowInner40:
	bt      %r9d,(%r14,%r8,4)
	jnc    .RowReset40
	bts     %r8d,%r10d
	jmp    .RowExit40
.RowReset40:
	btr     %r8d,%r10d
.RowExit40:
	incl    %r8d
	cmp     $32,%r8d
	jne    .RowInner40
	movl    %r10d,(%r15,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .RowOuter40
	xorq    %r8,%r8
incl    %r11d
	movl    (%r13,%r11,4),%ecx
	.ColJump40:
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
	jne    .ColJump40
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
	je     .ExitRound40
	xorq    %r9,%r9
.ColOuter40:
	xorq    %r8,%r8
.ColInner40:
	bt      %r9,(%r15,%r8,4)
	jnc    .ColReset40
	bts     %r8d,%r10d
	jmp    .ColExit40
.ColReset40:
	btr     %r8d,%r10d
.ColExit40:
	incl    %r8d
	cmp     $32,%r8d
	jne    .ColInner40
	movl    %r10d,(%r14,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .ColOuter40
	jmp    .Round40
.ExitRound40:
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
/NO_APP
	movq	-32(%rbp), %rax
	movl	$128, %r8d
	leaq	column(%rip), %rdx
	movq	%rax, %rcx
	call	memmove
	movq	-32(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -24(%rbp)
	addq	$1, -8(%rbp)
.L4:
	movq	-8(%rbp), %rax
	cmpq	24(%rbp), %rax
	jb	.L5
	jmp	.L6
.L2:
	cmpl	$0, 32(%rbp)
	jg	.L7
	cmpl	$0, 32(%rbp)
	je	.L8
.L7:
	cmpl	$0, 16(%rbp)
	jne	.L9
	leaq	.LC1(%rip), %rax
	movq	%rax, %rcx
	call	puts
.L9:
	movq	$0, -16(%rbp)
	jmp	.L10
.L11:
/APP
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
.Round83:
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
	.ColJump83:
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
	jne    .ColJump83
	xorq    %r9,%r9
.ColOuter83:
	xorq    %r8,%r8
.ColInner83:
	bt      %r9,(%r15,%r8,4)
	jnc    .ColReset83
	bts     %r8d,%r10d
	jmp    .ColExit83
.ColReset83:
	btr     %r8d,%r10d
.ColExit83:
	incl    %r8d
	cmp     $32,%r8
	jne    .ColInner83
	movl    %r10d,(%r14,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .ColOuter83
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
	.RowJump83:
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
	jne    .RowJump83
	xorq    %r9,%r9
	cmp     $0,%r11
	jle     .ExitRound83
	.RowOuter83:
	xorq    %r8,%r8
.RowInner83:
	bt      %r9d,(%r14,%r8,4)
	jnc    .RowReset83
	bts     %r8d,%r10d
	jmp    .RowExit83
.RowReset83:
	btr     %r8d,%r10d
.RowExit83:
	incl    %r8d
	cmp     $32,%r8
	jne    .RowInner83
	movl    %r10d,(%r15,%r9,4)
	incq    %r9
	cmp     $32,%r9
	jne    .RowOuter83
	jmp    .Round83
.ExitRound83:
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
/NO_APP
	movq	-24(%rbp), %rax
	movl	$128, %r8d
	leaq	row(%rip), %rdx
	movq	%rax, %rcx
	call	memmove
	movq	-32(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	subq	$-128, %rax
	movq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
.L10:
	movq	-16(%rbp), %rax
	cmpq	24(%rbp), %rax
	jb	.L11
	jmp	.L6
.L8:
	leaq	.LC2(%rip), %rax
	movq	%rax, %rcx
	call	printf
.L6:
	movl	16(%rbp), %eax
	movl	%eax, %edx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rcx
	call	printf
	movl	$0, %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev6, Built by MSYS2 project) 13.1.0"
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	memmove;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
