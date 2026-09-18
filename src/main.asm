[org 0x7c00]

mov ah, 0x0e
mov bx, variableName

printString:
  mov al, [bx]
  cmp al, 0
  je end
  int 0x10
  inc bx
  jmp printString

variableName:
  db "But the fool on the hill", 0

end:
  jmp $

times 510-($-$$) db 0
dw 0xaa55