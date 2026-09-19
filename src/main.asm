[org 0x7c00]

  mov si, prompt        
  call print_string

  mov di, name_buffer     ; Point DI to our input buffer
  call read_string        ; Read characters from keyboard

  mov si, newline         ; Print newline
  call print_string

  mov si, greeting        ; Print "Hello "
  call print_string

  mov si, name_buffer     ; Print user's name
  call print_string

  jmp $

print_string:
  mov ah, 0x0e
  .loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
  .done:
    ret 

read_string:
  .loop:
    mov ah, 0x0         ; BIOS keystroke function
    int 0x16

    cmp al, 0x0d
    je .done

    stosb               ; Store bytes in AL to [DI] and increment DI

    mov ah, 0x0e        ; Echo characters to screen using teletype realtime
    int 0x10

    jmp .loop
  .done:
    mov byte [di], 0
    ret

prompt:   db "Enter your name: ", 0
greeting: db "Hello ", 0
newline:  db 0x0d, 0x0a, 0
name_buffer: times 32 db 0

times 510-($-$$) db 0
dw 0xaa55