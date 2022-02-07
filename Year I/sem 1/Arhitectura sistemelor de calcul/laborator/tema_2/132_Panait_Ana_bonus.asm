.data
    lin: .long 0
    col: .long 0
    mat: .space 800
    x: .space 4
    val: .space 4
    start_lin: .space 4
    start_col: .space 4

    input_file: .asciz "input_file.txt"
    output_file: .asciz "output_file.txt"

    formatscanfint: .asciz "%d"
    formatprintfint: .asciz "%d "
    formatprintf: .asciz "%s"
    format_read: .asciz "r"
    format_write: .asciz "w"

    terminator: .asciz "\n"
    str_nu_exista: .asciz "Nu exista solutie\n"
.text

afis:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx  # registrii callee-saved trebuie restaurati de procedura
    pushl %edi

    pushl $format_write # open output file, file pointer in eax
    pushl $output_file
    call fopen
    popl %edx
    popl %edx
    
    movl $0, %ecx
    for_i_2:
        
        cmp $9, %ecx
        je final
        
        movl $0, %ebx
        for_j_2:

            cmp $9, %ebx
            je et_cont_for_i_2
    
            pushl %ecx
            pushl %eax

            movl $mat, %edi 
            movl $9, %eax
            movl $0, %edx
            mull %ecx
            addl %ebx, %eax
            movl (%edi, %eax, 4), %ecx
            
            popl %eax

            pushl %ecx
            pushl $formatprintfint
            pushl %eax
            call fprintf
            popl %eax
            popl %edx
            popl %edx

            popl %ecx

            incl %ebx
            jmp for_j_2 
        
        et_cont_for_i_2:
            incl %ecx
        
            pushl %ecx

            pushl $terminator
            pushl $formatprintf
            pushl %eax
            call fprintf
            popl %eax
            popl %ebx
            popl %ebx

            popl %ecx

            jmp for_i_2
    final:
        popl %edi
        popl %ebx

        popl %ebp
        ret

valid:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx # registrii callee-saved trebuie restaurati de procedura
    pushl %esp
    pushl %esi
    pushl %edi

    movl 8(%ebp), %eax
    movl %eax, lin
    movl 12(%ebp), %eax
    movl %eax, col
    movl 16(%ebp), %eax
    movl %eax, val
  
    # for (int j = 0; j < 9; j++)
    movl $0, %ebx 
    for_j_9:
        cmp $9, %ebx
        je et_cont

        # if (mat[lin][j] == val) return 0;
        movl lin, %eax # mat[9 * lin + j]
        movl $9, %ecx
        movl $0, %edx
        mull %ecx # eax = 9 * lin
        addl %ebx, %eax # eax = 9 * lin + j
        
        movl $mat, %edi
        movl (%edi, %eax, 4), %ecx # ecx = mat[9 * lin + j]

        cmp val, %ecx
        je et_ret_0

        incl %ebx
        jmp for_j_9
    et_cont:
        movl $0, %ebx 
        for_i_9:
            cmp $9, %ebx
            je et_cont_verif

            # if (mat[i][col] == val) return 0;
            movl %ebx, %eax # mat[9 * i + col]
            movl $9, %ecx
            movl $0, %edx
            mull %ecx # eax = 9 * i
            addl col, %eax # eax = 9 * i + col
            
            movl $mat, %edi
            movl (%edi, %eax, 4), %ecx # ecx = mat[9 * i + col]

            cmp val, %ecx
            je et_ret_0

            incl %ebx
            jmp for_i_9

    et_cont_verif:
        # start_lin = lin - lin % 3;
        movl lin, %eax
        movl $3, %ebx
        movl $0, %edx
        divl %ebx
        movl lin, %eax
        subl %edx, %eax
        movl %eax, start_lin

        # start_col = col - col % 3;
        movl col, %eax
        movl $3, %ebx
        movl $0, %edx
        divl %ebx
        movl col, %eax
        subl %edx, %eax
        movl %eax, start_col

        # for (int i = startlin; i < startlin + 3; i++)
        #   for (int j = startcol; j < startcol + 3; j++)
        #     if (mat[i][j] == val)
        #        return 0;
        # return 1;

        movl start_lin, %ebx
        for_i_3:
            movl start_lin, %eax
            addl $3, %eax 
            cmp %ebx, %eax
            je et_ret_1

            movl start_col, %ecx
            for_j_3:
                movl start_col, %eax
                addl $3, %eax 
                cmp %ecx, %eax
                je et_cont_for_i_3

                pushl %ecx

                movl %ebx, %eax # mat[9 * i + j]
                movl $9, %ecx
                movl $0, %edx
                mull %ecx # eax = 9 * i

                popl %ecx
                addl %ecx, %eax # eax = 9 * i + j
                
                movl $mat, %edi
                movl (%edi, %eax, 4), %edx # edx = mat[9 * i + j]

                cmp val, %edx
                je et_ret_0

                incl %ecx
                jmp for_j_3

            et_cont_for_i_3:
                incl %ebx
                jmp for_i_3 


    et_ret_1:
        movl $1, %eax

        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx

        popl %ebp
        ret
    et_ret_0:
        movl $0, %eax

        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx 

        popl %ebp
        ret

