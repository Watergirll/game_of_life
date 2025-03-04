.data
    matrix: .space 1600
    m: .space 4
    n: .space 4

    p: .space 4
    k: .space 4 

    i: .space 4
    j: .space 4

    nafis: .space 4
    v_sum: .space 1600

    format_input_1: .asciz "%d%d%d"
    format_input_2: .asciz "%d%d"
    format_input_3: .asciz "%d"

    format_output: .asciz "%d "
    newline: .asciz "\n"

    fisin: .asciz "in.txt"
    fisout: .asciz "out.txt"
    formfisin: .asciz "r"
    formfisout: .asciz "w"
    pointer: .space 4

.text

.global main
main:

    //deschidere fisier de citire

    pushl $formfisin
    pushl $fisin
    call fopen
    popl %ebx
    popl %ebx

    debug:
    movl %eax, pointer

    // fin >> m >> n >> p

    pushl $p
    pushl $n
    pushl $m
    pushl $format_input_1
    pushl pointer
    call fscanf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    //n += 2
    addl $2, n

    /*for (k = 1; k <= p; k++)
    {
        cin >> i >> j;
        mat[ i + 1 ][ j + 1 ] = 1;
    }    */


    mov $1, %ecx
    loop_citire:
        cmp %ecx, p
        jl incepe_jocul

        //fin >> i >> j
        
        pushl %ecx
        pushl $j    
        pushl $i     
        pushl $format_input_2
        pushl pointer
        call fscanf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx    
        popl %ecx
        
        //mat[ i + 1 ][ j + 1 ] = 1;
        //unde [i+1][j+1] = j + i * (n+2) -> formula index celula
        lea matrix, %edi
        movl i, %eax
        inc %eax
        mull n
        add j, %eax
        inc %eax
        movl $1, (%edi, %eax, 4)

        inc %ecx
        jmp loop_citire


incepe_jocul:

    // fin >> k
    pushl $k        
    pushl $format_input_3
    pushl pointer
    call fscanf
    popl %ebx
    popl %ebx
    popl %ebx

    //fin.close();
    pushl pointer
    call fclose
    popl %ebx

    // setez corect n-ul pt for uri (nafis)
    movl n, %eax
    movl %eax, nafis
    subl $2, nafis

    movl $0, p
    fork_runde:
        addl $1, p
        movl p, %eax
        cmp %eax, k
        jl afisare_rezultat
    /*suma vecinilor:
        for (i = 1; i <= m; i++)  
            for (j = 1; j <= n; j++)
                s[j + (i - 1) * n] = mat[i - 1][j - 1] + mat[i - 1][j] + mat[i - 1][j + 1] + 
                                     mat[i][j - 1] + mat[i][j + 1] + mat[i + 1][j - 1] + 
                                     mat[i + 1][j] + mat[i + 1][j + 1];
    */
    suma_vecini_1tura:

        movl $0, i
        linie:
            addl $1, i
            movl i, %ecx
            cmp %ecx, m
            jl schimbare_matr

            movl $0, j
            coloana:
                addl $1, j
                movl j, %ecx
                cmp %ecx, nafis
                jl linie

                suma_pe_un_elem:

                    lea matrix, %edi

                    //se[j + i * n] = 0; se += mat[i - 1][j - 1];
                    movl $0, %ebx
                    movl i, %eax
                    dec %eax
                    mull n
                    addl j, %eax
                    dec %eax
                    addl (%edi, %eax, 4), %ebx

                    //se[j + i * n] += mat[i - 1][j]; se += mat[i - 1][j + 1];
                    inc %eax
                    addl (%edi, %eax, 4), %ebx
                    inc %eax
                    addl (%edi, %eax, 4), %ebx

                    //se[j + i * n] += mat[i][j - 1] + mat[i][j + 1];
                    movl i, %eax
                    mull n
                    addl j, %eax
                    dec %eax
                    addl (%edi, %eax, 4), %ebx
                    inc %eax
                    inc %eax
                    addl (%edi, %eax, 4), %ebx

                    //se[j + i * n] += mat[i + 1][j - 1] + mat[i + 1][j] + mat[i + 1][j + 1];
                    movl i, %eax
                    inc %eax
                    mull n
                    addl j, %eax
                    dec %eax
                    addl (%edi, %eax, 4), %ebx
                    inc %eax
                    addl (%edi, %eax, 4), %ebx
                    inc %eax
                    addl (%edi, %eax, 4), %ebx

                    //se <- %ebx
                    lea v_sum, %edi
                    movl i, %eax
                    mull n
                    addl j, %eax
                    movl %ebx, (%edi, %eax, 4)

                    jmp coloana

    /*
        for de schimbare matrix in functie de cond
        int se = s[j + (i - 1) * n];
        if (se == 3)
            mat[i][j] = 1;
        else if(se != 2)
            mat[i][j] = 0;
    */
        schimbare_matr:

            movl $0, i
            linies:
                addl $1, i
                movl i, %ecx
                cmp %ecx, m
                jl fork_runde

                movl $0, j
                coloanas:
                    addl $1, j
                    movl j, %ecx
                    cmp %ecx, nafis
                    jl linies

                    schimbare_elem:
                    //int se = s[j + (i - 1) * n];
                    lea v_sum, %edi
                    movl i, %eax
                    mull n
                    addl j, %eax
                    movl (%edi, %eax, 4), %ebx

                    /*
                    if (se == 3)
                        mat[i][j] = 1;
                    else if(se != 2)
                        mat[i][j] = 0;
                    */

                    cmp $3, %ebx
                    je schimb1
                    cmp $2, %ebx
                    jne schimb0
                    jmp coloanas

                    schimb1:
                    lea matrix, %edi
                    movl i, %eax
                    mull n
                    addl j, %eax
                    movl $1, (%edi, %eax, 4)
                    jmp coloanas

                    schimb0:
                    lea matrix, %edi
                    movl i, %eax
                    mull n
                    addl j, %eax
                    movl $0, (%edi, %eax, 4)
                    jmp coloanas



afisare_rezultat:
    //deschidere fisier de afisare
    pushl $formfisout
    pushl $fisout
    call fopen
    popl %ebx
    popl %ebx
    movl %eax, pointer

    lea matrix, %edi

    movl $1, i
    afis:

        movl $1, j
        afis_linie:

            movl n, %eax
            mull i
            mov %eax, %ecx
            addl j, %ecx

            movl (%edi, %ecx, 4), %ebx
            pushl %ebx
            pushl $format_output
            pushl pointer
            call fprintf
            popl %ebx
            popl %ebx
            popl %ebx

            push $0
            call fflush
            pop %ebx 

            addl $1, j
            mov j, %ecx
            cmp nafis, %ecx
            jle afis_linie

        //fout<<endl;
        pushl $newline
        pushl pointer
        call fprintf
        popl %ebx
        popl %ebx
                
        push $0
        call fflush
        pop %ebx

        addl $1, i
        movl i, %ecx
        cmp m, %ecx
        jle afis
                

et_exit:
    //fout.close();
    pushl pointer
    call fclose
    popl %ebx

    push $0
    call fflush
    pop %ebx
    
    movl $1, %eax 
    xor %ebx, %ebx
    int $0x80