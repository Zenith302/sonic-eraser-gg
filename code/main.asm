; everything

buttons     equ &DC

    org     &0000
    jr      begin       ; jump to the beginning of the program
    org     &0038
    jp      vsync_isr.  ; jump to the vsync routine
    org     &0066
    retn                ; return from any nmi

    org     &0080       ; start the thing here!!

begin:
    di
    im      1           ; send interrupts to &0038 X3
    ld      sp, &DFF0   ; start the stack pointer at the end of usable work ram
    
    call    vdp_init    ; oh god I just remembered this is my first project. sonic fucking eraser
    
    include "vdp.asm"

vsync_isr:
    in      a, (vdp_port_ctrl)
    in      a, (buttons)
    cpl
    and     &30             ; ignore everything other than buttons 1 and 2
    ld      d, a            ; save this frame's button presses from a into d for later

                            ; was any button *not* pressed last frame and *is now* being pressed? idfk find out
    ld      a, c            ; put c into a to look at it
    cpl                     ; invert a because game gear is 1 by default, not 0
    and     d               ; and it with d! because it's the only case we care to look for here
    jr      z, vsync_ret    ; if nothing was pressed on the current frame, just return

    bit     5, a            ; test bit 5 (button 2)
    jr      z, no_button_2 
;relative jump      if zero, to no_button_2 (ignored if 1)
    inc     b

no_button_2:
    bit     4, a
    jr      z, no_button_1
    dec     b

no_button_1:
    ld      a, b            ; move B to A to read from it (because of the function used)

vsync_ret:
    ld      c, d            ; move d's stuff into c as last frame's buttons
    ei
    reti                    ; go back to where you were before the last interrupt

; rom header and footer go here
    org     &7FF0
    db      "TMR SEGA"
    db      0,0
    db      &69,&69

    db      0,0,0

    db      &7D
