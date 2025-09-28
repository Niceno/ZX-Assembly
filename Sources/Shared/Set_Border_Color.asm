  ifndef __SET_BORDER_COLOR__
  define __SET_BORDER_COLOR__

;===============================================================================
; Set_Border_Color
;-------------------------------------------------------------------------------
; Purpose:
; - Sets the border color by hammering the output port 254 ($FE)
; - Stores the color you set in the variable border_color.
;
; Parameters:
; - A: specifies the color
;-------------------------------------------------------------------------------
Set_Border_Color:

  ;----------
  ; Store it
  ;----------
  ld (border_color), A

  ;-----------
  ; Hammer it
  ;-----------
  out ($FE), A

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
border_color:
  defb 0

  endif
