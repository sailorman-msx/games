;Compiles the player, the music and sfxs, using RASM.
;No ORG needed.

    ;This is the music, and its config file.
    include "TRAINING_BGM.asm" 
    include "TRAINING_BGM_playerconfig.asm" 
 
    ;What hardware? Uncomment the right one.
    PLY_AKG_HARDWARE_MSX = 1        

    ;Comment/delete this line if not using sound effects.
    PLY_AKG_MANAGE_SOUND_EFFECTS = 1

    ;ROM
    PLY_AKG_Rom = 1
    PLY_AKG_ROM_Buffer = #d900

    ;This is the player.
    include "PlayerAkg.asm"
