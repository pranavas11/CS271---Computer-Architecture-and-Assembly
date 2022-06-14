TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 03/15/2022
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: Final                Due Date: 03/15/2022
; Description: this program implements a simple substitution cipher

INCLUDE Irvine32.inc

.data
													; Decoy Data Values
	;operand1   WORD    -32768
	;operand2   WORD    -32768
	;dest       DWORD   0

													; Encryption Data Values
	;myKey      BYTE   "efbcdghijklmnopqrstuvwxyza"
	;message    BYTE   "the contents of this message will be a mystery.", 0
	;dest       DWORD   -1

													; Decryption Data Values
	;myKey      BYTE   "efbcdghijklmnopqrstuvwxyza"
	;message    BYTE   "uid bpoudout pg uijt ndttehd xjmm fd e nztudsz.", 0
	;dest       DWORD   -2
	
													; Key Generation Data Values
	;newKey     BYTE    26    DUP(?), 0
	;dest       DWORD   -3

.code
main PROC
	call	Randomize					; Irvine library procedure for initializing the random number generator

													; Decoy
	;push   operand1
	;push   operand2
	;push   OFFSET dest
	;call   compute
	;mov    eax, dest					; currently dest holds a value of +26
	;call   WriteInt					; should display +26
	
													; Encryption
	;push   OFFSET myKey
	;push   OFFSET message
	;push   OFFSET dest
	;call   compute						;;; message now contains the encrypted string
	;mov    edx, OFFSET message
	;call   WriteString					;;; should display "uid bpoudout pg uijt ndttehd xjmm fd e nztudsz."

													; Decryption
	;push   OFFSET myKey
	;push   OFFSET message
	;push   OFFSET dest
	;call   compute						;;; message now contains the decrypted string
	;mov    edx, OFFSET message
	;call   WriteString					;;; should display "the contents of this message will be a mystery."

													; Key Generation
	;push   OFFSET newKey
	;push   OFFSET dest
	;call   compute
	;; newKey now contains a randomly generated key.
	;; The key will contain all 26 letters of the alphabet (arranged in a random order). Note that newKey is not NULL terminated.

	exit								; exit to operating system
main ENDP

; Description: calls the appropriate substitution cypher function based on destination
; Receives: parameters of different types corresponding to function being called pushed onto the stack
; Returns: sum for Decoy [OR] encrypted/decrypted message [OR] randomly generated key
; Preconditions: paramters pushed onto the stack
; Registers Changed: eax, ebx, ebp
Compute		PROC
	; "Welcome to my Substitution Cypher program, Sadie!"

	push	ebp
	mov		ebp, esp

	mov		eax, [ebp + 8]					; address of "destination" is stored eax
	mov		ebx, [eax]						; dereferenced eax will move its actual value to ebx
	cmp		ebx, -1
	je		encrypt
	cmp		ebx, -2
	je		decrypt
	cmp		ebx, -3
	je		key_gen

													; Decoy mode
	push	WORD PTR [ebp + 14]				; push "operand1" value onto stack
	push	WORD PTR[ebp + 12]				; push "operand2" value onto stack
	push	[ebp + 8]						; push "destination" value onto stack
	call	Decoy
	jmp		exit1

	encrypt:
		push	DWORD PTR [ebp + 16]		; push "myKey" value onto stack
		push	DWORD PTR [ebp + 12]		; push "message" value onto stack
		push	DWORD PTR [ebp + 8]			; push "destination" value onto stack
		call	Encryption
		jmp		exit2

	decrypt:
		push	DWORD PTR [ebp + 16]		; push "myKey" value onto stack
		push	DWORD PTR [ebp + 12]		; push "message" value onto stack
		push	DWORD PTR [ebp + 8]			; push "destination" value onto stack
		call	Decryption
		jmp		exit2

	key_gen:
		push	DWORD PTR [ebp + 12]		; push "newKey" value onto stack
		push	DWORD PTR [ebp + 8]			; push "destination" value onto stack
		call	Key_Generation
		jmp		exit1

	exit1:									; for "Decoy" & "Key-Generation" modes
		pop		ebp
		ret		8							; Decoy: 4 + 2 + 2 = 8		&		Key-gen: 4 + 4 = 8
	
	exit2:									; for "Encryption" & "Decryption" modes
		pop		ebp
		ret		12							; 4 + 4 + 4 = 12 (3 parameters of size 4 bytes)
Compute		ENDP

; Description: computes sum of 16-bit operands
; Receives: 2 operands & 1 destination integer
; Returns: sum of the 2 operands
; Preconditions: operands 1 & 2 are 16-bit signed WORDs and destination is a 32-bit signed DWORD
; Registers Changed: eax (ax), ebx (bx), ecx, ebp
Decoy		PROC
	push	ebp
	mov		ebp, esp

	mov		ax, [ebp + 14]					; move value of "operand1" into ax (16-bit register)
	mov		bx, [ebp + 12]					; move value of "operand2" into bx (16-bit register)
	movsx	eax, ax							; sign extend ax register to eax to perform 32-bit addition
	movsx	ebx, bx							; sign extend bx register to ebx to perform 32-bit addition
	add		eax, ebx
	mov		ecx, [ebp + 8]
	mov		[ecx], eax						; store sum (actual value) in dereferenced ecx register

	pop		ebp

	ret		8
