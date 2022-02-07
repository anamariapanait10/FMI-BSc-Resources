;// 2 10 mul 5 div 7 6 sub add
;// x 1 let 2 x add y 3 let x y add mul

.data
    sirasm: .space 1000
    sirvar: .long 48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48 # la indicele 0 se afla val lui a, la ind 1 val lui b si tot asa
    
    formatscanf: .asciz "%1000[^\n]"
    formatprintf: .asciz "%d\n"
    formatprintf2: .asciz "%s\n"
    
    chdelim: .asciz " "
    rez: .space 4 # cuvantul curent
    atoirez: .space 4 # cuvantul curent convertit la int
    nr: .long 0

.text

.global main

main:

    ;// scanf("%1000[^\n]", &sirasm)
    pushl $sirasm
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx
    
    ;// rez = strtok(sirasm, " ")
    pushl $chdelim 
	pushl $sirasm
	call strtok 
	popl %ebx
	popl %ebx
	movl %eax, rez # primul cuvant

    ;// atoirez = atoi(rez)
    pushl rez
    call atoi
    popl %ebx
    movl %eax, atoirez # primul cuvant doar ca int

    cmp $0, atoirez # dc atoi returneaza 0 at nu e nr
    je et_operatie_or_var # at este operatie sau variabila
    jne et_numar # at este numar

et_for:

    ;// rez = strtok(NULL, " ")
	pushl $chdelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
    movl %eax, rez  

    cmp $0, %eax # dc rez == NULL ne oprim
	je et_print

    ;// atoirez = atoi(rez)
    pushl %eax
    call atoi
    popl %ebx
    movl %eax, atoirez

    cmp $0, atoirez
    je et_operatie_or_var # at este operatie sau variabila
    jne et_numar # at este numar
		
et_operatie_or_var:
    movl rez, %edi 

    movl $1, %ecx
    movb (%edi, %ecx, 1), %al # verific daca urmatorul caracter exista

    cmp $0, %al
    je et_var # dc nu at e var
    jne et_operatie # altfel e operatie

et_var:
    # trebuie verificat daca exista deja sau nu 
    # dc exista atunci trebuie pusa valoarea sa pe stiva
    # dc nu exista atunci trebuie adaugat in sirvar

    et_verif_var_exista: # dc la indicele variabilei este 0 at nu exista
        movl rez, %edi
        movl $0, %ecx
        movl (%edi, %ecx, 4), %eax # in %eax punem variabila
        # calculam ecx corect
        movl $1, nr
        jmp et_set_ecx_to_var_index_in_sirvar
    
    et_cont_verif_var_exista:
        movl $sirvar, %edi
        movl (%edi, %ecx, 4), %eax
        cmp $48, %eax # dc e zero
        je et_var_nu_exista
        jne et_var_exista


    et_var_exista: # atunci trebuie pusa pe stiva valoarea sa pe stiva
        movl rez, %edi
        movl $0, %ecx
        movl (%edi, %ecx, 4), %eax # in %al punem variabila
        # calculam ecx corect
        movl $2, nr
        jmp et_set_ecx_to_var_index_in_sirvar
    
    et_cont_var_exista:
        movl $sirvar, %edi
        movl (%edi, %ecx, 4), %eax
        subl $48, %eax
        pushl %eax

        jmp et_for

    et_var_nu_exista: # dc nu exista deja in sirvar atunci o adaug pe stiva urmand ca la instructiunea let sa atribui valoarea
        push rez
        jmp et_for

et_operatie:
    mov rez, %edi
    movl $0, %ecx
    movb (%edi, %ecx, 1), %al # primul caracter din operatie
    
    cmp $97, %al
    je et_add
    cmp $115, %al
    je et_sub
    cmp $109, %al
    je et_mul 
    cmp $100, %al
    je et_div
    cmp $108, %al
    je et_let 

et_add:
    popl %eax
    popl %ebx
    addl %eax, %ebx
    pushl %ebx
    jmp et_for

et_sub:
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    jmp et_for

et_mul:
    popl %eax
    popl %ebx
    movl $0, %edx
    mull %ebx
    pushl %eax
    jmp et_for

et_div:
    popl %ebx
    popl %eax
    movl $0, %edx
    divl %ebx
    pushl %eax
    jmp et_for

et_set_ecx_to_var_index_in_sirvar:
    cmp $97, %al
    je et_a
    cmp $98, %al
    je et_b
    cmp $99, %al
    je et_c
    cmp $100, %al
    je et_d
    cmp $101, %al
    je et_e
    cmp $102, %al
    je et_f
    cmp $103, %al
    je et_g
    cmp $104, %al
    je et_h
    cmp $105, %al
    je et_i 
    cmp $106, %al
    je et_j
    cmp $107, %al
    je et_k 
    cmp $108, %al
    je et_l  
    cmp $109, %al
    je et_m  
    cmp $110, %al
    je et_n  
    cmp $111, %al
    je et_o  
    cmp $112, %al
    je et_p  
    cmp $113, %al
    je et_q  
    cmp $114, %al
    je et_r  
    cmp $115, %al
    je et_s 
    cmp $116, %al
    je et_t 
    cmp $117, %al
    je et_u 
    cmp $118, %al
    je et_v 
    cmp $119, %al
    je et_w 
    cmp $120, %al
    je et_x 
    cmp $121, %al
    je et_y 
    cmp $122, %al
    je et_z

    et_a:
        movl $0, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_b:
        movl $1, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_c:
        movl $2, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_d:
        movl $3, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_e:
        movl $4, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_f:
        movl $5, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_g:
        movl $6, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_h:
        movl $7, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_i:
        movl $8, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_j:
        movl $9, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_k:
        movl $10, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_l:
        movl $11, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_m:
        movl $12, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_n:
        movl $13, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_o:
        movl $14, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_p:
        movl $15, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_q:
        movl $16, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_r:
        movl $17, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_s:
        movl $18, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_t:
        movl $19, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_u:
        movl $20, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_v:
        movl $21, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_w:
        movl $22, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_x:
        movl $23, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_y:
        movl $24, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2
    et_z:
        movl $25, %ecx
        cmp $1, nr
        je et_cont_verif_var_exista
        cmp $2, nr
        je et_cont_var_exista
        cmp $3, nr
        je et_let_2

et_let: # atunci variabila ia valoarea din varful stivei
    

    popl atoirez # punem in atoirez val pe care trebuie sa o atribuim variabilei
    popl rez # scoatem variabila
    mov rez, %edi
    movl $0, %ecx
    movb (%edi, %ecx, 1), %al # punem variabila in %al
    
    movl $3, nr
    jmp et_set_ecx_to_var_index_in_sirvar

et_let_2:
    movl $sirvar, %esi
    movl atoirez, %eax
    addl $48, %eax
    movl %eax, (%esi, %ecx, 4)

    jmp et_for

et_numar: # este nr, doar il punem pe stiva
    push atoirez
    jmp et_for

et_print:

	pushl $formatprintf
	call printf 
	popl %ebx
    popl %ebx

    # continua cu exit

et_exit:
    
    pushl $0
    call fflush
    popl %ebx
    
    mov $1, %eax
    mov $0, %ebx
    int $0x80
