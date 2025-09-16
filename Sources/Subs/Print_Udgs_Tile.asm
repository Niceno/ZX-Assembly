;===============================================================================
; Print_Udgs_Tile
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a sprite formed by a sequence of non-repetitive UDG charactes to
;   the screen, at prescribed row and column coordinates and with prescribed
;   dimensions in rows and columns.
;
; Parameters:
; - BC: the initial (upper left) row and column coordinates
; - DE: dimension in rows and columns
; - HL: address of the first character in the sprite, passed to called function
;
; Calls:
; - Print_Udgs_Line_Tile
;
; Note:
; - This sub belongs to the group of four sisters:
;   > Merge_Udgs_Sprite  (like this, but chars are merged and non-repetitive)
;   > Merge_Udgs_Tile    (like this, but chars are merged)
;   > Print_Udgs_Sprite  (like this, but chars are non-repetitive)
;   > Print_Udgs_Tile    (this one)
;-------------------------------------------------------------------------------
Print_Udgs_Tile

.loop_rows
    push BC            ; store the row/column information
    push DE            ; store the size in rows/columns
    push HL            ; store the character defintion
    call Print_Udgs_Line_Tile
    pop HL             ; restore the character
    pop DE             ; restore the dimenstion
    pop BC             ; restore the row/column information
    inc B              ; move to the next row
    dec D              ; decrease the counter for the number of rows
  jr nz, .loop_rows  ; if not all rows are printed, repeat

  ret
