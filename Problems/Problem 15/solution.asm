; compile : nasm -f elf32 solution.asm; gcc -no-pie -m32 -o out solution.o; ./out
; ------------------------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 15
;
;  Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there are exactly 6 routes to the bottom right corner.
;
;  See https://projecteuler.net/problem=15 for picture
;
;  How many such routes are there through a 20×20 grid?
;
;  Doesn't work for 20x20 grid, as the number of paths is more than can a 32-bit number can represent
;
; ------------------------------------------------------------------------------------------------------------
                global          main
                extern          printf

                section         .data
msg:            db              "%i", 0x0
msg_nl:         db              "", 0xa, 0x0
count:          db              32 dup(0)

                section         .text
main:           push            ebp
                mov             ebp, esp

                xor             ebx, ebx

                mov             esi, 20                         ; grid size
                push            0                               ; initial y pos
                push            0                               ; initial x pos
                call            flood_fill
               
                xor             edi, edi
zero_purge:     cmp             byte [count + edi], 0
                jne             print_loop
                inc             edi
                jmp             zero_purge
print_loop:     xor             eax, eax
                mov             al, byte [count + edi]
                push            eax
                push            msg
                call            printf
                inc             edi
                cmp             edi, 32
                jne             print_loop
finish_print:   push            msg_nl
                call            printf


                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
                
                ; 2 parameters
                ; x position - 32 bit unsigned
                ; y position - 32 bit unsigned
                ; max x pos should be stored in esi
                ; max y pos should be stored in edi
flood_fill:     push            ebp                             ; save old base pointer
                mov             ebp, esp                        ; set new base pointer
                
                xor             edx, edx                        ; clear edx to use as temp return
                mov             ebx, [ebp+8]                    ; move parameter 1 into ebx
                mov             ecx, [ebp+12]                   ; move parameter 2 into ecx

                ; check if reached goal
check:          cmp             ebx, esi
                jne             flood_x
                cmp             ecx, esi
                jne             flood_y
inc_count:      inc             byte [count + 31]
                push            ecx
                xor             eax, eax
                mov             ecx, 31
prop_inc:       mov             al, byte [count + ecx]
                cmp             al, 10
                jne             inc_return
                mov             byte [count + ecx], 0
                dec             ecx
                inc             byte [count + ecx]
                jmp             prop_inc
inc_return:     pop             ecx
                jmp             return

                ; flood
flood_x:        inc             ebx
                push            ecx
                push            ebx
                call            flood_fill
                add             esp, 8
                dec             ebx
flood_check_y:  cmp             ecx, esi
                je              return
flood_y:        inc             ecx
                push            ecx
                push            ebx
                call            flood_fill
                add             esp, 8
                dec             ecx

return:         mov             esp, ebp
                pop             ebp
                ret
