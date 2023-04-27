;  compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ------------------------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 5
;  2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
;  What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
;
; ------------------------------------------------------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i",  0x0a, 0x00		

                section         .text
main:           push            ebp
                mov             ebp, esp

                ; init values		
                mov             esi, 1                          ; init to min
		mov             edi, 1

		; find num
loop:           mov             eax, edi
                xor             edx, edx
                div             esi
                cmp             edx, 0
                je              divisible
                inc             edi
                mov             esi, 1                          ; reset to min
                jmp             loop
divisible:      inc             esi
                cmp             esi, 20                         ; while less than max
                jl              loop

                ; printing
                push            edi
                push            msg
                call            printf
                
                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