bkt_sudoku:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx # registrii callee-saved trebuie restaurati de procedura
    pushl %esp
    pushl %esi
    pushl %edi

    movl 8(%ebp), %eax
    movl %eax, lin
    movl 12(%ebp), %eax
    movl %eax, col

    # if (lin == 8 && col == 9)
    movl lin, %eax 
    cmp $8, %eax
    jne et_not_afis
    
    movl col, %eax
    cmp $9, %eax
    je et_afis
    jne et_not_afis

    et_afis:
        call afis
        jmp et_exit
    et_not_afis:

        # if (col == 9)
        movl col, %eax
        cmp $9, %eax
        jne et_not_col_9
        
        incl lin # lin++;
        movl $0, %eax # col = 0;
        movl %eax, col

        et_not_col_9:
            # if(mat[lin][col] == 0)
            movl lin, %eax # mat[9 * lin + col]
            movl $9, %ecx
            movl $0, %edx
            mull %ecx # eax = 9 * lin
            addl col, %eax # eax = 9 * lin + col
            
            movl $mat, %edi
            movl (%edi, %eax, 4), %ebx # ebx = mat[9 * lin + col]

            cmp $0, %ebx # if(mat[lin][col] == 0)
            jne et_else
            # for (int val = 1; val <= 9; val++)
            movl $1, %eax
            movl %eax, val
            et_for:
                movl val, %eax
                cmp $9, %eax
                jg et_final

                # valid(lin, col, val) returneaza 1 sau 0 in eax
                pushl val
                pushl col
                pushl lin
                call valid
                popl lin
                popl col
                popl val

                cmp $1, %eax
                jne et_nu_e_valid

                # mat[lin][col] = val;
                movl lin, %eax # mat[9 * lin + col] = val
                movl $9, %ecx
                movl $0, %edx
                mull %ecx # eax = 9 * lin
                addl col, %eax # eax = 9 * lin + col
                
                movl $mat, %esi
                movl val, %ebx
                movl %ebx, (%esi, %eax, 4) # mat[9 * lin + col] = val

                # bkt_sudoku(lin, col+1);
                pushl col
                pushl val

                # bkt_sudoku(lin, col+1);
                movl col, %eax
                addl $1, %eax
                pushl %eax
                pushl lin
                call bkt_sudoku
                popl lin
                popl %eax

                popl val
                popl col

                et_nu_e_valid: # mat[lin][col] = 0;

                    movl lin, %eax # mat[9 * lin + col] = 0
                    movl $9, %ecx
                    movl $0, %edx
                    mull %ecx # eax = 9 * lin
                    addl col, %eax # eax = 9 * lin + col
                    
                    movl $mat, %esi
                    movl $0, %ebx
                    movl %ebx, (%esi, %eax, 4) # mat[9 * lin + col] = 0
                incl val
                jmp et_for

            et_else:

                pushl col

                # bkt_sudoku(lin, col+1);
                movl col, %eax
                addl $1, %eax
                pushl %eax
                pushl lin
                call bkt_sudoku
                popl lin
                popl %eax

                popl col

    et_final:

        popl %edi # registrii callee-saved trebuie restaurati de procedura
        popl %esi
        popl %esp
        popl %ebx

        popl %ebp
        ret

.global main

main:
    # for(int i = 0; i < 9; i++){
    #        for(int j = 0; j < 9; j++){
    #            in >> mat[i][j];
    #        }
    # }
    
    pushl $format_read # open input file, file pointer in eax
    pushl $input_file
    call fopen
    popl %ebx
    popl %ebx

    movl $-1, %ecx
    for_i:
        incl %ecx
        cmp $9, %ecx
        je et_close_input_file
        
        movl $0, %ebx
        for_j:

            cmp $9, %ebx
            je for_i
    
            pushl %ecx

            pushl $x
            pushl $formatscanfint
            pushl %eax
            call fscanf
            popl %eax
            popl %edx
            popl %edx

            popl %ecx

            pushl %ecx
            pushl %eax

            movl $mat, %esi 
            movl $9, %eax
            movl $0, %edx
            mull %ecx
            addl %ebx, %eax
            movl x, %edx
            movl %edx, (%esi, %eax, 4)

            popl %eax
            popl %ecx

            incl %ebx
            jmp for_j

et_close_input_file:
    pushl %eax
    call fclose
    popl %ebx

et_call_bkt:
    # bkt_sudoku(0, 0);
    pushl $0
    pushl $0
    call bkt_sudoku
    popl %ebx
    popl %ebx

et_print_nu_exista:
    pushl $format_write # open output file, file pointer in eax
    pushl $output_file
    call fopen
    popl %ebx
    popl %ebx

    pushl $str_nu_exista
    pushl $formatprintf
    pushl %eax
    call fprintf
    popl %eax
    popl %ebx
    popl %ebx
    
et_exit:

    pushl %eax # close output file
    call fclose
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80