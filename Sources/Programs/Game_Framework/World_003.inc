;-------------------------------------------------------------------------------
; World's attributes
;-------------------------------------------------------------------------------
WORLD_CELL_ROWS  equ  256  ; total number of cell rows in the world
WORLD_CELL_COLS  equ  256  ; total number of cell cols in the world

WORLD_TILE_ROWS  equ   16  ; total number of tile rows in the world
WORLD_TILE_COLS  equ   16  ; total number of tile rows in the world

WORLD_ROW_MIN_OFFSET  equ  CELL_ROW_VIEW_MIN - HERO_SCREEN_ROW
WORLD_COL_MIN_OFFSET  equ  CELL_COL_VIEW_MIN - HERO_SCREEN_COL
WORLD_ROW_MAX_OFFSET  equ  CELL_ROW_VIEW_MAX - HERO_SCREEN_ROW
WORLD_COL_MAX_OFFSET  equ  CELL_COL_VIEW_MAX - HERO_SCREEN_COL

; Hero;s starting position in rows and cols
; (Is it compatible with HERO_SCREEN_ROW and HERO_SCREEN_COL?  Does it matter?)
HERO_START_ROW  equ  WORLD_CELL_ROWS / 2 - 1
HERO_START_COL  equ  WORLD_CELL_COLS / 2 - 1

;--------------------
; World's definition
;--------------------
WORLD_END     equ  0  ; reached the end of the world
WORLD_TILE    equ  1  ; about to define a tile
LOCAL_SPRITE  equ  2  ; about to define a sprite
LOCAL_TILE    equ  3

;---------------------------------------------
; Definition of the 3x3 world around the hero
;---------------------------------------------
world_around_hero_address_table:
; type           row  col   definition
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_TILE,   0,   0 : dw $0000
  db WORLD_END                        ; this marks the end of the world

WORLD_ENTRY_SIZE  equ   5  ; number of bytes in each line of the world table

