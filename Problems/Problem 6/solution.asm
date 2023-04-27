; compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ---------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 6
;
;  The sum of the squares of the first ten natural numbers is,
;    1² + 2² + ... + 10² = 385
;  The square of the sum of the first ten natural numbers is,
;    (1 + 2 + ... + 10)² = 55² = 3025
;  Hence the difference between the sum of the squares of the first ten natural numbers
;  and the square of the sum is 3025 - 385 = 2640
;  Find the difference between the sum of the squares of the first one hundred natural numbers
;  and the square of the sum.
;
; ---------------------------------------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i",  0x0a, 0x00		

                section         .text
main:           push            ebp
                mov             ebp, esp

                ; init values		
                xor             edi, edi                        ; sum of squares
                xor             esi, esi                        ; square of sums

                ; sum of squares
                mov             ebx, 1
loop_1:         mov             eax, ebx
                mul             eax  
                add             edi, eax
                inc ebx
                cmp             ebx, 100
                jle             loop_1

                ; square of sums
                ;; sum
                mov             ebx, 1
loop_2:         add             esi, ebx
                inc             ebx
                cmp             ebx, 100
                jle             loop_2

                ;; square
                mov             eax, esi
                mul             eax

                ; diff
                sub             eax, edi

                ; printing
                push            eax
                push            msg
                call            printf
                
                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
