;// se da un sir in hexa sa se transforme in binar
;// "A7 88 01" -> "1010 0111 1000 1000 0000 0001"
;// A78801C00A7890EC04

.data
    sirhex: .space 1000
    
    sirbin: .space 4000
    lensirbin: .long 0 # lungimea sirului binar
    indexsirbin: .long 0 # indicele de inceput al instructiunii curente din sirul binar

    sirasm: .space 4000 # sirul descifrat, am pp ca sunt maxim 10 caractere in el
    indexsirasm: .long 0
    
    nrinstructiuni: .space 4 # o sa pun nr de instructiuni din reprez binara (cate secvente de 8 biti am)
    
    formatscanf: .asciz "%s"
    formatprintf: .asciz "%s\n"

    identif: .space 3 # voi memora identificatorul unei instructiuni
    codif: .space 10 # voi memora codificarea instructiunii

    nr: .long 0 # aici voi pune nr in baza 10 al fiecarei instructiuni care e nr intreg
    nrcifnr: .long 0
    putere2: .long 1 # var ajutatoare la transformarea nr din bin in dec care va retine puterea de 2 al indicelui curent
    indb3: .long 3 # indicele bitului 3 din instructiunea curenta
    indb11: .long 11 # indicele bitului 11 din instructiunea curenta
    putere10: .long 1

    estevar: .long 0 # este 1 dc instructiunea curenta este variabila si 0 in caz contrar

.text

.global main

main:
    ;// scanf("%s", &sirhex)
    pushl $sirhex
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx

    movl $sirhex, %edi # destination index
    movl $sirbin, %esi # source index
    xorl %ecx, %ecx # sau pun in ecx lensirbinar

et_sir_bin:  # aici construiesc sirul binar
    movb (%edi, %ecx, 1), %al
    
    cmp $0, %al
    je et_calc_instructiuni

    # movl %ecx, lensirbin # ca sa avem la final in lensirbin nr de biti din reprez binara

    cmp $48, %al
    je cif_0
    cmp $49, %al
    je cif_1
    cmp $50, %al
    je cif_2
    cmp $51, %al
    je cif_3
    cmp $52, %al
    je cif_4
    cmp $53, %al
    je cif_5
    cmp $54, %al
    je cif_6
    cmp $55, %al
    je cif_7
    cmp $56, %al
    je cif_8
    cmp $57, %al
    je cif_9
    cmp $65, %al
    je cif_A
    cmp $66, %al
    je cif_B
    cmp $67, %al
    je cif_C
    cmp $68, %al
    je cif_D
    cmp $69, %al
    je cif_E
    cmp $70, %al
    je cif_F
    cmp $97, %al
    je cif_a
    cmp $98, %al
    je cif_b
    cmp $99, %al
    je cif_c
    cmp $100, %al
    je cif_d
    cmp $101, %al
    je cif_e
    cmp $102, %al
    je cif_f

cont_et_sir_bin:
    add $1, %ecx
    jmp et_sir_bin

cif_0:
    # 0x0 -> 0b0000
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_1:
    # 0x1 -> 0b0001
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_2:
    # 0x2 -> 0b0010
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_3:
    # 0x3 -> 0b0011
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_4:
    # 0x4 -> 0b0100
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_5:
    # 0x5 -> 0b0101
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_6:
    # 0x6 -> 0b0110
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_7:
    # 0x7 -> 0b0111
    pushl %ecx

    movl lensirbin, %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_8:
    # 0x8 -> 0b1000
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin
    
cif_9:
    # 0x9 -> 0b1001
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_a:
cif_A:
    # 0xA -> 0b1010
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_b:
cif_B:
    # 0xB -> 0b1011
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_c:
cif_C:
    # 0xC -> 0b1100
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_d:
cif_D:
    # 0xD -> 0b1101
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_e:
cif_E:
    # 0xE -> 0b1110
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $48, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin

cif_f:
cif_F:
    # 0xF -> 0b1111
    pushl %ecx

    movl lensirbin, %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx
    movb $49, (%esi, %ecx, 1)
    incl %ecx

    addl  $4, lensirbin

    popl %ecx
    jmp cont_et_sir_bin


et_calc_instructiuni: # avem de calculat nr de instructiuni care urmeaza sa fie interpretate care e nr total de biti din sirul binar impartit la 12
    movl $0, %edx 
    movl lensirbin, %eax
    movl $12, %ebx
    divl %ebx
    movl %eax, nrinstructiuni

    movl $1, %ecx # setam ecx-ul pt et_interpr_instructiuni

