;===============================================================================
; Viewport_Store_Data_For_Pixels
;-------------------------------------------------------------------------------
; Parameters:
; - BC: holds the upper left corner row and column of the viewport
; - DE: viewport dimensions in rows and columns
;
; Global variables used:
; - viewport_pixel_metadata
; - viewport_row_pixel_addresses_left_column
; - viewport_row_pixel_addresses_right_column
;
; Calls:
; - Calculate_Screen_Pixel_Address
;
; Note:
; - This sub is called only once, when a viewport is created
;-------------------------------------------------------------------------------
Viewport_Store_Data_For_Pixels

  push BC
  push DE

  ;------------------
  ; Store dimensions
  ;------------------
  ld IX, viewport_pixel_metadata
  ld (IX+0), D  ; number of rows inside the viewport
  ld (IX+1), E  ; number of columns inside the viewport

  ;-------------------------
  ;
  ; Rows at the left column
  ;
  ;-------------------------

  ;---------------------------------
  ; Store addresses of the each row
  ;---------------------------------
  ld IX, viewport_row_pixel_addresses_left_column

.loop_rows
    push BC
    push DE
    call Calculate_Screen_Pixel_Address  ; will store address in HL
    pop DE
    pop BC

    ; Store the address from HL
    ld(IX+0), L
    ld(IX+1), H

    ; Increase the row
    inc B

    ; Point to the next storage place
    inc IX
    inc IX

    dec D
  jr nz, .loop_rows

  ;-----------------------------------------------------
  ; Store the address of the storage slot of the last
  ; row in the viewport - important when scrolling down
  ;-----------------------------------------------------
  dec IX
  dec IX
  push IX
  pop  HL
  ld IX, viewport_pixel_metadata
  ld(IX+2), L
  ld(IX+3), H

  ;--------------------------
  ;
  ; Rows at the right column
  ;
  ;--------------------------

  pop DE
  pop BC

  ld A, C
  add A, E
  dec A
  ld C, A

  ;---------------------------------
  ; Store addresses of the each row
  ;---------------------------------
  ld IX, viewport_row_pixel_addresses_right_column

.loop_rows_right_column
    push BC
    push DE
    call Calculate_Screen_Pixel_Address  ; will store address in HL
    pop DE
    pop BC

    ; Store the address from HL
    ld(IX+0), L
    ld(IX+1), H

    ; Increase the row
    inc B

    ; Point to the next storage place
    inc IX
    inc IX

    dec D
  jr nz, .loop_rows_right_column

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
viewport_pixel_metadata:
  defb  $00        ; + 0 number of rows
  defb  $00        ; + 1 number of columns
  defw  $0000      ; + 2 address of the last row

viewport_row_pixel_addresses_left_column:
  defw  $0000      ; + 0
  defw  $0000      ; + 2 second row in the viewport
  defw  $0000      ; + 4 third
  defw  $0000      ; + 6
  defw  $0000      ; + 8
  defw  $0000      ; +10
  defw  $0000      ; +12
  defw  $0000      ; +14
  defw  $0000      ; +16
  defw  $0000      ; +18
  defw  $0000      ; +20
  defw  $0000      ; +22
  defw  $0000      ; +24
  defw  $0000      ; +26
  defw  $0000      ; +28
  defw  $0000      ; +30
  defw  $0000      ; +32
  defw  $0000      ; +34
  defw  $0000      ; +36
  defw  $0000      ; +38
  defw  $0000      ; +40
  defw  $0000      ; +42
  defw  $0000      ; +44
  defw  $0000      ; +46 24th row in the viewport

viewport_row_pixel_addresses_right_column:
  defw  $0000      ; + 0
  defw  $0000      ; + 2 second row in the viewport
  defw  $0000      ; + 4 third
  defw  $0000      ; + 6
  defw  $0000      ; + 8
  defw  $0000      ; +10
  defw  $0000      ; +12
  defw  $0000      ; +14
  defw  $0000      ; +16
  defw  $0000      ; +18
  defw  $0000      ; +20
  defw  $0000      ; +22
  defw  $0000      ; +24
  defw  $0000      ; +26
  defw  $0000      ; +28
  defw  $0000      ; +30
  defw  $0000      ; +32
  defw  $0000      ; +34
  defw  $0000      ; +36
  defw  $0000      ; +38
  defw  $0000      ; +40
  defw  $0000      ; +42
  defw  $0000      ; +44
  defw  $0000      ; +46 24th row in the viewport