Decoy		ENDP

; Description: encrypts a given string of message using the key
; Receives: 2 arrays and 1 destination integer (message, myKey, and destination)
; Returns: encrypted message
; Preconditions: both arrays are 32-bit BYTE arrays and destination is a 32-bit signed DWORD
; Registers Changed: eax (al), ebx (bl), ebp, edi, esi
Encryption		PROC
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp + 16]					; myKey
	mov		edi, [ebp + 12]					; message
		
	encrypt:
		mov		al, [edi]					; move each character in "message" into al register (8-bit)
		cmp		al, 0						; check if it's null-terminated (i.e., 0 represents end of string)
		je		exit1
		cmp		al, 97						; 97 = a (ASCII value)
		jl		loop_back
		cmp		al, 122						; 122 = z (ASCII value)
		jg		loop_back

		sub		al, 97						; subtract current character's decimal value from 97 (letter a) to match the key
		movsx	eax, al						; sign extend al (8-bit) to eax (32-bit)
		mov		bl, [esi + eax]				; [esi + eax] moves to find the correct matching character in "myKey" array starting from index 0
		mov		[edi], bl					; put the encrypted string value back into message (dereferenced)

		loop_back:
			inc		edi						; move to the next character in "message" string
			jmp		encrypt
		
	exit1:

	pop		ebp

	ret		12
Encryption		ENDP

; Description: decrypts a given string of message using the key
; Receives: 2 arrays and 1 destination integer (message, myKey, and destination)
; Returns: decrypted message
; Preconditions: both arrays are 32-bit BYTE arrays and destination is a 32-bit signed DWORD
; Registers Changed: eax (al), ebx (bl), ecx (cl), ebp, edi, esi
Decryption		PROC
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp + 16]					; myKey
	mov		edi, [ebp + 12]					; message

	decrypt:
		mov		ecx, 0
		mov		al, [edi]					; move each character in "message" string to al register (8-bit)
		cmp		al, 0						; check if it's null-terminated (i.e., 0 represents end of string)
		je		exit1
		cmp		al, 97						; 97 = a (ASCII value)
		jl		loop_back
		cmp		al, 122						; 122 = z (ASCII value)
		jg		loop_back
		mov		esi, [ebp + 16]

		inner_loop:			
			mov		bl, [esi]				; move each character in "myKey" to bl register (8-bit)
			cmp		al, bl					; decrypt if equal (i.e., characters match)
			jne		not_equal
			jmp		equal
						
			not_equal:
				inc		esi					; move to the next character in "myKey" to find a match and decrypt
				inc		ecx
				jmp		inner_loop
			
			equal:
				add		ecx, 97				; add current character's decimal value to 97 (letter a) to decrypt the message
				mov		[edi], cl			; put each decrypted character in the original "message" string

			loop_back:
				inc		edi					; move to the next character in "message" string
				jmp		decrypt

	exit1:

	pop		ebp

	ret		12
Decryption		ENDP

; Description: generates a random key consisting of non-repetive lowercase alphabetic characters
; Receives: an array and a destination integer (newKey and destination)
; Returns: random new key
; Preconditions: arrays is a 32-bit BYTE array and destination is a 32-bit signed DWORD
; Registers Changed: eax (al), ebx, ecx, ebp, edi
Key_Generation	PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 12]					; "newKey" array
	mov		ecx, 0							; int i = 0
	
	outer_loop:
		cmp		ecx, 26						; total of 26 alphabetic characters
		jge		exit1
		mov		eax, 26
		call	RandomRange					; generates random number between 0-25, inclusive
		add		eax, 97
		mov		[edi + ecx], al				; equivalent form of "str[i] = num" in C
		mov		ebx, 0						; int j = 0

		inner_loop:							; loops from index 0 to current size of array at each iteration to find a matching (existing) character in array
			cmp		ebx, ecx
			jge		continue
			mov		dl, [edi + ebx]
			cmp		[edi + ecx], dl			; if str[i] == str[j]:
			je		outer_loop				;		break
			inc		ebx
			jmp		inner_loop

	continue:
		inc		ecx							; increment the count (i.e., i++)
		jmp		outer_loop

	exit1:
		mov		edx, edi					; move each character in edi to edx to print it
		call	WriteString					; print a new key
		call	Crlf

		pop		ebp

		ret		8
Key_Generation	ENDP

END main

;													C code for Key Generation
; #include <stdio.h>
; #include <stdlib.h>
; #include <time.h>
;
;int main() {
;    srand(time(NULL));
;    
;    char str[26];
;    int num = 0, i = 0, is_unique;
;	 
;    while (i < 26) {
;        is_unique = 1;
;        num = (rand() % 26) + 97;
;        str[i] = num;
;
;        for (int j = 0; j < i; j++) {
;            if (str[i] == str[j]) {
;                is_unique = 0;
;                break;
;            }
;        }
;
;        if (is_unique == 0) continue;
;
;        printf("%d\t", str[i]);
;        printf("%c\t", str[i]);
;        printf("%d\n", i);
;
;        i++;
;    }
;    
;    return 0;
;}