et_interpr_instructiuni: # repetam cat timp mai avem instructiuni de interpretat
    cmp nrinstructiuni, %ecx
    ja et_print_sirasm # dc ecx > nrinstructiuni ne oprim

    # continua cu et_identif

et_identif: # calculul indentificatorului si stocarea lui in var identif
    # luam bitii cu indecsii 1 si 2 incepand de la indicele instructiunii curente si le punem in indentif
    movl indexsirbin, %edx
    addl $1, %edx # folosesc edx pe post de counter pt sirbin
    movl $0, %ebx # folosesc ebx pe post de counter pt identif
    
    movl $sirbin, %edi
    movl $identif, %esi

    movb (%edi, %edx, 1), %al
    movb %al, (%esi, %ebx, 1)
    incl %edx
    incl %ebx
    movb (%edi, %edx, 1), %al
    movb %al, (%esi, %ebx, 1)

    # continua cu et_cmp_identif

et_cmp_identif: # interpretarea identificatorului
    # 00 -> numar intreg, 01 -> variabila, 10 -> operatie

    movl $0, %ebx # folosim ebx pe post de counter pt identif
    movl $identif, %edi

    movb (%edi, %ebx, 1), %al

    cmp $49, %al # sigur e operatie dc incepe cu 1
    je et_operatie

    # dc incepe cu 0 poate fi nr intreg sau variabila
    # asa ca ne uitam la urmatoarea cifra
    incl %ebx
    movb (%edi, %ebx, 1), %al
    cmp $48, %al # e numar intreg
    je et_intreg

    cmp $49, %al # e variabila
    je et_variabila

et_operatie:
    # ne uitam doar la ultimii 3 biti
    # 000 -> let; 001 -> add; 010 -> sub; 011 -> mul; 100 -> div
    
    movl indexsirbin, %ebx # adica verificam al noualea bit al instructiunii curente care incepe de la indexsirbin
    addl $9, %ebx

    movl $sirbin, %edi 
    movb (%edi, %ebx, 1), %al

    cmp $49, %al # dc incepe cu 1 sigur e op div
    je et_div

    incl %ebx
    movb (%edi, %ebx, 1), %al

    cmp $48, %al # dc a doua cifra e 0
    je et_let_or_add
    jne et_sub_or_mul

et_let_or_add:
    incl %ebx
    movb (%edi, %ebx, 1), %al

    cmp $48, %al # dc a treia cifra e 0 at e op let 
    je et_let
    jne et_add # dc e 1 at e op add

et_sub_or_mul:
    incl %ebx
    movb (%edi, %ebx, 1), %al

    cmp $48, %al # dc a treia cifra e 0 at e op sub 
    je et_sub
    jne et_mul # dc e 1 at e op mul

et_let:
    # l -> 108, e -> 101, t -> 116
    movl $sirasm, %esi
    movl indexsirasm, %ebx

    movb $108, (%esi, %ebx, 1)
    incl %ebx
    movb $101, (%esi, %ebx, 1)
    incl %ebx
    movb $116, (%esi, %ebx, 1)
    incl %ebx

    movl %ebx, indexsirasm
    jmp et_cont_interpr_instructiuni

et_add:
    # a -> 97, d -> 100
    movl $sirasm, %esi
    movl indexsirasm, %ebx 

    movb $97, (%esi, %ebx, 1)
    incl %ebx
    movb $100, (%esi, %ebx, 1)
    incl %ebx
    movb $100, (%esi, %ebx, 1)
    incl %ebx

    movl %ebx, indexsirasm
    jmp et_cont_interpr_instructiuni

et_sub:
    # s -> 115, u -> 117, b -> 98
    movl $sirasm, %esi
    movl indexsirasm, %ebx 

    movb $115, (%esi, %ebx, 1)
    incl %ebx
    movb $117, (%esi, %ebx, 1)
    incl %ebx
    movb $98, (%esi, %ebx, 1)
    incl %ebx

    movl %ebx, indexsirasm
    jmp et_cont_interpr_instructiuni
    
