# 5 1 1 0 0 0 0 0 3 0 0 0 0 0 0 4 5 -> 1 2 1 2 1 2 3 4 3 4 5 3 5 4 5
# 3 2 1 0 2 3 0 1 3 0 1 -> -1
# 5 1 1 0 0 3 0 0 3 0 0 0 2 0 0 4 5 -> 1 2 1 3 1 2 3 4 3 5 2 4 5 4 5
.data
    n: .space 4
    m: .space 4
    
    x: .space 4  # citesc cele 3 * n elem in x
    lung: .long 0 # = 3 * n
    
    st: .space 400 # sirul citit de la tastatura
    fr: .space 150 # frecventa elementelor
    ul_ap: .space 150 # ultima aparitie a elementelor
    ul: .space 4 # copie a indicelui aparitiei ultimului element inainte de modificarea lui
    mat: .space 11200 # mat[i][j] imi zice daca pe poz i pot sa pun elem j in functie de punctele fixe
    lung_mat: .space 4
    k: .space 4 
    ind: .space 4

    min: .space 4
    max: .space 4

    formatscanfint: .asciz "%d"
    formatprintfint: .asciz "%d "
    formatprintf: .asciz "%s"

    terminator: .asciz "\n"
.text

valid: # k nu e folosit
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx # registrii callee-saved trebuie restaurati de procedura
    pushl %esp
    pushl %esi
    pushl %edi

    pushl %ecx # salvam si ecx si edx
    pushl %edx


    movl $st, %edi # if(fr[st[k]] == 3) return 0;
    movl k, %ecx
    movl (%edi, %ecx, 4), %eax
    movl $fr, %edi 
    movl %eax, %ecx
    movl (%edi, %ecx, 4), %eax
    cmp $3, %eax
    je et_ret_0


    # if(ul_ap[st[k]] == -1 || (k - ul_ap[st[k]] > m))
    #       if(mat[k][st[k]] == 1) return 1;
    movl $st, %edi # if(ul_ap[st[k]] == -1)
    movl k, %ecx
    movl (%edi, %ecx, 4), %eax
    movl $ul_ap, %edi 
    movl %eax, %ecx
    movl (%edi, %ecx, 4), %eax
    cmp $-1, %eax
    je et_verif_cond2
    
    movl k, %ecx # if(k - ul_ap[st[k]] > m)
    subl %eax, %ecx
    cmp m, %ecx
    jg et_verif_cond2
    
    jmp et_ret_0
    
    et_verif_cond2: # if(mat[k][st[k]] == 1)
        movl n, %ecx # mat[(n + 1) * k + st[k]]
        addl $1, %ecx
        movl k, %eax
        movl $0, %edx
        mull %ecx # eax = (n + 1) * k
        
        movl $st, %edi
        movl k, %ecx
        movl (%edi, %ecx, 4), %edx # edx = st[k]

        addl %edx, %eax # eax = (n + 1) * k + st[k]

        movl $mat, %edi
        movl %eax, %ecx
        movl (%edi, %ecx, 4), %eax # eax = mat[(n + 1) * k + st[k]]

        cmp $1, %eax # if(mat[k][st[k]] == 1)
        je et_ret_1
        jne et_ret_0

    et_ret_1:
        movl $1, %eax
        
        popl %edx
        popl %ecx
        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx

        popl %ebp
        ret
    et_ret_0:
        movl $0, %eax

        popl %edx
        popl %ecx
        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx 

        popl %ebp
        ret
