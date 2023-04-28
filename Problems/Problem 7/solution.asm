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
found:          dw              2

                section         .text
main:           push            ebp
                mov             ebp, esp
               
                ; init 
                mov             ebx, 5                          ; value
                ; find prime
is_prime:       xor             edi, edi                          ; outer value
                xor             esi, esi                          ; inner value
                ; check whether current value is product of the values
check_value:    mov             eax, edi
                mul             esi
                cmp             eax, ebx
                jne             loop                            ; goto loop if not product
                inc             ebx
                jmp             is_prime                        ; found product, check next value
                ; looping
loop:           inc             esi
                cmp             esi, ebx
                jl              check_value
                inc             edi
                mov             esi, edi
                mov             eax, edi
                mul             eax
                cmp             eax, ebx
                jle             check_value
                inc             dword [found]                   ; found prime
                cmp             dword [found], 10001            ; if target
                je              done                            ; goto done
                add             ebx,2                           ; else increment, and try next
                jmp             is_prime                

                ; printing
done:           push            ebx
                push            msg
                call            printf
                
                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
