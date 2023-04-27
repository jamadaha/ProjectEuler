; compile : nasm -f elf32 .asm; gcc -no-pie -m32 -o out .o; ./out
; -------------------------------------------------------------------------------------------------
;
;  Project Euler - Problem 1
;  If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9.
;  The sum of these multiples is 23.
;  Find the sum of all the multiples of 3 or 5 below 1000.
;
; -------------------------------------------------------------------------------------------------
		global	main
		extern	printf

		section .data
		msg	db "%i", 0x0a, 0x00		


		section	.text
main:		push 	ebp
		mov	ebp, esp
		
		xor 	edi, edi			; sum = 0
		xor	esi, esi			; i = 0

		; calculate sum		
loop:		
		; check division by 3
		mov	eax, esi
		xor	edx, edx
		mov	ebx, 3
		div	ebx
		cmp	edx, 0
		je	divisible
		
		; check division by 5
		mov	eax, esi
		xor	edx, edx
		mov	ebx, 5
		div	ebx
		cmp	edx, 0
		je	divisible

		; non-divisible
		jmp	increment

divisible:	add	edi, esi

increment:	inc	esi
		cmp	esi, 1000
		jne	loop				; if esi < 1000

		; printing
		push	edi
		push	msg
		call	printf

		; handle stack stuff
		mov	eax, 0			; return code
		mov	esp, ebp
		pop 	ebp
		ret	
