; video init yayyyyy

vdp_port_ctrl equ &BF
vdp_port_data equ &BE

vdp_init:
    in      a, (&7E)            ; make sure the vdp's working before actually trying to use it
    cp      &B0
    jp      nz, vdp_init

    ld      hl, vdp_init_data   ; get the address of what to copy
    ld      b, vdp_init_data_end-vdp_init_data      ; what the fuck (get the size of what to copy)
    ld      c, vdp_port_ctrl    ; sets which port to copy the things to
    otir                        ; copy that floppy

    ld      hl, pal_intro
    call    set_palette

; I hate calling it cram, all I can think of is the spam knockoff they have in fallout
; for all intents and purposes, color ram is just me refusing to confuse myself by reading cram

; okay so. set_palette. that. it copies a palette into the color ram (waow)
; parameters: 
; L hl      contains the palette's address
; overwrites:
; L a
set_palette:
    push    bc
    xor     a                   ; clear the accumulator
    out     (vdp_port_ctrl), a    ; select the first byte of address to write to color ram
    ld      a, &C0              ; load the second byte of said address
    out     (vdp_port_ctrl), a    ; select that (c'mon, context clues.)

    ld      b, 64               ; toss the number of bytes to write into b
    ld      c, vdp_port_data    ; put the destination of said bytes into c
    otir

    pop     bc
    ret

vdp_init_data:                  ; lay out what to set the registers to
    db      %00000110           ; disable line interrupts and early clock
                                    ; ...why the hell is early clock an option?
    db      &80                 ; select the register! multiple times, eventually!
    db      %10100000           ; disable screen, enable vsync interrupts(!!!), set 8x8 sprites
    db      &81
    db      &FF                 ; set the name table address to &3800
    db      &82
    db      &FF                 ; set the color table base address to &0000
    db      &83
    db      &FF                 ; set the pattern generator base address to &0000
    db      &84
    db      &FF                 ; set the sprite attribute table address to &3F00
    db      &85
    db      &FB                 ; set the sprite generator base address to &0000
    db      &86
    db      &00                 ; set the border/background color to color 0
    db      &87
    db      &00                 ; set horizontal scroll to 0
    db      &88
    db      &00                 ; set vertical scroll to 0
    db      &89
    db      &FF                 ; turn off line interrupt requests
    db      &8A
vdp_init_data_end:

                                ; what the fuck (seriously)

   include "palettes.asm"  