bkt:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx # registrii callee-saved trebuie restaurati de procedura
    pushl %esp
    pushl %esi
    pushl %edi

    movl 8(%ebp), %eax
    movl %eax, k

    movl lung, %eax # if(k < 3 * n)
    cmp k, %eax
    je et_else
    # altfel continuam

    movl $st, %edi # if(st[k] == 0)
    movl k, %ecx
    movl (%edi, %ecx, 4), %eax
    cmp $0, %eax 
    jne et_else_if
    # altfel nu e pct fix
    
    movl $1, %ebx
    for_n: # for(int i = 1; i <= n; i++)
        cmp n, %ebx
        jg et_final
        
        movl $st, %esi # st[k] = i;
        movl k, %ecx
        movl %ebx, (%esi, %ecx, 4)

        # valid(k) returneaza 1 sau 0 in eax
        pushl k
        call valid
        popl %edx

        cmp $1, %eax
        jne et_nu_e_valid

        et_valid: # if(valid(k) == 1)
            
            movl $fr, %esi # fr[i] += 1;
            movl (%esi, %ebx, 4), %eax
            addl $1, %eax
            movl %eax, (%esi, %ebx, 4)
            
            pushl %eax
            
            movl $ul_ap, %edi # ul = ul_ap[i];
            movl (%edi, %ebx, 4), %eax 
            movl %eax, ul
            
            pushl ul
            
            movl $ul_ap, %esi # ul_ap[i] = k;
            movl k, %eax
            movl %eax, (%esi, %ebx, 4)

            pushl %ebx
            pushl k

            movl k, %eax # bkt(k+1);
            addl $1, %eax
            pushl %eax
            call bkt
            popl %eax

            popl k
            popl %ebx

            popl ul

            movl $fr, %esi # fr[i] -= 1;
            popl %eax
            subl $1, %eax
            movl %eax, (%esi, %ebx, 4)

            movl $ul_ap, %esi # ul_ap[i] = ul;
            movl ul, %eax
            movl %eax, (%esi, %ebx, 4)

        et_nu_e_valid:
            movl $st, %esi # st[k] = 0;
            movl k, %ecx
            movl $0, %eax
            movl %eax, (%esi, %ecx, 4)

        et_cont_for_n:
            addl $1, %ebx
            jmp for_n

    et_else_if: # else if(k - ul_ap[st[k]] > m || ul_ap[st[k]] == -1)
        
        movl k, %ebx # if(k - ul_ap[st[k]] > m)
        movl $st, %edi 
        movl k, %ecx
        movl (%edi, %ecx, 4), %eax
        movl $ul_ap, %edi 
        movl %eax, %ecx
        movl (%edi, %ecx, 4), %eax

        cmp $-1, %eax # if(ul_ap[st[k]] == -1)
        je et_ok

        subl %eax, %ebx
        cmp m, %ebx
        jg et_ok

        jmp et_final

        et_ok:
            
            movl $st, %edi # ul_ap[st[k]] = k;
            movl k, %ecx
            movl (%edi, %ecx, 4), %eax
            movl $ul_ap, %esi 
            movl %eax, %ecx
            
            movl (%esi, %ecx, 4), %eax # ul = ul_ap[st[k]];
            movl %eax, ul
            pushl ul
            pushl k

            movl k, %eax
            movl %eax, (%esi, %ecx, 4)

            movl k, %eax # bkt(k+1);
            addl $1, %eax
            pushl %eax
            call bkt
            popl %eax

            # ul_ap[st[k]] = ul;
            popl k
            popl ul
            movl $st, %edi
            movl k, %ecx
            movl (%edi, %ecx, 4), %eax
            movl $ul_ap, %esi 
            movl %eax, %ecx
            movl ul, %eax
            movl %eax, (%esi, %ecx, 4)

            jmp et_final

    et_else:
        movl $0, %ebx
        et_afis:  # for(int i = 0; i < 3 * n; i++) cout << st[i] <<' ';
            cmp lung, %ebx
            je et_exit

            movl $st, %edi
            movl (%edi, %ebx, 4), %ecx

            pushl %ecx
            pushl $formatprintfint
            call printf
            popl %ecx
            popl %ecx

            addl $1, %ebx
            jmp et_afis
    
    et_final:

        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx

        popl %ebp
        ret

.global main