et_mul:
    # m -> 109, u -> 117, l -> 108

    movl $sirasm, %esi
    movl indexsirasm, %ebx 

    movb $109, (%esi, %ebx, 1)
    incl %ebx
    movb $117, (%esi, %ebx, 1)
    incl %ebx
    movb $108, (%esi, %ebx, 1)
    incl %ebx

    movl %ebx, indexsirasm
    jmp et_cont_interpr_instructiuni

et_div:
    # d -> 100, i -> 105, v -> 118

    movl $sirasm, %esi
    movl indexsirasm, %ebx 

    movb $100, (%esi, %ebx, 1)
    incl %ebx
    movb $105, (%esi, %ebx, 1)
    incl %ebx
    movb $118, (%esi, %ebx, 1)
    incl %ebx

    movl %ebx, indexsirasm
    jmp et_cont_interpr_instructiuni


et_intreg:
    # b3 = 0 -> nr poz; b3 = 1 -> nr neg
    
    movl $sirbin, %edi 

    # convert from bin to dec
    
    # in indb11 punem indicele bitului 11 cu care incepem transformarea din baza 2 in 10
    movl indexsirbin, %ebx
    addl $11, %ebx 
    movl %ebx, indb11 

    # punem in indb3 val bitului 3 din instructiunea curenta pt a stii sa ne oprim acolo cand calculam nr
    movl indexsirbin, %edx 
    addl $3, %edx
    movl %edx, indb3
    
    # continui cu et_bin_to_dec

et_bin_to_dec:

    movl indb3, %edx
    movl indb11, %ebx
    cmp %ebx, %edx 
    je et_verif_nr_poz_or_neg

    movb (%edi, %ebx, 1), %al 
    cmp $49, %al # dc e 1 inseamna ca trebuie sa adunam puterea aia de 2
    je et_mul_putere2
    # altfel continua cu et_cont_et_bin_to_dec

et_cont_et_bin_to_dec:
    
    movl $0, %edx
    movl putere2, %eax
    movl $2, %ebx
    mull %ebx
    movl %eax, putere2

    subl $1, indb11

    jmp et_bin_to_dec

et_mul_putere2: # adunam puterea de 2 la nr
    movl nr, %eax
    addl putere2, %eax
    movl %eax, nr

    jmp et_cont_et_bin_to_dec

et_verif_nr_poz_or_neg: # verific bitul cu indicele inceputul instructiunii + 3
    # era deja calculat in b3
    movl $sirbin, %edi 

    movl indexsirbin, %ebx
    addl $3, %ebx

    movb (%edi, %ebx, 1), %al

    cmp $49, %al # dc e negativ
    je et_neg_nr

    cmp $1, estevar # am facut o variabila ca sa pot refolosi codul asta pt instructiunile de tip variabila
    je et_write_var_in_sirasm
    jne et_write_nr_in_sirasm

et_calc_nrcifnr:
    movl nr, %eax
    movl $0, nrcifnr

    et_while:
        cmp $0, %eax
        je et_calc_putere10

        movl $0, %edx
        movl $10, %ebx
        divl %ebx
        addl $1, nrcifnr

        jmp et_while


et_calc_putere10:
    movl nrcifnr, %ebx
    cmp $1, %ebx
    je et_write_nr_in_sirasm_2
    
    movl $0, %edx
    movl putere10, %eax
    movl $10, %ebx
    mull %ebx
    movl %eax, putere10

    movl nrcifnr, %ebx
    subl $1, %ebx
    movl %ebx, nrcifnr

    jmp et_calc_putere10

et_write_nr_in_sirasm:

    # calculez o puterea a lui 10 cu care sa pot afisa nr in ordine corecta in sirasm
    # pt nr de o cifra -> 10^0, pt nr de 2 cifre -> 10^1, pt nr de 3 cifre -> 10^2

    et_verif_if_nr_e_zero:
        movl $sirbin, %edi 
        movl $sirbin, %esi

        
        movl indexsirbin, %ebx
        
        movl %ebx, indb11 
        addl $12, indb11
        
        addl $4, %ebx
        

        et_while_2:
            cmp indb11, %ebx
            je et_write_zero

            movb (%edi, %ebx, 1), %al

            cmp $48, %al
            jne et_calc_nrcifnr

            incl %ebx
            jmp et_while_2

        et_write_zero:
            movl indexsirasm, %ebx
            movl $sirasm, %esi
            movl $48, %edx
            movb %edx, (%esi, %ebx, 1) 
            addl $1, indexsirasm
            jmp et_reset_nr_and_putere2_and_putere10

