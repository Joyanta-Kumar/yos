org 0x7c00
; This is not an runtime instruction.
; It is an assembler directive.
; BIOS chip loads the first 512 bytes from the first section of the disk,
; doesn't matter you want or not. 
; Here, we are just informing this behaviour of BIOS to assembler.
; Now, assembler calculates memory addresses with this extra offset.

bits 16
; All x86 cpu boots at real mode (16-bit)
; But assembly could be used to create 64-bit apps also.
; Directing assembler to assemble into 16-bit machine code.



; --- My Own OS ---

start:
  mov di, username
  call read_string

  mov ah, 0x0e
  mov al, LF
  int 0x10
  mov al, CR
  int 0x10

  mov si, greeting
  call print_string

  mov si, username
  call print_string

  mov al, '.'
  int 0x10



end:
  cli
  hlt
  jmp end


print_string:
  mov al, [si]
  or al, al
  jz .done
  
  ; if not null print the character
  mov ah, 0x0e
  int 0x10
  inc si
  jmp print_string
  .done:
    ret

read_string:
  mov cx, 0
  .read_loop:
    mov ah, 0x00
    int 0x16

    cmp al, CR
    je .done
    cmp cx, username_length
    je .done

    mov [di], al

    mov ah, 0x0e
    int 0x10

    inc cx
    inc di

    jmp .read_loop

  .done:
    ret




LF equ 0x0a
CR equ 0x0d
prompt: db LF, CR, "Hi. What is your name?", LF, CR, "> ", 0
greeting: db "Welcome to your computer, ", 0
username_length equ 16
username: times username_length db 0


times 510 - ($ - $$) db 0
; Padding the bytes before 511 so that 511'th byte can be there
; But why not just (510 - $) ? [ $ represents the current memory address ]
; Remember the orx 0x7c00?
; If it looks like that $ is 0x100'th byte of memory, it is indeed, in the disk.
; But before that, our assembler will convert into machine code to store in the disk.
; And the assembler now knows that everything is offseted by 0x7c00,
; So, $ is now 0x7c00 + 0x100 = 0x7d00
; That will make 510 - 0x7d00 !!!!!
; The saivour is : $$ [starting memory address of the section: 0x7c00]
; So, it is: 510 - (0x7d00 - 0x7c00)
;           = 510 - 0x100
;           = 510 - 256
;           = 254
; 
dw 0xaa55
; Boot signature

; The last two lines of code are assembler directives.
; They pads 254 bytes in the .bin file in memory to reach the 511'th byte.