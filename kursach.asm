.model  SMALL       ; opredeleniye modeli
.386                ; opredeleniye minimalnix sistemnix trebovaniy po procecoru
STACK   64

.data
    port_b  equ 61h ; opredelyaem adres sistemnogo porta b
    
.code               ; direktive nachala segmenta koda
    org 100h
    mov ax, @data
    mov ds, ax      ; start data adress
     
Start:              ; nachalo proceduri start
    mov cx, 2       ; kolichestvo signalov
    mov bx, 1000    ; zaderjka pereklycheniya

parcing:            ; metka parcing
    mov ah, 8       ; schitivaet vvedenniy simvol s klavi
    int 21h         ; eto prerivanie
    cmp al, 27      ; esli ESC
    jz  Exit         ; zaverwaem progu
    jmp sound
    
sound proc near     ; generaciya vzuka
    push cx
    mov dx, 100     ; dlitelnost (kolichestvo ciclov)
    mov di, bx      ; zaderjka
    cli             ; zaprewenie prerivaniy
    in  al, port_b ; chtenie sostoyaniya sis port b
    and al, 11111110b; otkl dinam ot timera
sound endp
    
reproduction:              ; metka
    or  al, 00000010b; vkl dinam
    out port_b, al  ; zapis v port b
    mov cx, di      ; podgotovka schetchika kolvo ciklov zaderjki
    loop $          ; zaderjka

    and al, 11111101b; vikl
    out port_b, al  ; zapis
    mov cx, di
    loop $
    dec dx          ; vichitaem edinicu iz schetch
    jnz reproduction 
    sti             ; razrewenie prerivaniy
    pop cx
    sub bx, 500
    loop sound
    mov cx, 2
    mov bx, 1000
    jmp parcing     ; perexod k metke

Exit:               ; metka
    mov ah, 4ch     ; vozvrawaet upravlenie 
    int 21h
    
END Start           ; konec proceduri start