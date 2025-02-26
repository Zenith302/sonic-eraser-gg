; everything

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