;-------------------------
; Definition of the world
;-------------------------
world_address_table:
; type           row  col   definition
  db WORLD_TILE,   0,   0 : dw tile_001_record
  db WORLD_TILE,   0,  16 : dw tile_002_record
  db WORLD_TILE,   0,  32 : dw tile_001_record
  db WORLD_TILE,   0,  48 : dw tile_002_record
  db WORLD_TILE,   0,  64 : dw tile_001_record
  db WORLD_TILE,   0,  80 : dw tile_002_record
  db WORLD_TILE,   0,  96 : dw tile_001_record
  db WORLD_TILE,   0, 112 : dw tile_002_record
  db WORLD_TILE,   0, 128 : dw tile_001_record
  db WORLD_TILE,   0, 144 : dw tile_002_record
  db WORLD_TILE,   0, 160 : dw tile_001_record
  db WORLD_TILE,   0, 176 : dw tile_002_record
  db WORLD_TILE,   0, 192 : dw tile_001_record
  db WORLD_TILE,   0, 208 : dw tile_002_record
  db WORLD_TILE,   0, 224 : dw tile_001_record
  db WORLD_TILE,   0, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE,  16,   0 : dw tile_003_record
  db WORLD_TILE,  16,  16 : dw tile_004_record
  db WORLD_TILE,  16,  32 : dw tile_003_record
  db WORLD_TILE,  16,  48 : dw tile_004_record
  db WORLD_TILE,  16,  64 : dw tile_003_record
  db WORLD_TILE,  16,  80 : dw tile_004_record
  db WORLD_TILE,  16,  96 : dw tile_003_record
  db WORLD_TILE,  16, 112 : dw tile_004_record
  db WORLD_TILE,  16, 128 : dw tile_003_record
  db WORLD_TILE,  16, 144 : dw tile_004_record
  db WORLD_TILE,  16, 160 : dw tile_003_record
  db WORLD_TILE,  16, 176 : dw tile_004_record
  db WORLD_TILE,  16, 192 : dw tile_003_record
  db WORLD_TILE,  16, 208 : dw tile_004_record
  db WORLD_TILE,  16, 224 : dw tile_003_record
  db WORLD_TILE,  16, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE,  32,   0 : dw tile_001_record
  db WORLD_TILE,  32,  16 : dw tile_002_record
  db WORLD_TILE,  32,  32 : dw tile_001_record
  db WORLD_TILE,  32,  48 : dw tile_002_record
  db WORLD_TILE,  32,  64 : dw tile_001_record
  db WORLD_TILE,  32,  80 : dw tile_002_record
  db WORLD_TILE,  32,  96 : dw tile_001_record
  db WORLD_TILE,  32, 112 : dw tile_002_record
  db WORLD_TILE,  32, 128 : dw tile_001_record
  db WORLD_TILE,  32, 144 : dw tile_002_record
  db WORLD_TILE,  32, 160 : dw tile_001_record
  db WORLD_TILE,  32, 176 : dw tile_002_record
  db WORLD_TILE,  32, 192 : dw tile_001_record
  db WORLD_TILE,  32, 208 : dw tile_002_record
  db WORLD_TILE,  32, 224 : dw tile_001_record
  db WORLD_TILE,  32, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE,  48,   0 : dw tile_003_record
  db WORLD_TILE,  48,  16 : dw tile_004_record
  db WORLD_TILE,  48,  32 : dw tile_003_record
  db WORLD_TILE,  48,  48 : dw tile_004_record
  db WORLD_TILE,  48,  64 : dw tile_003_record
  db WORLD_TILE,  48,  80 : dw tile_004_record
  db WORLD_TILE,  48,  96 : dw tile_003_record
  db WORLD_TILE,  48, 112 : dw tile_004_record
  db WORLD_TILE,  48, 128 : dw tile_003_record
  db WORLD_TILE,  48, 144 : dw tile_004_record
  db WORLD_TILE,  48, 160 : dw tile_003_record
  db WORLD_TILE,  48, 176 : dw tile_004_record
  db WORLD_TILE,  48, 192 : dw tile_003_record
  db WORLD_TILE,  48, 208 : dw tile_004_record
  db WORLD_TILE,  48, 224 : dw tile_003_record
  db WORLD_TILE,  48, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE,  64,   0 : dw tile_001_record
  db WORLD_TILE,  64,  16 : dw tile_002_record
  db WORLD_TILE,  64,  32 : dw tile_001_record
  db WORLD_TILE,  64,  48 : dw tile_002_record
  db WORLD_TILE,  64,  64 : dw tile_001_record
  db WORLD_TILE,  64,  80 : dw tile_002_record
  db WORLD_TILE,  64,  96 : dw tile_001_record
  db WORLD_TILE,  64, 112 : dw tile_002_record
  db WORLD_TILE,  64, 128 : dw tile_001_record
  db WORLD_TILE,  64, 144 : dw tile_002_record
  db WORLD_TILE,  64, 160 : dw tile_001_record
  db WORLD_TILE,  64, 176 : dw tile_002_record
  db WORLD_TILE,  64, 192 : dw tile_001_record
  db WORLD_TILE,  64, 208 : dw tile_002_record
  db WORLD_TILE,  64, 224 : dw tile_001_record
  db WORLD_TILE,  64, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE,  80,   0 : dw tile_003_record
  db WORLD_TILE,  80,  16 : dw tile_004_record
  db WORLD_TILE,  80,  32 : dw tile_003_record
  db WORLD_TILE,  80,  48 : dw tile_004_record
  db WORLD_TILE,  80,  64 : dw tile_003_record
  db WORLD_TILE,  80,  80 : dw tile_004_record
  db WORLD_TILE,  80,  96 : dw tile_003_record
  db WORLD_TILE,  80, 112 : dw tile_004_record
  db WORLD_TILE,  80, 128 : dw tile_003_record
  db WORLD_TILE,  80, 144 : dw tile_004_record
  db WORLD_TILE,  80, 160 : dw tile_003_record
  db WORLD_TILE,  80, 176 : dw tile_004_record
  db WORLD_TILE,  80, 192 : dw tile_003_record
  db WORLD_TILE,  80, 208 : dw tile_004_record
  db WORLD_TILE,  80, 224 : dw tile_003_record
  db WORLD_TILE,  80, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE,  96,   0 : dw tile_001_record
  db WORLD_TILE,  96,  16 : dw tile_002_record
  db WORLD_TILE,  96,  32 : dw tile_001_record
  db WORLD_TILE,  96,  48 : dw tile_002_record
  db WORLD_TILE,  96,  64 : dw tile_001_record
  db WORLD_TILE,  96,  80 : dw tile_002_record
  db WORLD_TILE,  96,  96 : dw tile_001_record
  db WORLD_TILE,  96, 112 : dw tile_002_record
  db WORLD_TILE,  96, 128 : dw tile_001_record
  db WORLD_TILE,  96, 144 : dw tile_002_record
  db WORLD_TILE,  96, 160 : dw tile_001_record
  db WORLD_TILE,  96, 176 : dw tile_002_record
  db WORLD_TILE,  96, 192 : dw tile_001_record
  db WORLD_TILE,  96, 208 : dw tile_002_record
  db WORLD_TILE,  96, 224 : dw tile_001_record
  db WORLD_TILE,  96, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE, 112,   0 : dw tile_003_record
  db WORLD_TILE, 112,  16 : dw tile_004_record
  db WORLD_TILE, 112,  32 : dw tile_003_record
  db WORLD_TILE, 112,  48 : dw tile_004_record
  db WORLD_TILE, 112,  64 : dw tile_003_record
  db WORLD_TILE, 112,  80 : dw tile_004_record
  db WORLD_TILE, 112,  96 : dw tile_003_record
  db WORLD_TILE, 112, 112 : dw tile_005_record  ; <--=
  db WORLD_TILE, 112, 128 : dw tile_006_record  ; <--=
  db WORLD_TILE, 112, 144 : dw tile_004_record
  db WORLD_TILE, 112, 160 : dw tile_003_record
  db WORLD_TILE, 112, 176 : dw tile_004_record
  db WORLD_TILE, 112, 192 : dw tile_003_record
  db WORLD_TILE, 112, 208 : dw tile_004_record
  db WORLD_TILE, 112, 224 : dw tile_003_record
  db WORLD_TILE, 112, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE, 128,   0 : dw tile_001_record
  db WORLD_TILE, 128,  16 : dw tile_002_record
  db WORLD_TILE, 128,  32 : dw tile_001_record
  db WORLD_TILE, 128,  48 : dw tile_002_record
  db WORLD_TILE, 128,  64 : dw tile_001_record
  db WORLD_TILE, 128,  80 : dw tile_002_record
  db WORLD_TILE, 128,  96 : dw tile_001_record
  db WORLD_TILE, 128, 112 : dw tile_006_record  ; <--=
  db WORLD_TILE, 128, 128 : dw tile_005_record  ; <--=
  db WORLD_TILE, 128, 144 : dw tile_002_record
  db WORLD_TILE, 128, 160 : dw tile_001_record
  db WORLD_TILE, 128, 176 : dw tile_002_record
  db WORLD_TILE, 128, 192 : dw tile_001_record
  db WORLD_TILE, 128, 208 : dw tile_002_record
  db WORLD_TILE, 128, 224 : dw tile_001_record
  db WORLD_TILE, 128, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE, 144,   0 : dw tile_003_record
  db WORLD_TILE, 144,  16 : dw tile_004_record
  db WORLD_TILE, 144,  32 : dw tile_003_record
  db WORLD_TILE, 144,  48 : dw tile_004_record
  db WORLD_TILE, 144,  64 : dw tile_003_record
  db WORLD_TILE, 144,  80 : dw tile_004_record
  db WORLD_TILE, 144,  96 : dw tile_003_record
  db WORLD_TILE, 144, 112 : dw tile_004_record
  db WORLD_TILE, 144, 128 : dw tile_003_record
  db WORLD_TILE, 144, 144 : dw tile_004_record
  db WORLD_TILE, 144, 160 : dw tile_003_record
  db WORLD_TILE, 144, 176 : dw tile_004_record
  db WORLD_TILE, 144, 192 : dw tile_003_record
  db WORLD_TILE, 144, 208 : dw tile_004_record
  db WORLD_TILE, 144, 224 : dw tile_003_record
  db WORLD_TILE, 144, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE, 160,   0 : dw tile_001_record
  db WORLD_TILE, 160,  16 : dw tile_002_record
  db WORLD_TILE, 160,  32 : dw tile_001_record
  db WORLD_TILE, 160,  48 : dw tile_002_record
  db WORLD_TILE, 160,  64 : dw tile_001_record
  db WORLD_TILE, 160,  80 : dw tile_002_record
  db WORLD_TILE, 160,  96 : dw tile_001_record
  db WORLD_TILE, 160, 112 : dw tile_002_record
  db WORLD_TILE, 160, 128 : dw tile_001_record
  db WORLD_TILE, 160, 144 : dw tile_002_record
  db WORLD_TILE, 160, 160 : dw tile_001_record
  db WORLD_TILE, 160, 176 : dw tile_002_record
  db WORLD_TILE, 160, 192 : dw tile_001_record
  db WORLD_TILE, 160, 208 : dw tile_002_record
  db WORLD_TILE, 160, 224 : dw tile_001_record
  db WORLD_TILE, 160, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE, 176,   0 : dw tile_003_record
  db WORLD_TILE, 176,  16 : dw tile_004_record
  db WORLD_TILE, 176,  32 : dw tile_003_record
  db WORLD_TILE, 176,  48 : dw tile_004_record
  db WORLD_TILE, 176,  64 : dw tile_003_record
  db WORLD_TILE, 176,  80 : dw tile_004_record
  db WORLD_TILE, 176,  96 : dw tile_003_record
  db WORLD_TILE, 176, 112 : dw tile_004_record
  db WORLD_TILE, 176, 128 : dw tile_003_record
  db WORLD_TILE, 176, 144 : dw tile_004_record
  db WORLD_TILE, 176, 160 : dw tile_003_record
  db WORLD_TILE, 176, 176 : dw tile_004_record
  db WORLD_TILE, 176, 192 : dw tile_003_record
  db WORLD_TILE, 176, 208 : dw tile_004_record
  db WORLD_TILE, 176, 224 : dw tile_003_record
  db WORLD_TILE, 176, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE, 192,   0 : dw tile_001_record
  db WORLD_TILE, 192,  16 : dw tile_002_record
  db WORLD_TILE, 192,  32 : dw tile_001_record
  db WORLD_TILE, 192,  48 : dw tile_002_record
  db WORLD_TILE, 192,  64 : dw tile_001_record
  db WORLD_TILE, 192,  80 : dw tile_002_record
  db WORLD_TILE, 192,  96 : dw tile_001_record
  db WORLD_TILE, 192, 112 : dw tile_002_record
  db WORLD_TILE, 192, 128 : dw tile_001_record
  db WORLD_TILE, 192, 144 : dw tile_002_record
  db WORLD_TILE, 192, 160 : dw tile_001_record
  db WORLD_TILE, 192, 176 : dw tile_002_record
  db WORLD_TILE, 192, 192 : dw tile_001_record
  db WORLD_TILE, 192, 208 : dw tile_002_record
  db WORLD_TILE, 192, 224 : dw tile_001_record
  db WORLD_TILE, 192, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE, 208,   0 : dw tile_003_record
  db WORLD_TILE, 208,  16 : dw tile_004_record
  db WORLD_TILE, 208,  32 : dw tile_003_record
  db WORLD_TILE, 208,  48 : dw tile_004_record
  db WORLD_TILE, 208,  64 : dw tile_003_record
  db WORLD_TILE, 208,  80 : dw tile_004_record
  db WORLD_TILE, 208,  96 : dw tile_003_record
  db WORLD_TILE, 208, 112 : dw tile_004_record
  db WORLD_TILE, 208, 128 : dw tile_003_record
  db WORLD_TILE, 208, 144 : dw tile_004_record
  db WORLD_TILE, 208, 160 : dw tile_003_record
  db WORLD_TILE, 208, 176 : dw tile_004_record
  db WORLD_TILE, 208, 192 : dw tile_003_record
  db WORLD_TILE, 208, 208 : dw tile_004_record
  db WORLD_TILE, 208, 224 : dw tile_003_record
  db WORLD_TILE, 208, 240 : dw tile_004_record
