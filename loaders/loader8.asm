        define  tr $ffff &
        ;include define.asm

        output  loader8.bin
	org	$E000 -(ini -header)
; 
; begin $e000
; end	   $e061
; start $e000
; BYTE $00, $E0, $61, $E0, $00, $E0
header
	   WORD	ini				; begin
	   WORD	fin -1			; end
	   WORD	ini				; start

ini
        ld      hl,$ffff
        ld      a,(hl)
        xor     $ff
        and     $f0
        ld      b,a
        srl     a
        srl     a
        srl     a
        srl     a
        or      b
        ld      (hl),a
        in      a,($a8)
        and     $f0
        ld      b,a
        srl     a
        srl     a
        or      b
        out     ($a8),a
        call    $00e1
        di      
        ;ld      hl,$4000
        ld      hl,$468C		; initial address for loading compressed data
L_E026:
        push    hl
        call    $00e4
        pop     hl
        jp      z,$0000
        ld      (hl),a
        inc     hl
        or      $f0
        out     ($99),a
        ld      a,$87
        out     ($99),a

        ld      a,h
        cp      $60
        jp      nz, L_E026		; < $6000, sigue cargando
        ld      a,l
        cp      $10
        jp      nz, L_E026		; < $6010 (end addr), sigue cargando

        call    $00e7			; para la cinta

	
	di	  
	ld      sp, $E0FF                
     ld      hl, $468C        	; first compressed source address  $4000 + $2000 = $6000 - 6532 ($1984) = $467C
					  	; empiezo en $468C, $468C + $1984 -1 -> $600F
     ld      de, $4000		; first decompressed destination address
     call    tr dzx7
	ei

L_E05F:
	  jp	$405f	

dzx7    include dzx7_turbo.asm
fin