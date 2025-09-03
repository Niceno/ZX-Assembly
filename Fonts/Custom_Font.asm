  include "../Sources/Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_CUSTOM_FONT_START

Custom_Font:
; include "Bubblegum.inc"
; include "Computing_60s.inc"
; include "Fusion_Drive.inc"
; include "Mild_West.inc"
; include "Orbiter.inc"
  include "Outrunner_Inline.inc"
; include "Outrunner_Outline.inc"
; include "Standstill.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Custom_Font
;-------------------------------------------------------------------------------
  savebin "custom_font.bin", Custom_Font, $ - Custom_Font
