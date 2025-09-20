;-------------------------
; Definition of the world
;-------------------------
world_address_table:
; type           row  col   definition
  db WORLD_TILE,   1,   1 : dw tile_ground     ; covers the whole world and it is a MUST!!!
  db WORLD_TILE,   1,   1 : dw tile_001_record
  db WORLD_TILE,   1,  17 : dw tile_002_record
  db WORLD_TILE,   1,  33 : dw tile_003_record
  db WORLD_TILE,   1,  49 : dw tile_004_record
  db WORLD_TILE,   1,  65 : dw tile_005_record
  db WORLD_TILE,   1,  81 : dw tile_006_record
  db WORLD_TILE,   1,  97 : dw tile_007_record
  db WORLD_TILE,   1, 113 : dw tile_008_record
  db WORLD_TILE,   1, 129 : dw tile_009_record
  db WORLD_TILE,   1, 145 : dw tile_010_record
  db WORLD_TILE,   1, 161 : dw tile_011_record
  db WORLD_TILE,   1, 177 : dw tile_012_record
  db WORLD_TILE,   1, 193 : dw tile_013_record
  db WORLD_TILE,   1, 209 : dw tile_014_record
  db WORLD_TILE,   1, 225 : dw tile_015_record
  db WORLD_TILE,   1, 241 : dw tile_016_record
  db WORLD_TILE,  17,   1 : dw tile_017_record
  db WORLD_TILE,  17,  17 : dw tile_018_record
  db WORLD_TILE,  17,  33 : dw tile_019_record
  db WORLD_TILE,  17,  49 : dw tile_020_record
  db WORLD_TILE,  17,  65 : dw tile_021_record
  db WORLD_TILE,  17,  81 : dw tile_022_record
  db WORLD_TILE,  17,  97 : dw tile_023_record
  db WORLD_TILE,  17, 113 : dw tile_024_record
  db WORLD_TILE,  17, 129 : dw tile_025_record
  db WORLD_TILE,  17, 145 : dw tile_026_record
  db WORLD_TILE,  17, 161 : dw tile_027_record
  db WORLD_TILE,  17, 177 : dw tile_028_record
  db WORLD_TILE,  17, 193 : dw tile_029_record
  db WORLD_TILE,  17, 209 : dw tile_030_record
  db WORLD_TILE,  17, 225 : dw tile_031_record
  db WORLD_TILE,  17, 241 : dw tile_032_record
  db WORLD_TILE,  33,   1 : dw tile_033_record
  db WORLD_TILE,  33,  17 : dw tile_034_record
  db WORLD_TILE,  33,  33 : dw tile_035_record
  db WORLD_TILE,  33,  49 : dw tile_036_record
  db WORLD_TILE,  33,  65 : dw tile_037_record
  db WORLD_TILE,  33,  81 : dw tile_038_record
  db WORLD_TILE,  33,  97 : dw tile_039_record
  db WORLD_TILE,  33, 113 : dw tile_040_record
  db WORLD_TILE,  33, 129 : dw tile_041_record
  db WORLD_TILE,  33, 145 : dw tile_042_record
  db WORLD_TILE,  33, 161 : dw tile_043_record
  db WORLD_TILE,  33, 177 : dw tile_044_record
  db WORLD_TILE,  33, 193 : dw tile_045_record
  db WORLD_TILE,  33, 209 : dw tile_046_record
  db WORLD_TILE,  33, 225 : dw tile_047_record
  db WORLD_TILE,  33, 241 : dw tile_048_record
  db WORLD_TILE,  49,   1 : dw tile_049_record
  db WORLD_TILE,  49,  17 : dw tile_050_record
  db WORLD_TILE,  49,  33 : dw tile_051_record
  db WORLD_TILE,  49,  49 : dw tile_052_record
  db WORLD_TILE,  49,  65 : dw tile_053_record
  db WORLD_TILE,  49,  81 : dw tile_054_record
  db WORLD_TILE,  49,  97 : dw tile_055_record
  db WORLD_TILE,  49, 113 : dw tile_056_record
  db WORLD_TILE,  49, 129 : dw tile_057_record
  db WORLD_TILE,  49, 145 : dw tile_058_record
  db WORLD_TILE,  49, 161 : dw tile_059_record
  db WORLD_TILE,  49, 177 : dw tile_060_record
  db WORLD_TILE,  49, 193 : dw tile_061_record
  db WORLD_TILE,  49, 209 : dw tile_062_record
  db WORLD_TILE,  49, 225 : dw tile_063_record
  db WORLD_TILE,  49, 241 : dw tile_064_record
  db WORLD_TILE,  65,   1 : dw tile_065_record
  db WORLD_TILE,  65,  17 : dw tile_066_record
  db WORLD_TILE,  65,  33 : dw tile_067_record
  db WORLD_TILE,  65,  49 : dw tile_068_record
  db WORLD_TILE,  65,  65 : dw tile_069_record
  db WORLD_TILE,  65,  81 : dw tile_070_record
  db WORLD_TILE,  65,  97 : dw tile_071_record
  db WORLD_TILE,  65, 113 : dw tile_072_record
  db WORLD_TILE,  65, 129 : dw tile_073_record
  db WORLD_TILE,  65, 145 : dw tile_074_record
  db WORLD_TILE,  65, 161 : dw tile_075_record
  db WORLD_TILE,  65, 177 : dw tile_076_record
  db WORLD_TILE,  65, 193 : dw tile_077_record
  db WORLD_TILE,  65, 209 : dw tile_078_record
  db WORLD_TILE,  65, 225 : dw tile_079_record
  db WORLD_TILE,  65, 241 : dw tile_080_record
  db WORLD_TILE,  81,   1 : dw tile_081_record
  db WORLD_TILE,  81,  17 : dw tile_082_record
  db WORLD_TILE,  81,  33 : dw tile_083_record
  db WORLD_TILE,  81,  49 : dw tile_084_record
  db WORLD_TILE,  81,  65 : dw tile_085_record
  db WORLD_TILE,  81,  81 : dw tile_086_record
  db WORLD_TILE,  81,  97 : dw tile_087_record
  db WORLD_TILE,  81, 113 : dw tile_088_record
  db WORLD_TILE,  81, 129 : dw tile_089_record
  db WORLD_TILE,  81, 145 : dw tile_090_record
  db WORLD_TILE,  81, 161 : dw tile_091_record
  db WORLD_TILE,  81, 177 : dw tile_092_record
  db WORLD_TILE,  81, 193 : dw tile_093_record
  db WORLD_TILE,  81, 209 : dw tile_094_record
  db WORLD_TILE,  81, 225 : dw tile_095_record
  db WORLD_TILE,  81, 241 : dw tile_096_record
  db WORLD_TILE,  97,   1 : dw tile_097_record
  db WORLD_TILE,  97,  17 : dw tile_098_record
  db WORLD_TILE,  97,  33 : dw tile_099_record
  db WORLD_TILE,  97,  49 : dw tile_100_record
  db WORLD_TILE,  97,  65 : dw tile_101_record
  db WORLD_TILE,  97,  81 : dw tile_102_record
  db WORLD_TILE,  97,  97 : dw tile_103_record
  db WORLD_TILE,  97, 113 : dw tile_104_record
  db WORLD_TILE,  97, 129 : dw tile_105_record
  db WORLD_TILE,  97, 145 : dw tile_106_record
  db WORLD_TILE,  97, 161 : dw tile_107_record
  db WORLD_TILE,  97, 177 : dw tile_108_record
  db WORLD_TILE,  97, 193 : dw tile_109_record
  db WORLD_TILE,  97, 209 : dw tile_110_record
  db WORLD_TILE,  97, 225 : dw tile_111_record
  db WORLD_TILE,  97, 241 : dw tile_112_record
  db WORLD_TILE, 113,   1 : dw tile_113_record
  db WORLD_TILE, 113,  17 : dw tile_114_record
  db WORLD_TILE, 113,  33 : dw tile_115_record
  db WORLD_TILE, 113,  49 : dw tile_116_record
  db WORLD_TILE, 113,  65 : dw tile_117_record
  db WORLD_TILE, 113,  81 : dw tile_118_record
  db WORLD_TILE, 113,  97 : dw tile_119_record
  db WORLD_TILE, 113, 113 : dw tile_120_record
  db WORLD_TILE, 113, 129 : dw tile_121_record
  db WORLD_TILE, 113, 145 : dw tile_122_record
  db WORLD_TILE, 113, 161 : dw tile_123_record
  db WORLD_TILE, 113, 177 : dw tile_124_record
  db WORLD_TILE, 113, 193 : dw tile_125_record
  db WORLD_TILE, 113, 209 : dw tile_126_record
  db WORLD_TILE, 113, 225 : dw tile_127_record
  db WORLD_TILE, 113, 241 : dw tile_128_record
  db WORLD_TILE, 129,   1 : dw tile_129_record
  db WORLD_TILE, 129,  17 : dw tile_130_record
  db WORLD_TILE, 129,  33 : dw tile_131_record
  db WORLD_TILE, 129,  49 : dw tile_132_record
  db WORLD_TILE, 129,  65 : dw tile_133_record
  db WORLD_TILE, 129,  81 : dw tile_134_record
  db WORLD_TILE, 129,  97 : dw tile_135_record
  db WORLD_TILE, 129, 113 : dw tile_136_record
  db WORLD_TILE, 129, 129 : dw tile_137_record
  db WORLD_TILE, 129, 145 : dw tile_138_record
  db WORLD_TILE, 129, 161 : dw tile_139_record
  db WORLD_TILE, 129, 177 : dw tile_140_record
  db WORLD_TILE, 129, 193 : dw tile_141_record
  db WORLD_TILE, 129, 209 : dw tile_142_record
  db WORLD_TILE, 129, 225 : dw tile_143_record
  db WORLD_TILE, 129, 241 : dw tile_144_record
  db WORLD_TILE, 145,   1 : dw tile_145_record
  db WORLD_TILE, 145,  17 : dw tile_146_record
  db WORLD_TILE, 145,  33 : dw tile_147_record
  db WORLD_TILE, 145,  49 : dw tile_148_record
  db WORLD_TILE, 145,  65 : dw tile_149_record
  db WORLD_TILE, 145,  81 : dw tile_150_record
  db WORLD_TILE, 145,  97 : dw tile_151_record
  db WORLD_TILE, 145, 113 : dw tile_152_record
  db WORLD_TILE, 145, 129 : dw tile_153_record
  db WORLD_TILE, 145, 145 : dw tile_154_record
  db WORLD_TILE, 145, 161 : dw tile_155_record
  db WORLD_TILE, 145, 177 : dw tile_156_record
  db WORLD_TILE, 145, 193 : dw tile_157_record
  db WORLD_TILE, 145, 209 : dw tile_158_record
  db WORLD_TILE, 145, 225 : dw tile_159_record
  db WORLD_TILE, 145, 241 : dw tile_160_record
  db WORLD_TILE, 161,   1 : dw tile_161_record
  db WORLD_TILE, 161,  17 : dw tile_162_record
  db WORLD_TILE, 161,  33 : dw tile_163_record
  db WORLD_TILE, 161,  49 : dw tile_164_record
  db WORLD_TILE, 161,  65 : dw tile_165_record
  db WORLD_TILE, 161,  81 : dw tile_166_record
  db WORLD_TILE, 161,  97 : dw tile_167_record
  db WORLD_TILE, 161, 113 : dw tile_168_record
  db WORLD_TILE, 161, 129 : dw tile_169_record
  db WORLD_TILE, 161, 145 : dw tile_170_record
  db WORLD_TILE, 161, 161 : dw tile_171_record
  db WORLD_TILE, 161, 177 : dw tile_172_record
  db WORLD_TILE, 161, 193 : dw tile_173_record
  db WORLD_TILE, 161, 209 : dw tile_174_record
  db WORLD_TILE, 161, 225 : dw tile_175_record
  db WORLD_TILE, 161, 241 : dw tile_176_record
  db WORLD_TILE, 177,   1 : dw tile_177_record
  db WORLD_TILE, 177,  17 : dw tile_178_record
  db WORLD_TILE, 177,  33 : dw tile_179_record
  db WORLD_TILE, 177,  49 : dw tile_180_record
  db WORLD_TILE, 177,  65 : dw tile_181_record
  db WORLD_TILE, 177,  81 : dw tile_182_record
  db WORLD_TILE, 177,  97 : dw tile_183_record
  db WORLD_TILE, 177, 113 : dw tile_184_record
  db WORLD_TILE, 177, 129 : dw tile_185_record
  db WORLD_TILE, 177, 145 : dw tile_186_record
  db WORLD_TILE, 177, 161 : dw tile_187_record
  db WORLD_TILE, 177, 177 : dw tile_188_record
  db WORLD_TILE, 177, 193 : dw tile_189_record
  db WORLD_TILE, 177, 209 : dw tile_190_record
  db WORLD_TILE, 177, 225 : dw tile_191_record
  db WORLD_TILE, 177, 241 : dw tile_192_record
  db WORLD_TILE, 193,   1 : dw tile_193_record
  db WORLD_TILE, 193,  17 : dw tile_194_record
  db WORLD_TILE, 193,  33 : dw tile_195_record
  db WORLD_TILE, 193,  49 : dw tile_196_record
  db WORLD_TILE, 193,  65 : dw tile_197_record
  db WORLD_TILE, 193,  81 : dw tile_198_record
  db WORLD_TILE, 193,  97 : dw tile_199_record
  db WORLD_TILE, 193, 113 : dw tile_200_record
  db WORLD_TILE, 193, 129 : dw tile_201_record
  db WORLD_TILE, 193, 145 : dw tile_202_record
  db WORLD_TILE, 193, 161 : dw tile_203_record
  db WORLD_TILE, 193, 177 : dw tile_204_record
  db WORLD_TILE, 193, 193 : dw tile_205_record
  db WORLD_TILE, 193, 209 : dw tile_206_record
  db WORLD_TILE, 193, 225 : dw tile_207_record
  db WORLD_TILE, 193, 241 : dw tile_208_record
  db WORLD_TILE, 209,   1 : dw tile_209_record
  db WORLD_TILE, 209,  17 : dw tile_210_record
  db WORLD_TILE, 209,  33 : dw tile_211_record
  db WORLD_TILE, 209,  49 : dw tile_212_record
  db WORLD_TILE, 209,  65 : dw tile_213_record
  db WORLD_TILE, 209,  81 : dw tile_214_record
  db WORLD_TILE, 209,  97 : dw tile_215_record
  db WORLD_TILE, 209, 113 : dw tile_216_record
  db WORLD_TILE, 209, 129 : dw tile_217_record
  db WORLD_TILE, 209, 145 : dw tile_218_record
  db WORLD_TILE, 209, 161 : dw tile_219_record
  db WORLD_TILE, 209, 177 : dw tile_220_record
  db WORLD_TILE, 209, 193 : dw tile_221_record
  db WORLD_TILE, 209, 209 : dw tile_222_record
  db WORLD_TILE, 209, 225 : dw tile_223_record
  db WORLD_TILE, 209, 241 : dw tile_224_record
  db WORLD_TILE, 225,   1 : dw tile_225_record
  db WORLD_TILE, 225,  17 : dw tile_226_record
  db WORLD_TILE, 225,  33 : dw tile_227_record
  db WORLD_TILE, 225,  49 : dw tile_228_record
  db WORLD_TILE, 225,  65 : dw tile_229_record
  db WORLD_TILE, 225,  81 : dw tile_230_record
  db WORLD_TILE, 225,  97 : dw tile_231_record
  db WORLD_TILE, 225, 113 : dw tile_232_record
  db WORLD_TILE, 225, 129 : dw tile_233_record
  db WORLD_TILE, 225, 145 : dw tile_234_record
  db WORLD_TILE, 225, 161 : dw tile_235_record
  db WORLD_TILE, 225, 177 : dw tile_236_record
  db WORLD_TILE, 225, 193 : dw tile_237_record
  db WORLD_TILE, 225, 209 : dw tile_238_record
  db WORLD_TILE, 225, 225 : dw tile_239_record
  db WORLD_TILE, 225, 241 : dw tile_240_record
  db WORLD_TILE, 241,   1 : dw tile_241_record
  db WORLD_TILE, 241,  17 : dw tile_242_record
  db WORLD_TILE, 241,  33 : dw tile_243_record
  db WORLD_TILE, 241,  49 : dw tile_244_record
  db WORLD_TILE, 241,  65 : dw tile_245_record
  db WORLD_TILE, 241,  81 : dw tile_246_record
  db WORLD_TILE, 241,  97 : dw tile_247_record
  db WORLD_TILE, 241, 113 : dw tile_248_record
  db WORLD_TILE, 241, 129 : dw tile_249_record
  db WORLD_TILE, 241, 145 : dw tile_250_record
  db WORLD_TILE, 241, 161 : dw tile_251_record
  db WORLD_TILE, 241, 177 : dw tile_252_record
  db WORLD_TILE, 241, 193 : dw tile_253_record
  db WORLD_TILE, 241, 209 : dw tile_254_record
  db WORLD_TILE, 241, 225 : dw tile_255_record
  db WORLD_TILE, 241, 241 : dw tile_256_record
  db WORLD_END                       ; this marks the end of the world

