; compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ------------------------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 14
;
;  The following iterative sequence is defined for the set of positive integers:
;
;    n → n/2 (n is even)
;    n → 3n + 1 (n is odd)
;
;  Using the rule above and starting with 13, we generate the following sequence:
;
;    13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
;
;  It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms.
;  Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
;  
;  Which starting number, under one million, produces the longest chain?
;
;  NOTE: Once the chain starts the terms are allowed to go above one million.
;
; ------------------------------------------------------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i, %i", 0xa, 0x00	
msgn:           db              "", 0x0a, 0x00	

                section         .text
main:           push            ebp
                mov             ebp, esp
                
                mov             esi, 1                        ; best index
                xor             edi, edi                      ; best step count

                mov             ebx, 1                        ; current index
index:          mov             eax, ebx                      ; working index
                mov             edx, 1                        ; step count
loop:           test            eax, 1                        ; check odd/even
                jz              even
odd:            mov             ecx, 3
                push            edx
                mul             ecx
                pop             edx
                inc             eax
                jmp             iterate
even:           sar             eax, 1
iterate:        cmp             eax, 1
                je              check
                inc             edx
                jmp             loop
check:          cmp             edx, edi
                jl              next_index
                mov             edi, edx
                mov             esi, ebx
next_index:     inc             ebx
                cmp             ebx, 10000
                je              done
                jmp             index             

done:           inc             edi
                ; print
                push            edi
                push            esi
                push            msg
                call            printf

                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
