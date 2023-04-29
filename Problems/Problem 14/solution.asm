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
msg:            db              "Index: %i, Step Count: %i", 0xa, 0x00	
nl_msg:         db              "", 0x0a, 0x00	
num_msg:        db              "%i", 0x00
                ; NOTE: arrays are used to store indexes to allow numbers bigger than 32-bit allows
working_index:  db              64 dup(0)                       ; head of collatz chain
current_index:  dw              1

                section         .text
main:           push            ebp
                mov             ebp, esp

                ; init
                xor             edi, edi                        ; best step count
                xor             esi, esi                        ; best index

                
                ; calculate collatz
                ;; load current index into working index
collatz:        push            esi                             ; temp usage as a copy of current index
                mov             esi, dword [current_index] 
                mov             byte [working_index + 63], 0    ; might be 1 from last check
                mov             ecx, 63
load_loop:      mov             eax, esi
                xor             edx, edx
                mov             ebx, 10
                div             ebx
                mov             byte [working_index + ecx], dl  ; remainder is always less than 10
                mov             esi, eax
                cmp             ecx, 0
                je              load_done
                dec             ecx
                cmp             esi, 0
                jne             load_loop
load_done:      mov             ebx, 1
                pop             esi
non_one:        ;; check whether odd/even
                mov             al, byte [working_index + 63]
                test            al, 1
                jz              even
                ;; multiple by 3 and add 1
odd:            ;;; first multiplies the values stored in the bytes by three
                xor             ecx, ecx
                xor             eax, eax
mul_loop:       mov             al, byte [working_index + ecx]
                mov             edx, 3
                mul             edx
                mov             byte [working_index + ecx], al
                inc             ecx
                cmp             ecx, 64
                jl              mul_loop
                ;;; then the values in each byte is propagated up
                mov             ecx, 63
mul_prop_loop:  cmp             ecx, 0
                je              mul_inc
                mov             al, byte [working_index + ecx]
                dec             ecx
                cmp             al, 10
                jl              mul_prop_loop
                inc             byte [working_index + ecx]
                inc             ecx
                sub             al, 10
                mov             byte [working_index + ecx], al
                jmp             mul_prop_loop
                ;;; increment with one, then handle overflow
mul_inc:        inc             byte [working_index + 63]
                mov             al, byte [working_index + 63]
                cmp             al, 10
                jne             bound_check
                ;;; handle overflow
                mov             ecx, 63
inc_prop_loop:  cmp             ecx, 0
                je              bound_check
                mov             byte [working_index + ecx], 0
                dec             ecx
                inc             byte [working_index + ecx]
                cmp             byte [working_index + ecx], 10
                je              inc_prop_loop
                jmp             bound_check
                ;; divide by 2
even:           xor             ecx, ecx
                xor             eax, eax
div_loop:       mov             al, byte [working_index + ecx]
                test            al, 1
                jz              div_even
div_odd:        sar             al, 1
                add             al, ah
                mov             byte [working_index + ecx], al
                mov             ah, 5
                inc             ecx
                cmp             ecx, 64
                jne             div_loop
                jmp             bound_check
div_even:       sar             al, 1
                add             al, ah
                mov             byte [working_index + ecx], al
                xor             ah, ah
                inc             ecx
                cmp             ecx, 64
                jne             div_loop
                ;; check if reached 1
bound_check:    inc             ebx
                xor             ecx, ecx
one_check:      mov             al, byte [working_index + ecx]
                cmp             al, 0
                jne             non_one
                inc             ecx
                cmp             ecx, 63
                jne             one_check
                mov             al, byte [working_index + 63]
                cmp             al, 1
                jne             non_one
                ;; on collatz done for current index
                ;; check if more steps
c_next_step:    cmp             ebx, edi
                jl              next_step
                mov             edi, ebx
                mov             esi, [current_index]
                ;; increment current step if not reached max
next_step:      inc             dword [current_index]
                mov             eax, dword [current_index]
                cmp             eax, 1000000
                jl              collatz

                ; print
print:          push            edi
                push            esi
                push            msg
                call            printf

                ; handle stack stuff
                mov             eax, 0                          ; return code
                mov             esp, ebp
                pop             ebp
                ret
