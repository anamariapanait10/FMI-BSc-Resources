;// 2 10 mul 5 div 7 6 sub add

.data
    sirasm: .space 3000
    
    formatscanf: .asciz "%3000[^\n]"
    formatprintf: .asciz "%d\n"
    
    chDelim: .asciz " "
    rez: .space 4
    atoirez: .space 4

    firstnumber: .space 4

.text

.global main

main:
    ;// scanf("%300[^\n]", &sirasm)
    pushl $sirasm
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx

    ;// rez = strtok(sirasm, " ")
    pushl $chDelim
	pushl $sirasm
	call strtok 
	popl %ebx
	popl %ebx
	movl %eax, rez

    ;// firstnumber = atoi(rez)
    pushl rez
    call atoi
    popl %ebx
    movl %eax, firstnumber

    push firstnumber
	
et_for:

    ;// rez = strtok(NULL, " ")
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
    movl %eax, rez  

    cmp $0, %eax # dc rez == NULL ne oprim
	je et_print
	
    ;// atoirez = atoi(rez)
    push rez
    call atoi
    popl %ebx
    movl %eax, atoirez

    cmp $0, atoirez 
    je et_operatie # at este operatie
    jne et_numar # at nu e operatie
		
et_operatie:
    mov rez, %edi
    movl $0, %ecx
    movb (%edi, %ecx, 1), %al
    
    cmp $97, %al
    je et_add
    cmp $115, %al
    je et_sub
    cmp $109, %al
    je et_mul 
    cmp $100, %al
    je et_div 

et_add:
    pop %eax
    pop %ebx
    add %eax, %ebx
    push %ebx
    jmp et_for

et_sub:
    pop %eax
    pop %ebx
    sub %eax, %ebx
    push %ebx
    jmp et_for

et_mul:
    pop %eax
    pop %ebx
    movl $0, %edx
    mull %ebx
    push %eax
    jmp et_for

et_div:
    pop %ebx
    pop %eax
    movl $0, %edx
    divl %ebx
    push %eax
    jmp et_for

et_numar: # este nr, doar il punem pe stiva
    push atoirez
    jmp et_for

et_print:

	pushl $formatprintf
	call printf 
	popl %ebx
    popl %ebx
    
    pushl $0
    call fflush
    popl %ebx
et_exit:
    
    mov $1, %eax
    mov $0, %ebx
    int $0x80