; type           row  col   definition
  db WORLD_TILE, 224,   0 : dw tile_001_record
  db WORLD_TILE, 224,  16 : dw tile_002_record
  db WORLD_TILE, 224,  32 : dw tile_001_record
  db WORLD_TILE, 224,  48 : dw tile_002_record
  db WORLD_TILE, 224,  64 : dw tile_001_record
  db WORLD_TILE, 224,  80 : dw tile_002_record
  db WORLD_TILE, 224,  96 : dw tile_001_record
  db WORLD_TILE, 224, 112 : dw tile_002_record
  db WORLD_TILE, 224, 128 : dw tile_001_record
  db WORLD_TILE, 224, 144 : dw tile_002_record
  db WORLD_TILE, 224, 160 : dw tile_001_record
  db WORLD_TILE, 224, 176 : dw tile_002_record
  db WORLD_TILE, 224, 192 : dw tile_001_record
  db WORLD_TILE, 224, 208 : dw tile_002_record
  db WORLD_TILE, 224, 224 : dw tile_001_record
  db WORLD_TILE, 224, 240 : dw tile_002_record
; type           row  col   definition
  db WORLD_TILE, 240,   0 : dw tile_003_record
  db WORLD_TILE, 240,  16 : dw tile_004_record
  db WORLD_TILE, 240,  32 : dw tile_003_record
  db WORLD_TILE, 240,  48 : dw tile_004_record
  db WORLD_TILE, 240,  64 : dw tile_003_record
  db WORLD_TILE, 240,  80 : dw tile_004_record
  db WORLD_TILE, 240,  96 : dw tile_003_record
  db WORLD_TILE, 240, 112 : dw tile_004_record
  db WORLD_TILE, 240, 128 : dw tile_003_record
  db WORLD_TILE, 240, 144 : dw tile_004_record
  db WORLD_TILE, 240, 160 : dw tile_003_record
  db WORLD_TILE, 240, 176 : dw tile_004_record
  db WORLD_TILE, 240, 192 : dw tile_003_record
  db WORLD_TILE, 240, 208 : dw tile_004_record
  db WORLD_TILE, 240, 224 : dw tile_003_record
  db WORLD_TILE, 240, 240 : dw tile_004_record
  db WORLD_END  ; this marks the end of the world

