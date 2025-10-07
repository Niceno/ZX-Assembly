;-----------
; Version 2
;-----------
frame_v2_address_table:
  defw frame_v2_q1
  defw frame_v2_q2
  defw frame_v2_q3
  defw frame_v2_q4
  defw frame_v2_up
  defw frame_v2_down
  defw frame_v2_left
  defw frame_v2_right

frame_v2_q1:     defb %11111111
                 defb %10000000
                 defb %10111111
                 defb %10111111
                 defb %10110000
                 defb %10110111
                 defb %10110111
                 defb %10110111

frame_v2_q2:     defb %11111111
                 defb %00000001
                 defb %11111101
                 defb %11111101
                 defb %00001101
                 defb %11101101
                 defb %11101101
                 defb %11101101

frame_v2_q3:     defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110000
                 defb %10111111
                 defb %10111111
                 defb %10000000
                 defb %11111111

frame_v2_q4:     defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %00001101
                 defb %11111101
                 defb %11111101
                 defb %00000001
                 defb %11111111

frame_v2_up:     defb %11111111
                 defb %00000000
                 defb %11111111
                 defb %11111111
                 defb %00000000
                 defb %11111111
                 defb %11111111
                 defb %11111111

frame_v2_down:   defb %11111111
                 defb %11111111
                 defb %11111111
                 defb %00000000
                 defb %11111111
                 defb %11111111
                 defb %00000000
                 defb %11111111

frame_v2_left:   defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110111
                 defb %10110111

frame_v2_right:  defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %11101101
                 defb %11101101
