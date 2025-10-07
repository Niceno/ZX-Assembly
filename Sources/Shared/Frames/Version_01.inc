;-----------
; Version 1
;-----------
frame_v1_address_table:
  defw frame_v1_q1
  defw frame_v1_q2
  defw frame_v1_q3
  defw frame_v1_q4
  defw frame_v1_up
  defw frame_v1_down
  defw frame_v1_left
  defw frame_v1_right

frame_v1_q1:     defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00001111
                 defb %00001000
                 defb %00001011
                 defb %00001010

frame_v1_q2:     defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %11110000
                 defb %00010000
                 defb %11010000
                 defb %01010000

frame_v1_q3:     defb %00001010
                 defb %00001011
                 defb %00001000
                 defb %00001111
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000

frame_v1_q4:     defb %01010000
                 defb %11010000
                 defb %00010000
                 defb %11110000
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000

frame_v1_up:     defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %11111111
                 defb %00000000
                 defb %11111111
                 defb %00000000

frame_v1_down:   defb %00000000
                 defb %11111111
                 defb %00000000
                 defb %11111111
                 defb %00000000
                 defb %00000000
                 defb %00000000
                 defb %00000000

frame_v1_left:   defb %00001010
                 defb %00001010
                 defb %00001010
                 defb %00001010
                 defb %00001010
                 defb %00001010
                 defb %00001010
                 defb %00001010

frame_v1_right:  defb %01010000
                 defb %01010000
                 defb %01010000
                 defb %01010000
                 defb %01010000
                 defb %01010000
                 defb %01010000
                 defb %01010000
