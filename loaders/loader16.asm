        define  tr $ffff &
        ;include define.asm

        output  loader16.bin
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
        in      a,($a8)		; cambio de banco
        and     $f0
        ld      b,a
        srl     a
        srl     a
        or      b
        out     ($a8),a
        call    $00e1			; TAPION, reads the header block
        di      
        ;ld      hl,$4000
        ld      hl,$4FF2		;; initial address for loading compressed data: $4000 + $4000 - (long compr) + $10
L_E026:
        push    hl
        call    $00e4			; TAPIN, read data from the tape
        pop     hl
        jp      z,$0000
        ld      (hl),a
        inc     hl
        or      $f0
        out     ($99),a
        ld      a,$87
        out     ($99),a

        ld      a,h
        cp      $80			;; para 16K es $80xx
        jp      nz, L_E026		; < $8000, sigue cargando
        ld      a,l
        cp      $10
        jp      nz, L_E026		; < $8010 (end addr), sigue cargando

        call    $00e7			; para la cinta

	
	di	  
	ld      sp, $E0FF                
     ld      hl, $4FF2        	;; first compressed source address  $4000 + $4000 = $8000 - 12318 ($301E) = $4FE2
					  	;; empiezo en $4FF2, $4FF2 + $301E -1 -> $800F
     ld      de, $4000		; first decompressed destination address
     call    tr dzx7
	ei

L_E05F:
	  jp	$4010				;; ejecuto

dzx7    include dzx7_turbo.asm
fin