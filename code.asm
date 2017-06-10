cseg segment
      assume cs:cseg,ds:cseg
      org  100h
     start:
      jmp Initialize                  ;跳转  
      Old_Keyboard_IO dd ?
                              ;0000000000
               
     new_keyboard_io proc far         ;新中断
        assume cs:cseg,ds:cseg 
        
     sti
           ;Section 1

      push ax
      push bx
      push cx
      push dx
      push es

      MOV ah,2ch
      int 21H
      cmp dh,10
      jb bye
      cmp dh,20
      jb go
      cmp dh,30
      jb bye
      cmp dh,40
      jb go
      cmp dh,50
      jb bye
      cmp dh,60
      jb go
    go:
      pop es
      pop dx
      pop cx
      pop bx
      pop ax




      cmp ah,0                        ;有按键盘
      je ki0
      assume ds:nothing
      jmp  Old_Keyboard_IO 
      
      
           ;Section 2
     ki0:
      pushf
      assume  ds:nothing
      call  Old_Keyboard_IO
      cmp  al,'a'
      jb  kidone 
      cmp  al,'z' 
      jb  ki1
      cmp  al,'z'
      je  ki2
      nop
      jmp kidone
     ki1:
      add al,1
      jmp kidone
      nop
     ki2:
      mov al,'a'
      jmp kidone

     bye:
      pop es
      pop dx
      pop cx
      pop bx
      pop ax
      
     kidone:     
      iret   
      
      
     new_keyboard_io endp
           
           
           ;Section 3 
     Initialize:
      assume cs:cseg,ds:cseg
      mov bx,cs
      mov ds,bx
      mov al,16h
      mov ah,35h
      int 21h
      mov word ptr Old_Keyboard_IO,bx
      mov word ptr Old_Keyboard_IO[2],es      ;取中断向量
           ;End Section 3 
           
           
      mov dx,offset new_keyboard_io
      mov al,16h
      mov ah,25h                              ;放新中断向量
      int 21h
      
      
      mov dx,offset Initialize
      int 27h
     cseg ends
      end start