;------------------------------------------------------------
; Tile records
;
; Note:
; - dimensions are reduntant, code assumes tiles are 16 x 16
;------------------------------------------------------------
;                    type       local pos.  dimensions   color
tile_001_record:  db LOCAL_TILE,   0,   0,    16,  16,   GREEN_PAPER
                  db WORLD_END
tile_002_record:  db LOCAL_TILE,   0,   0,    16,  16,   GREEN_PAPER   + BRIGHT
                  db WORLD_END
tile_003_record:  db LOCAL_TILE,   0,   0,    16,  16,   GREEN_PAPER   + BRIGHT
                  db WORLD_END
tile_004_record:  db LOCAL_TILE,   0,   0,    16,  16,   GREEN_PAPER
                  db WORLD_END
tile_005_record:  db LOCAL_TILE,   0,   0,    16,  16,   MAGENTA_PAPER
                  db LOCAL_TILE,   4,   4,     8,   8,   YELLOW_PAPER
                  db LOCAL_TILE,   6,   6,     4,   4,   YELLOW_PAPER + BRIGHT
                  db WORLD_END
tile_006_record:  db LOCAL_TILE,   0,   0,    16,  16,   MAGENTA_PAPER + BRIGHT
                  db LOCAL_TILE,  10,  10,     4,   4,   WHITE_PAPER   + BRIGHT
                  db WORLD_END