main:
    pushl $n
    pushl $formatscanfint
    call scanf
    popl %ebx
    popl %ebx

    pushl $m
    pushl $formatscanfint
    call scanf
    popl %ebx
    popl %ebx

    # calculez in lung 3 * n
    movl n, %eax
    movl $3, %ebx
    movl $0, %edx
    mull %ebx
    movl %eax, lung

    # calculez in lung_mat 3 * n * (n+1)
    movl n, %ebx
    addl $1, %ebx
    movl $0, %edx
    mull %ebx
    movl %eax, lung_mat

    movl $0, %ebx # initializez matricea cu 1 adica pp ca nu am pct fixe si ca pot pune oriunde numerele
    et_init_mat:    # la mat o sa avem indici de la 0 la 3 * n * (n+1) - 1
        cmp lung_mat, %ebx
        je et_cont_main
        
        movl %ebx, %eax
        movl $0, %edx
        movl n, %ecx
        addl $1, %ecx
        divl %ecx
        cmp $0, %edx
        je et_cont_init_mat
    
        movl $mat, %esi
        movl $1, %eax
        movl %eax, (%esi, %ebx, 4)

        et_cont_init_mat:    
            addl $1, %ebx
            cmp n, %ebx # initializam si ul_ap cu -1 cu indicii de la 1 la n
            jg et_init_mat
            
            # ul_ap[i] = -1
            movl $ul_ap, %esi
            movl $-1, %eax
            movl %eax, (%esi, %ebx, 4)
            jmp et_init_mat

et_cont_main:
    movl $0, %ebx
    
    et_for: # citesc cele 3 * n numere in st
        
        cmp lung, %ebx
        je et_cont_main_2

        pushl $x
        pushl $formatscanfint
        call scanf
        popl %edx
        popl %edx

        movl $st, %esi
        movl x, %eax
        movl %eax, (%esi, %ebx, 4)
        addl $1, %ebx

        cmp $0, %eax
        je et_if
        # altfel e pct fix

        # fr[x] += 1;
        movl $fr, %esi
        movl x, %ecx
        movl (%esi, %ecx, 4), %eax
        addl $1, %eax
        movl %eax, (%esi, %ecx, 4)

        # for(int z = max(0, i - m); z <= min(3 * n - 1, i + m); z++)
        #        mat[z][st[i]] = 0;
        
        movl %ebx, %eax
        subl $1, %eax
        subl m, %eax
        movl %eax, max # eax = max = i - m
        
        movl lung, %edx
        subl $1, %edx # edx = 3 * n - 1

        movl %ebx, %ecx
        subl $1, %ecx
        addl m, %ecx
        movl %ecx, min # min = i + m

        cmp $0, %eax
        jl et_swap_max
        jg et_not_swap_max

        et_swap_max:
            movl $0, max

        et_not_swap_max:
            cmp min, %edx
            jl et_swap_min
            jg et_not_swap_min

            et_swap_min:
                movl %edx, min

            et_not_swap_min:
                movl max, %ecx
        for_mat:  # mat[z][st[i]] = 0;
            cmp min, %ecx
            jg et_if

            pushl %ebx

            movl %ecx, %eax # mat[(n + 1) * z + st[i]] = 0
            movl n, %ebx
            addl $1, %ebx
            movl $0, %edx
            mull %ebx
            addl x, %eax

            movl $mat, %esi
            movl %eax, %ebx
            movl $0, %eax
            movl %eax, (%esi, %ebx, 4)

            popl %ebx
            addl $1, %ecx

            jmp for_mat

        et_if:  # if(fr[st[i]] > 3)
            movl $fr, %edi
            movl x, %ecx
            movl (%edi, %ecx, 4), %eax

            cmp $3, %eax
            jg et_nu_exista
        
        jmp et_for
            

et_cont_main_2:

    pushl $0
    call bkt
    popl %edx

et_nu_exista: #  cout << -1; return 0;
    pushl $-1
    pushl $formatprintfint
    call printf
    popl %ebx
    popl %ebx

    jmp et_exit

et_exit:
    pushl $terminator
    pushl $formatprintf
    call printf
    popl %ebx
    popl %ebx

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80