;  compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ---------------------------------------------------------------
;
;  Project Euler - Problem 3
;  The prime factors of 13195 are 5, 7, 13 and 29.
;  What is the largest prime factor of the number 600851475143 ?
;
;  This does find the largest prime factor of numbers correctly
;  However, the asked for number cannot be stored in 32 bit
;  As such, this can not solve it
;
; ---------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i",  0x0a, 0x00		
numc:           db              "%i,", 0x00
factorCount:    dw              0

                section         .bss
factors:        resw            10000

                section         .text
main:           push            ebp
                mov             ebp, esp

                ; init values		
                mov             esi, 600851475143
                mov             edi, 2
 
                ; calculate factors
loop:           mov             eax, esi
                xor             edx, edx
                mov             ebx, edi
                div             ebx
                cmp             edx, 0
                jne             non_divisible
                mov             ecx, [factorCount]
                mov             dword [factors + ecx * 4], edi
                inc             dword [factorCount]
                mov             esi, eax
                jmp             loop
non_divisible:  inc             edi
                cmp             esi, 1
                jg              loop                

                ; printing
                xor             esi, esi
print:          mov             edi, [factors + esi * 4]
                push            edi
                inc             esi
                cmp             esi, [factorCount]
                je              last
                push            numc
                jmp             output
last:           push            msg
output:         call            printf
                cmp             esi, [factorCount]
                jl              print
                
                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