;----------------------------------------
; Tile records
;----------------------------------------
;                   dimensions   color
tile_ground   :  db  254,  254,  CYAN_PAPER + BRIGHT
tile_001_record:  db   14,   14,  GREEN_PAPER
tile_002_record:  db   14,   14,  GREEN_PAPER
tile_003_record:  db   14,   14,  GREEN_PAPER
tile_004_record:  db   14,   14,  GREEN_PAPER
tile_005_record:  db   14,   14,  GREEN_PAPER
tile_006_record:  db   14,   14,  GREEN_PAPER
tile_007_record:  db   14,   14,  GREEN_PAPER
tile_008_record:  db   14,   14,  GREEN_PAPER
tile_009_record:  db   14,   14,  GREEN_PAPER
tile_010_record:  db   14,   14,  GREEN_PAPER
tile_011_record:  db   14,   14,  GREEN_PAPER
tile_012_record:  db   14,   14,  GREEN_PAPER
tile_013_record:  db   14,   14,  GREEN_PAPER
tile_014_record:  db   14,   14,  GREEN_PAPER
tile_015_record:  db   14,   14,  GREEN_PAPER
tile_016_record:  db   14,   14,  GREEN_PAPER
tile_017_record:  db   14,   14,  GREEN_PAPER
tile_018_record:  db   14,   14,  GREEN_PAPER
tile_019_record:  db   14,   14,  GREEN_PAPER
tile_020_record:  db   14,   14,  GREEN_PAPER
tile_021_record:  db   14,   14,  GREEN_PAPER
tile_022_record:  db   14,   14,  GREEN_PAPER
tile_023_record:  db   14,   14,  GREEN_PAPER
tile_024_record:  db   14,   14,  GREEN_PAPER
tile_025_record:  db   14,   14,  GREEN_PAPER
tile_026_record:  db   14,   14,  GREEN_PAPER
tile_027_record:  db   14,   14,  GREEN_PAPER
tile_028_record:  db   14,   14,  GREEN_PAPER
tile_029_record:  db   14,   14,  GREEN_PAPER
tile_030_record:  db   14,   14,  GREEN_PAPER
tile_031_record:  db   14,   14,  GREEN_PAPER
tile_032_record:  db   14,   14,  GREEN_PAPER
tile_033_record:  db   14,   14,  GREEN_PAPER
tile_034_record:  db   14,   14,  GREEN_PAPER
tile_035_record:  db   14,   14,  GREEN_PAPER
tile_036_record:  db   14,   14,  GREEN_PAPER
tile_037_record:  db   14,   14,  GREEN_PAPER
tile_038_record:  db   14,   14,  GREEN_PAPER
tile_039_record:  db   14,   14,  GREEN_PAPER
tile_040_record:  db   14,   14,  GREEN_PAPER
tile_041_record:  db   14,   14,  GREEN_PAPER
tile_042_record:  db   14,   14,  GREEN_PAPER
tile_043_record:  db   14,   14,  GREEN_PAPER
tile_044_record:  db   14,   14,  GREEN_PAPER
tile_045_record:  db   14,   14,  GREEN_PAPER
tile_046_record:  db   14,   14,  GREEN_PAPER
tile_047_record:  db   14,   14,  GREEN_PAPER
tile_048_record:  db   14,   14,  GREEN_PAPER
tile_049_record:  db   14,   14,  GREEN_PAPER
tile_050_record:  db   14,   14,  GREEN_PAPER
tile_051_record:  db   14,   14,  GREEN_PAPER
tile_052_record:  db   14,   14,  GREEN_PAPER
tile_053_record:  db   14,   14,  GREEN_PAPER
tile_054_record:  db   14,   14,  GREEN_PAPER
tile_055_record:  db   14,   14,  GREEN_PAPER
tile_056_record:  db   14,   14,  GREEN_PAPER
tile_057_record:  db   14,   14,  GREEN_PAPER
tile_058_record:  db   14,   14,  GREEN_PAPER
tile_059_record:  db   14,   14,  GREEN_PAPER
tile_060_record:  db   14,   14,  GREEN_PAPER
tile_061_record:  db   14,   14,  GREEN_PAPER
tile_062_record:  db   14,   14,  GREEN_PAPER
tile_063_record:  db   14,   14,  GREEN_PAPER
tile_064_record:  db   14,   14,  GREEN_PAPER
tile_065_record:  db   14,   14,  GREEN_PAPER
tile_066_record:  db   14,   14,  GREEN_PAPER
tile_067_record:  db   14,   14,  GREEN_PAPER
tile_068_record:  db   14,   14,  GREEN_PAPER
tile_069_record:  db   14,   14,  GREEN_PAPER
tile_070_record:  db   14,   14,  GREEN_PAPER
tile_071_record:  db   14,   14,  GREEN_PAPER
tile_072_record:  db   14,   14,  GREEN_PAPER
tile_073_record:  db   14,   14,  GREEN_PAPER
tile_074_record:  db   14,   14,  GREEN_PAPER
tile_075_record:  db   14,   14,  GREEN_PAPER
tile_076_record:  db   14,   14,  GREEN_PAPER
tile_077_record:  db   14,   14,  GREEN_PAPER
tile_078_record:  db   14,   14,  GREEN_PAPER
tile_079_record:  db   14,   14,  GREEN_PAPER
tile_080_record:  db   14,   14,  GREEN_PAPER
tile_081_record:  db   14,   14,  GREEN_PAPER
tile_082_record:  db   14,   14,  GREEN_PAPER
tile_083_record:  db   14,   14,  GREEN_PAPER
tile_084_record:  db   14,   14,  GREEN_PAPER
tile_085_record:  db   14,   14,  GREEN_PAPER
tile_086_record:  db   14,   14,  GREEN_PAPER
tile_087_record:  db   14,   14,  GREEN_PAPER
tile_088_record:  db   14,   14,  GREEN_PAPER
tile_089_record:  db   14,   14,  GREEN_PAPER
tile_090_record:  db   14,   14,  GREEN_PAPER
tile_091_record:  db   14,   14,  GREEN_PAPER
tile_092_record:  db   14,   14,  GREEN_PAPER
tile_093_record:  db   14,   14,  GREEN_PAPER
tile_094_record:  db   14,   14,  GREEN_PAPER
tile_095_record:  db   14,   14,  GREEN_PAPER
tile_096_record:  db   14,   14,  GREEN_PAPER
tile_097_record:  db   14,   14,  GREEN_PAPER
tile_098_record:  db   14,   14,  GREEN_PAPER
tile_099_record:  db   14,   14,  GREEN_PAPER
tile_100_record:  db   14,   14,  GREEN_PAPER
tile_101_record:  db   14,   14,  GREEN_PAPER
tile_102_record:  db   14,   14,  GREEN_PAPER
tile_103_record:  db   14,   14,  GREEN_PAPER
tile_104_record:  db   14,   14,  GREEN_PAPER
tile_105_record:  db   14,   14,  GREEN_PAPER
tile_106_record:  db   14,   14,  GREEN_PAPER
tile_107_record:  db   14,   14,  GREEN_PAPER
tile_108_record:  db   14,   14,  GREEN_PAPER
tile_109_record:  db   14,   14,  GREEN_PAPER
tile_110_record:  db   14,   14,  GREEN_PAPER
tile_111_record:  db   14,   14,  GREEN_PAPER
tile_112_record:  db   14,   14,  GREEN_PAPER
tile_113_record:  db   14,   14,  GREEN_PAPER
tile_114_record:  db   14,   14,  GREEN_PAPER
tile_115_record:  db   14,   14,  GREEN_PAPER
tile_116_record:  db   14,   14,  GREEN_PAPER
tile_117_record:  db   14,   14,  GREEN_PAPER
tile_118_record:  db   14,   14,  GREEN_PAPER
tile_119_record:  db   14,   14,  GREEN_PAPER
tile_120_record:  db   14,   14,  GREEN_PAPER
tile_121_record:  db   14,   14,  GREEN_PAPER
tile_122_record:  db   14,   14,  GREEN_PAPER
tile_123_record:  db   14,   14,  GREEN_PAPER
tile_124_record:  db   14,   14,  GREEN_PAPER
tile_125_record:  db   14,   14,  GREEN_PAPER
tile_126_record:  db   14,   14,  GREEN_PAPER
tile_127_record:  db   14,   14,  GREEN_PAPER
tile_128_record:  db   14,   14,  GREEN_PAPER
tile_129_record:  db   14,   14,  GREEN_PAPER
tile_130_record:  db   14,   14,  GREEN_PAPER
tile_131_record:  db   14,   14,  GREEN_PAPER
tile_132_record:  db   14,   14,  GREEN_PAPER
tile_133_record:  db   14,   14,  GREEN_PAPER
tile_134_record:  db   14,   14,  GREEN_PAPER
tile_135_record:  db   14,   14,  GREEN_PAPER
tile_136_record:  db   14,   14,  GREEN_PAPER
tile_137_record:  db   14,   14,  GREEN_PAPER
tile_138_record:  db   14,   14,  GREEN_PAPER
tile_139_record:  db   14,   14,  GREEN_PAPER
tile_140_record:  db   14,   14,  GREEN_PAPER
tile_141_record:  db   14,   14,  GREEN_PAPER
tile_142_record:  db   14,   14,  GREEN_PAPER
tile_143_record:  db   14,   14,  GREEN_PAPER
tile_144_record:  db   14,   14,  GREEN_PAPER
tile_145_record:  db   14,   14,  GREEN_PAPER
tile_146_record:  db   14,   14,  GREEN_PAPER
tile_147_record:  db   14,   14,  GREEN_PAPER
tile_148_record:  db   14,   14,  GREEN_PAPER
tile_149_record:  db   14,   14,  GREEN_PAPER
tile_150_record:  db   14,   14,  GREEN_PAPER
tile_151_record:  db   14,   14,  GREEN_PAPER
tile_152_record:  db   14,   14,  GREEN_PAPER
tile_153_record:  db   14,   14,  GREEN_PAPER
tile_154_record:  db   14,   14,  GREEN_PAPER
tile_155_record:  db   14,   14,  GREEN_PAPER
tile_156_record:  db   14,   14,  GREEN_PAPER
tile_157_record:  db   14,   14,  GREEN_PAPER
tile_158_record:  db   14,   14,  GREEN_PAPER
tile_159_record:  db   14,   14,  GREEN_PAPER
tile_160_record:  db   14,   14,  GREEN_PAPER
tile_161_record:  db   14,   14,  GREEN_PAPER
tile_162_record:  db   14,   14,  GREEN_PAPER
tile_163_record:  db   14,   14,  GREEN_PAPER
tile_164_record:  db   14,   14,  GREEN_PAPER
tile_165_record:  db   14,   14,  GREEN_PAPER
tile_166_record:  db   14,   14,  GREEN_PAPER
tile_167_record:  db   14,   14,  GREEN_PAPER
tile_168_record:  db   14,   14,  GREEN_PAPER
tile_169_record:  db   14,   14,  GREEN_PAPER
tile_170_record:  db   14,   14,  GREEN_PAPER
tile_171_record:  db   14,   14,  GREEN_PAPER
tile_172_record:  db   14,   14,  GREEN_PAPER
tile_173_record:  db   14,   14,  GREEN_PAPER
tile_174_record:  db   14,   14,  GREEN_PAPER
tile_175_record:  db   14,   14,  GREEN_PAPER
tile_176_record:  db   14,   14,  GREEN_PAPER
tile_177_record:  db   14,   14,  GREEN_PAPER
tile_178_record:  db   14,   14,  GREEN_PAPER
tile_179_record:  db   14,   14,  GREEN_PAPER
tile_180_record:  db   14,   14,  GREEN_PAPER
tile_181_record:  db   14,   14,  GREEN_PAPER
tile_182_record:  db   14,   14,  GREEN_PAPER
tile_183_record:  db   14,   14,  GREEN_PAPER
tile_184_record:  db   14,   14,  GREEN_PAPER
tile_185_record:  db   14,   14,  GREEN_PAPER
tile_186_record:  db   14,   14,  GREEN_PAPER
tile_187_record:  db   14,   14,  GREEN_PAPER
tile_188_record:  db   14,   14,  GREEN_PAPER
tile_189_record:  db   14,   14,  GREEN_PAPER
tile_190_record:  db   14,   14,  GREEN_PAPER
tile_191_record:  db   14,   14,  GREEN_PAPER
tile_192_record:  db   14,   14,  GREEN_PAPER
tile_193_record:  db   14,   14,  GREEN_PAPER
tile_194_record:  db   14,   14,  GREEN_PAPER
tile_195_record:  db   14,   14,  GREEN_PAPER
tile_196_record:  db   14,   14,  GREEN_PAPER
tile_197_record:  db   14,   14,  GREEN_PAPER
tile_198_record:  db   14,   14,  GREEN_PAPER
tile_199_record:  db   14,   14,  GREEN_PAPER
tile_200_record:  db   14,   14,  GREEN_PAPER
tile_201_record:  db   14,   14,  GREEN_PAPER
tile_202_record:  db   14,   14,  GREEN_PAPER
tile_203_record:  db   14,   14,  GREEN_PAPER
tile_204_record:  db   14,   14,  GREEN_PAPER
tile_205_record:  db   14,   14,  GREEN_PAPER
tile_206_record:  db   14,   14,  GREEN_PAPER
tile_207_record:  db   14,   14,  GREEN_PAPER
tile_208_record:  db   14,   14,  GREEN_PAPER
tile_209_record:  db   14,   14,  GREEN_PAPER
tile_210_record:  db   14,   14,  GREEN_PAPER
tile_211_record:  db   14,   14,  GREEN_PAPER
tile_212_record:  db   14,   14,  GREEN_PAPER
tile_213_record:  db   14,   14,  GREEN_PAPER
tile_214_record:  db   14,   14,  GREEN_PAPER
tile_215_record:  db   14,   14,  GREEN_PAPER
tile_216_record:  db   14,   14,  GREEN_PAPER
tile_217_record:  db   14,   14,  GREEN_PAPER
tile_218_record:  db   14,   14,  GREEN_PAPER
tile_219_record:  db   14,   14,  GREEN_PAPER
tile_220_record:  db   14,   14,  GREEN_PAPER
tile_221_record:  db   14,   14,  GREEN_PAPER
tile_222_record:  db   14,   14,  GREEN_PAPER
tile_223_record:  db   14,   14,  GREEN_PAPER
tile_224_record:  db   14,   14,  GREEN_PAPER
tile_225_record:  db   14,   14,  GREEN_PAPER
tile_226_record:  db   14,   14,  GREEN_PAPER
tile_227_record:  db   14,   14,  GREEN_PAPER
tile_228_record:  db   14,   14,  GREEN_PAPER
tile_229_record:  db   14,   14,  GREEN_PAPER
tile_230_record:  db   14,   14,  GREEN_PAPER
tile_231_record:  db   14,   14,  GREEN_PAPER
tile_232_record:  db   14,   14,  GREEN_PAPER
tile_233_record:  db   14,   14,  GREEN_PAPER
tile_234_record:  db   14,   14,  GREEN_PAPER
tile_235_record:  db   14,   14,  GREEN_PAPER
tile_236_record:  db   14,   14,  GREEN_PAPER
tile_237_record:  db   14,   14,  GREEN_PAPER
tile_238_record:  db   14,   14,  GREEN_PAPER
tile_239_record:  db   14,   14,  GREEN_PAPER
tile_240_record:  db   14,   14,  GREEN_PAPER
tile_241_record:  db   14,   14,  GREEN_PAPER
tile_242_record:  db   14,   14,  GREEN_PAPER
tile_243_record:  db   14,   14,  GREEN_PAPER
tile_244_record:  db   14,   14,  GREEN_PAPER
tile_245_record:  db   14,   14,  GREEN_PAPER
tile_246_record:  db   14,   14,  GREEN_PAPER
tile_247_record:  db   14,   14,  GREEN_PAPER
tile_248_record:  db   14,   14,  GREEN_PAPER
tile_249_record:  db   14,   14,  GREEN_PAPER
tile_250_record:  db   14,   14,  GREEN_PAPER
tile_251_record:  db   14,   14,  GREEN_PAPER
tile_252_record:  db   14,   14,  GREEN_PAPER
tile_253_record:  db   14,   14,  GREEN_PAPER
tile_254_record:  db   14,   14,  GREEN_PAPER
tile_255_record:  db   14,   14,  GREEN_PAPER
tile_256_record:  db   14,   14,  GREEN_PAPER