et_write_nr_in_sirasm_2:
    # cat timp putere10 e diferit de 0 inseamna ca mai avem nr de scris in sirasm
    movl $sirasm, %esi
    movl putere10, %ebx
    cmp $0, %ebx 
    je et_reset_nr_and_putere2_and_putere10
    cmp $1, %ebx
    je et_write_nr_in_sirasm_4
    
    # calculam catul impartirii lui nr la putere10
    movl $0, %edx
    movl nr, %eax
    movl putere10, %ebx
    divl %ebx

et_write_nr_in_sirasm_3:
    # facem impartirea catului la 10 si retinem restul pe care il si scriem in sirasm
    movl $0, %edx
    movl $10, %ebx
    divl %ebx

    movl indexsirasm, %ebx
    movl $sirasm, %esi 

    # punem restul care e in edx in sirasm
    cmp $0, %edx 
    je et_write_0_in_sirasm
    cmp $1, %edx 
    je et_write_1_in_sirasm
    cmp $2, %edx 
    je et_write_2_in_sirasm
    cmp $3, %edx 
    je et_write_3_in_sirasm
    cmp $4, %edx 
    je et_write_4_in_sirasm
    cmp $5, %edx 
    je et_write_5_in_sirasm
    cmp $6, %edx 
    je et_write_6_in_sirasm
    cmp $7, %edx 
    je et_write_7_in_sirasm
    cmp $8, %edx 
    je et_write_8_in_sirasm
    cmp $9, %edx 
    je et_write_9_in_sirasm

et_write_nr_in_sirasm_4:
    movl nr, %eax
    jmp et_write_nr_in_sirasm_3
    
et_div_putere10: # imparte putere10 la 10
    movl $0, %edx
    movl putere10, %eax
    movl $10, %ebx
    divl %ebx
    movl %eax, putere10

    jmp et_write_nr_in_sirasm_2

et_write_0_in_sirasm:
    movl $48, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

    jmp et_div_putere10

et_write_1_in_sirasm:
    movl $49, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

    jmp et_div_putere10

et_write_2_in_sirasm:
    movl $50, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

    jmp et_div_putere10

et_write_3_in_sirasm:
    movl $51, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_write_4_in_sirasm:
    movl $52, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

    jmp et_div_putere10

et_write_5_in_sirasm:
    movl $53, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_write_6_in_sirasm:
    movl $54, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_write_7_in_sirasm:
    movl $55, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_write_8_in_sirasm:
    movl $56, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_write_9_in_sirasm:
    movl $57, %edx
    movb %edx, (%esi, %ebx, 1) 
    addl $1, indexsirasm

   jmp et_div_putere10

et_neg_nr:
    # - -> 45
    movl $sirasm, %esi
    movl indexsirasm, %ebx 

    movb $45, (%esi, %ebx, 1)
    
    addl $1, indexsirasm

    jmp et_write_nr_in_sirasm

et_reset_nr_and_putere2_and_putere10:
    movl $0, nr 
    movl $1, putere2
    movl $1, putere10

    cmp $1, estevar
    je et_reset_estevar
    
    jmp et_cont_interpr_instructiuni

et_reset_estevar:
    movl $0, estevar
    jmp et_cont_interpr_instructiuni

et_variabila:
    movl $1, estevar
    jmp et_intreg

et_write_var_in_sirasm:
    movl $sirasm, %esi
    
    mov nr, %eax
    movl indexsirasm, %ebx
    movb %eax, (%esi, %ebx, 1)
    addl $1, indexsirasm

    jmp et_reset_nr_and_putere2_and_putere10

et_cont_interpr_instructiuni:
    addl $12, indexsirbin
    incl %ecx
    
    # punem spatiu dupa fiecare instructiune
    movl $sirasm, %esi
    movl indexsirasm, %ebx
    movb $32, (%esi, %ebx, 1)
    incl %ebx
    movl %ebx, indexsirasm

    jmp et_interpr_instructiuni

et_print_sirbin:

    pushl $sirbin
    pushl $formatprintf
    call printf
    popl %ebx
    popl %ebx

et_print_sirasm:

    pushl $sirasm
    pushl $formatprintf
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx
    # continui cu et_exit

et_exit:

    movl $1, %eax
    movl $0, %ebx
    int $0x80