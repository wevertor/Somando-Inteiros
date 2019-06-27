        .8086
        .model  small
        .stack  256

        .data
msg1    db      'Insira o primeiro numero:',0Dh,0Ah,'$'
msg2    db      'Insira o segundo numero:',0Dh,0Ah,'$'
ln      db      0Dh,0Ah,'$'
var1    db      4, ?, 4 dup(0)
var2    db      4, ?, 4 dup(0)
result  db      4, ?, 4 dup(0)

        .code
main    proc

        ;inicialização
        mov     ax, @data
        mov     ds, ax

        ;guarda o primeiro numero
        lea     dx, msg1    ;coloca a referencia da string em dx
        call    Print       ;printa o que esta na string
        lea     dx, var1    ;coloca a referencia do vetor em dx
        call    Ler         ;escreve no vetor

        ;guarda o segundo numero
        lea     dx, msg2
        call    Print
        lea     dx, var2
        call    Ler

        mov     ah, (var1+1*2)  ;coloca o sinal do primeiro numero em ah
        mov     al, (var2+1*2)  ;coloca o sinal do segundo numero em al
        cmp     al, ah          ;compara os dois
        je      iguais          ;se forem iguais
        jne     diferentes      ;se forem diferentes

iguais:
        mov     result+1, al
        jmp     soma

diferentes:
        mov     dh, ah
        mov     dl, al
        jmp     subt

soma:
        ;armazenando o primeiro numero em bx
        mov     ah, (var1+3)    ;coloca o digito das dezenas em ah
        mov     al, (var1+2*2)  ;coloca o digito das unidades em al (*2 porque pula 1 bit)
        aaa                     ;converte o digito de al (unidades) ascii pra decimal
        mov     bl, al          ;guarda o digito das unidades em bl
        mov     al, ah          ;coloca o digito das dezenas em ah para converter
        aaa                     ;converte o digito das dezenas para decimal
        mov     bh, al          ;guarda o digito das dezenas em bh
        mov     ax, bx          ;move tudo que esta em bx para ax para juntar os dois digitos em al
        aad                     ;junta os dois digitos decimais e converte o numero para hexadecimal
        mov     bl, al          ;guarda o numero em bl

        ;armazenando o segundo numero em cx
        mov     ah, (var2+3)    ;coloca o digito das dezenas em ah
        mov     al, (var2+2*2)  ;coloca o digito das unidades em al
        aaa                     ;converte o digito de al (unidades) ascii pra decimal
        mov     cl, al          ;guarda o digito das unidades em bl
        mov     al, ah          ;coloca o digito das dezenas em ah para converter
        aaa                     ;converte o digito das dezenas para decimal
        mov     ch, al          ;guarda o digito das dezenas em ch
        mov     ax, cx          ;move tudo que esta em cx para ax para juntar os dois digitos em al
        aad                     ;junta os dois digitos decimais e converte o numero para hexadecimal
        mov     cl, al          ;guarda o numero em cl

        ;soma
        add     bl, cl          ;soma os dois numeros
        mov     al, bl          ;coloca o resultado da soma em al
        aam                     ;converte para decimal
        add     ax, 3030h       ;converte para ascii
        mov     cx, ax          ;coloca o numero em ascii em cx (ch - dezenas, cl - unidade)
        mov     (result+2), ch  ;coloca o digito das dezenas no vetor
        mov     (result+3), cl  ;coloca o digito das unidades
        call    resultado       ;printa resultado
        call    Encerrar        ;encerra

subt:
        ;armazenando o primeiro numero em bx
        mov     ah, (var1+3)    ;coloca o digito das dezenas em ah
        mov     al, (var1+2*2)  ;coloca o digito das unidades em al (*2 porque pula 1 bit)
        sub     al, 30h         ;converte o digito de al (unidades) ascii pra decimal
        mov     bl, al          ;guarda o digito das unidades em bl
        mov     al, ah          ;coloca o digito das dezenas em ah para converter
        sub     al, 30h         ;converte o digito das dezenas para decimal
        mov     bh, al          ;guarda o digito das dezenas em bh
        mov     ax, bx          ;move tudo que esta em bx para ax para juntar os dois digitos em al
        aad                     ;junta os dois digitos decimais e converte o numero para hexadecimal
        mov     bl, al          ;guarda o numero em bl

        ;armazenando o segundo numero em cx
        mov     ah, (var2+3)    ;coloca o digito das dezenas em ah
        mov     al, (var2+2*2)  ;coloca o digito das unidades em al
        sub     al, 30h         ;converte o digito de al (unidades) ascii pra decimal
        mov     cl, al          ;guarda o digito das unidades em bl
        mov     al, ah          ;coloca o digito das dezenas em ah para converter
        sub     al, 30h          ;converte o digito das dezenas para decimal
        mov     ch, al          ;guarda o digito das dezenas em ch
        mov     ax, cx          ;move tudo que esta em cx para ax para juntar os dois digitos em al
        aad                     ;junta os dois digitos decimais e converte o numero para hexadecimal
        mov     cl, al          ;guarda o numero em cl

        ;subt
        cmp    bl, cl          ;compara os dois numeros
        jg     bl_maior        ;se o primeiro numero for maior
        jle    cl_maior        ;se o segundo numero for maior

bl_maior:
        mov     result+1, dh    ;coloca o sinal +
        sub     bl, cl          ;subtrai os dois numeros
        mov     al, bl          ;coloca o resultado da subtracao em al
        aam                     ;converte para decimal
        or     ax, 3030h        ;converte para ascii
        mov     cx, ax          ;coloca o numero em ascii em cx (ch - dezenas, cl - unidade)
        mov     (result+2), ch  ;coloca o digito das dezenas no vetor
        mov     (result+3), cl  ;coloca o digito das unidades
        call    resultado       ;printa resultado
        call    Encerrar        ;encerrar

cl_maior:
        mov     result+1, dl    ;coloca o sinal -
        sub     cl, bl          ;subtrai os dois numeros
        mov     al, cl          ;coloca o resultado da subtracao em al
        aam                     ;converte para decimal
        or     ax, 3030h        ;converte para ascii
        mov     bx, ax          ;coloca o numero em ascii em bx (bh - dezenas, bl - unidade)
        mov     (result+2), bh  ;coloca o digito das dezenas no vetor
        mov     (result+3), bl  ;coloca o digito das unidades
        call    resultado       ;printa resultado
        call    Encerrar        ;encerrar

main    endp

Print   proc    near
        mov     ah, 09h
        int     21h
        ret
Print   endp

Ler     proc    near
        mov     ah, 0Ah
        int     21h
        ret
Ler     endp

Printchar proc  near
          mov   ah, 02h
          int   21h
          ret
Printchar endp

Pulalinha proc  near
          ;pula linha
          mov     dx, offset ln
          call    Print
Pulalinha endp

Resultado proc  near
          mov   dl, (result+1)
          call  Printchar
          mov   dl, (result+2)
          call  Printchar
          mov   dl, (result+3)
          call  Printchar
Resultado endp

Encerrar proc   near
        mov     ah, 4Ch
        int     21h
        ret
Encerrar endp

        end     main
