; Improved bootloader with color support and proper formatting
BITS 16
ORG 0x7C00

Start:
    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Clear the screen
    call ClearScreen

    ; Display the welcome message
    mov si, WelcomeMsg
    call PrintString
    call PrintNewLine

MainLoop:
    ; Display the menu
    mov si, MainMenu
    call PrintString
    call PrintNewLine

    ; Wait for user input
    call WaitForKey
    cmp al, '1'
    je SetRed
    cmp al, '2'
    je SetGreen
    cmp al, '3'
    je SetBlue
    cmp al, '4'
    je CounterMenu
    cmp al, '5'
    je ExitProgram
    jmp MainLoop

SetRed:
    mov byte [TextColor], 0x04    ; Bright Red
    call ApplyColor
    call DisplayColorChanged
    jmp MainLoop

SetGreen:
    mov byte [TextColor], 0x0A    ; Bright Green
    call ApplyColor
    call DisplayColorChanged
    jmp MainLoop

SetBlue:
    mov byte [TextColor], 0x09    ; Bright Blue
    call ApplyColor
    call DisplayColorChanged
    jmp MainLoop

CounterMenu:
    call PrintNewLine
    mov si, CounterMenuMsg
    call PrintString
    call PrintNewLine

CounterLoop:
    call WaitForKey
    cmp al, '1'
    je IncrementCounter
    cmp al, '2'
    je DecrementCounter
    cmp al, '3'
    je MainLoop
    jmp CounterLoop

IncrementCounter:
    inc byte [Counter]
    call DisplayCounter
    jmp CounterLoop

DecrementCounter:
    dec byte [Counter]
    call DisplayCounter
    jmp CounterLoop

ExitProgram:
    call PrintNewLine
    mov si, ExitMsg
    call PrintString
    call PrintNewLine
    hlt

; ---- Screen Functions ----
ClearScreen:
    mov ah, 0x06    ; Scroll up function
    mov al, 0       ; Clear entire screen
    mov bh, 0x07    ; Default attribute
    mov cx, 0       ; Top-left corner
    mov dx, 0x184F  ; Bottom-right corner
    int 0x10
    
    ; Reset cursor position
    mov ah, 0x02
    mov bh, 0
    mov dx, 0
    int 0x10
    ret

PrintString:
    push ax
    push bx
    mov ah, 0x0E    ; BIOS teletype output
    mov bh, 0       ; Page number
    mov bl, [TextColor]  ; Color attribute
.loop:
    lodsb           ; Load next character
    cmp al, 0       ; Check for string end
    je .done
    int 0x10        ; Print character
    jmp .loop
.done:
    pop bx
    pop ax
    ret

PrintNewLine:
    push ax
    mov ah, 0x0E
    mov al, 0x0D    ; Carriage return
    int 0x10
    mov al, 0x0A    ; Line feed
    int 0x10
    pop ax
    ret

ApplyColor:
    push ax
    push bx
    mov ah, 0x0B    ; Set color palette
    mov bh, 0x00    ; Background color
    mov bl, [TextColor]
    int 0x10
    pop bx
    pop ax
    ret

; ---- Input Functions ----
WaitForKey:
    mov ah, 0x00
    int 0x16        ; Wait for keypress
    ret

; ---- Display Functions ----
DisplayColorChanged:
    call PrintNewLine
    mov si, ColorChangedMsg
    call PrintString
    call PrintNewLine
    ret

DisplayCounter:
    call PrintNewLine
    mov si, CounterMsg
    call PrintString
    mov al, [Counter]
    add al, '0'     ; Convert to ASCII
    mov ah, 0x0E
    int 0x10
    call PrintNewLine
    ret

; ---- Data Section ----
WelcomeMsg db "WELCOME TO MICRO KERNEL BIOS 'ASSEMBLY PROJECT'", 0
MainMenu db "Menu:", 0x0D, 0x0A, "1) Red", 0x0D, 0x0A, "2) Green", 0x0D, 0x0A, "3) Blue", 0x0D, 0x0A, "4) Counter", 0x0D, 0x0A, "5) Exit", 0
ColorChangedMsg db "Color changed successfully!", 0
CounterMenuMsg db "Counter Menu:", 0x0D, 0x0A, "1) Increment", 0x0D, 0x0A, "2) Decrement", 0x0D, 0x0A, "3) Back", 0
CounterMsg db "Counter value: ", 0
ExitMsg db "Program ended. Goodbye!", 0

; ---- Variables ----
Counter db 0
TextColor db 0x07   ; Default color (light gray)

; ---- Boot Sector Signature ----
times 510-($-$$) db 0
dw 0xAA55