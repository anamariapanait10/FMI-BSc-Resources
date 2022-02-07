;// x 2 3 1 2 3 4 5 6 let x -2 add
;// x 2 3 -1 0 1 2 3 4 let rot90d

.data
   
    matrice: .space 10000
    lenmat: .space 4
    indmatrice: .long 0
    
    col: .long 0
    lin: .long 0 
    
    elem_curent: .space 4

    formatscanf: .asciz "%s"
    formatscanfint: .asciz "%d"
    formatprintfint: .asciz "%d "
    formatprintf: .asciz "%s"

    nr: .space 4
    op: .space 7

    temp: .space 100
    terminator: .asciz "\n"

.text

.global main

main:
    ;// scanf("%s", &temp)
    pushl $temp
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $lin
    pushl $formatscanfint
    call scanf
    popl  %ebx
    popl %ebx

    pushl $col
    pushl $formatscanfint
    call scanf
    popl %ebx
    popl %ebx

    # lenmat = nr_lin * nr_col
    movl $0, %edx
    movl lin, %eax
    movl col, %ecx
    mull %ecx
    movl %eax, lenmat

    movl $0, %ecx # contor ca sa citim elem matricei
    movl $matrice, %esi
    # continuam cu et_read_elem_mat
    
et_read_elem_mat:
    cmp lenmat, %ecx
    je et_read_instr

    pushl %ecx

    # citire elem din mat
    pushl $elem_curent
    pushl $formatscanfint
    call scanf
    popl %ebx
    popl %ebx

    popl %ecx

    movl elem_curent, %eax
    movl %eax, (%esi, %ecx, 4)
    addl $1, %ecx

    jmp et_read_elem_mat

et_read_instr:
    
    pushl $temp # citesc let
    pushl $formatscanf
    call scanf
    popl %eax
    popl %eax

    pushl $temp # citesc ori numele variabilei ori rot90d
    pushl $formatscanf
    call scanf
    popl %eax
    popl %eax

    movl $temp, %edi # ma uit la al doilea caracter din temp si daca e nul inseamna ca e variabila
    movl $1, %ecx
    movb (%edi, %ecx, 1), %al

    cmp $0, %al
    je et_alta_op # add/sub/mul/div
    jne et_op_de_rot

et_alta_op: 

    pushl $nr
    pushl $formatscanfint
    call scanf
    popl %ebx
    popl %ebx

    pushl $op
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx
    
    movl $op, %edi
    movl $0, %ecx
    movb (%edi, %ecx, 1), %al

    movl $matrice, %edi

    cmp $97, %al
    je et_add
    cmp $115, %al
    je et_sub
    cmp $109, %al
    je et_mul 
    cmp $100, %al
    je et_div

et_add:
    cmp lenmat, %ecx
    je et_print

    movl (%edi, %ecx, 4), %eax
    addl nr, %eax
    movl %eax, (%edi, %ecx, 4)

    incl %ecx
    jmp et_add

et_sub:
    cmp lenmat, %ecx
    je et_print

    movl (%edi, %ecx, 4), %eax
    subl nr, %eax
    movl %eax, (%edi, %ecx, 4)

    incl %ecx
    jmp et_sub

et_mul:
    cmp lenmat, %ecx
    je et_print

    movl $0, %edx
    movl (%edi, %ecx, 4), %eax
    movl nr, %ebx
    imull %ebx
    movl %eax, (%edi, %ecx, 4)

    incl %ecx
    jmp et_mul

et_div:
    cmp lenmat, %ecx
    je et_print

    movl $0, %edx
    movl (%edi, %ecx, 4), %eax
    cmp $0, %eax # dc numaratorul e negativ
    jl et_schimb_semn

    movl nr, %ebx
    idivl %ebx
    movl %eax, (%edi, %ecx, 4)
    
    incl %ecx
    jmp et_div

et_schimb_semn:
    # eax trebuie sa devina 0 - eax = - eax
    movl $0, %ebx
    subl %eax, %ebx
    movl %ebx, %eax

    # numitorul trebuie sa isi schimbe si el semnul
    movl nr, %edx
    movl $0, %ebx
    subl %edx, %ebx
    
    movl $0, %edx
    idivl %ebx
    movl %eax, (%edi, %ecx, 4)

    incl %ecx
    jmp et_div


et_print: # matricea

    pushl lin
    pushl $formatprintfint
    call printf
    popl %eax
    popl %eax

    pushl col
    pushl $formatprintfint
    call printf
    popl %eax
    popl %eax
    
    movl $matrice, %edi
    movl $0, %ebx
et_cont_print:
    cmp lenmat, %ebx
    je et_exit

    movl (%edi, %ebx, 4), %eax
    pushl %eax
    pushl $formatprintfint
    call printf
    popl %eax
    popl %eax
    
    incl %ebx

    jmp et_cont_print

et_op_de_rot:

    pushl col
    pushl $formatprintfint
    call printf
    popl %ebx
    popl %ebx
    
    pushl lin
    pushl $formatprintfint
    call printf
    popl %ebx
    popl %ebx

    ;// i = eax, j = ebx
    movl $-1, %ebx
    movl $matrice, %edi
    et_col:
        addl $1, %ebx
        cmp col, %ebx
        je et_exit

        movl lin, %eax
        subl $1, %eax
        
        et_lin:
            cmp $-1, %eax
            je et_col

            pushl %eax
            # am calculat indicele din matrice al elem care trebuie afisat dupa formula col * i + j
            movl col, %ecx
            mull %ecx
            addl %ebx, %eax
            
            movl (%edi, %eax, 4), %ecx
            
            pushl %ecx
            pushl $formatprintfint 
            call printf 
            popl %edx
            popl %edx

            popl %eax
            
            subl $1, %eax
            jmp et_lin
        
et_exit:

    pushl $0        
    call fflush
    popl %ebx

    pushl $terminator
    pushl $formatprintf
    call printf
    popl %ebx
    popl %ebx

    movl $1, %eax
    movl $0, %ebx
    int $0x80

    
