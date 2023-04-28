; compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ------------------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 7
;
;  By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
;  What is the 10 001st prime number?
;
; ------------------------------------------------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i",  0x0a, 0x00		
state:          db              "val: %i, edi: %i, esi %i",  0x0a, 0x00		
hitn:           db              "done",  0x0a, 0x00		

                section         .text
main:           push            ebp
                mov             ebp, esp
               
                ; init
                mov             edi, 2                          ; found
                mov             esi, 5                          ; value
                
                ; find prime by index
is_prime:       mov             ecx, 2                          ; set ecx to 0
check_value:    mov             eax, esi
                xor             edx, edx
                div             ecx
                cmp             edx, 0
                je              not_prime
                inc             ecx
                mov             eax, ecx
                mov             ebx, 2
                mul             ebx
                cmp             eax, esi
                jl              check_value
                jmp             found_prime
not_prime:      inc             esi
                jmp             is_prime                
found_prime:    inc             edi
                cmp             edi, 10001                      ; check whether it is prime of index
                je              done
                inc             esi
                jmp             is_prime

                ; printing
done:           push            esi
                push            msg
                call            printf
                
                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
