; overworld sprites
; SpriteSheetPointerTable indexes (see data/sprites/sprites.asm)
	const_def
	const SPRITE_NONE                    ; $00
	const SPRITE_RED                     ; $01
	const SPRITE_BLUE                    ; $02
	const SPRITE_OAK                     ; $03
	const SPRITE_YOUNGSTER               ; $04
	const SPRITE_MONSTER                 ; $05
	const SPRITE_COOLTRAINER_F           ; $06
	const SPRITE_COOLTRAINER_M           ; $07
	const SPRITE_LITTLE_GIRL             ; $08
	const SPRITE_BIRD                    ; $09
	const SPRITE_MIDDLE_AGED_MAN         ; $0a
	const SPRITE_GAMBLER                 ; $0b
	const SPRITE_SUPER_NERD              ; $0c
	const SPRITE_GIRL                    ; $0d
	const SPRITE_HIKER                   ; $0e
	const SPRITE_BEAUTY                  ; $0f
	const SPRITE_GENTLEMAN               ; $10
	const SPRITE_DAISY                   ; $11
	const SPRITE_BIKER                   ; $12
	const SPRITE_SAILOR                  ; $13
	const SPRITE_COOK                    ; $14
	const SPRITE_BIKE_SHOP_CLERK         ; $15
	const SPRITE_MR_FUJI                 ; $16
	const SPRITE_GIOVANNI                ; $17
	const SPRITE_ROCKET                  ; $18
	const SPRITE_CHANNELER               ; $19
	const SPRITE_WAITER                  ; $1a
	const SPRITE_SILPH_WORKER_F          ; $1b
	const SPRITE_MIDDLE_AGED_WOMAN       ; $1c
	const SPRITE_BRUNETTE_GIRL           ; $1d
	const SPRITE_LANCE                   ; $1e
	const SPRITE_UNUSED_SCIENTIST        ; $1f
	const SPRITE_SCIENTIST               ; $20
	const SPRITE_ROCKER                  ; $21
	const SPRITE_SWIMMER                 ; $22
	const SPRITE_SAFARI_ZONE_WORKER      ; $23
	const SPRITE_GYM_GUIDE               ; $24
	const SPRITE_GRAMPS                  ; $25
	const SPRITE_CLERK                   ; $26
	const SPRITE_FISHING_GURU            ; $27
	const SPRITE_GRANNY                  ; $28
	const SPRITE_NURSE                   ; $29
	const SPRITE_LINK_RECEPTIONIST       ; $2a
	const SPRITE_SILPH_PRESIDENT         ; $2b
	const SPRITE_SILPH_WORKER_M          ; $2c
	const SPRITE_WARDEN                  ; $2d
	const SPRITE_CAPTAIN                 ; $2e
	const SPRITE_FISHER                  ; $2f
	const SPRITE_KOGA                    ; $30
	const SPRITE_GUARD                   ; $31
	const SPRITE_UNUSED_GUARD            ; $32
	const SPRITE_MOM                     ; $33
	const SPRITE_BALDING_GUY             ; $34
	const SPRITE_LITTLE_BOY              ; $35
	const SPRITE_UNUSED_GAMEBOY_KID      ; $36
	const SPRITE_GAMEBOY_KID             ; $37
	const SPRITE_FAIRY                   ; $38
	const SPRITE_AGATHA                  ; $39
	const SPRITE_BRUNO                   ; $3a
	const SPRITE_LORELEI                 ; $3b
	const SPRITE_SEEL                    ; $3c
	const SPRITE_BROCK
	const SPRITE_MISTY
	const SPRITE_SURGE
	const SPRITE_ERIKA
	const SPRITE_SABRINA
	const SPRITE_BLAINE
	const SPRITE_BILL
	const SPRITE_OFFICER_JENNY
	const SPRITE_JANINE
	const SPRITE_ARTICUNO
	const SPRITE_BULBASAUR  				 
	const SPRITE_CHANSEY				 
	const SPRITE_CLEFAIRY				
	const SPRITE_CUBONE			
	const SPRITE_KANGASKHAN				 
	const SPRITE_LAPRAS					 
	const SPRITE_MEOWTH					 
	const SPRITE_MEWTWO					 
	const SPRITE_MOLTRES				 
	const SPRITE_NIDORINO				 
	const SPRITE_OMANYTE
	const SPRITE_PIDGEOT				 
	const SPRITE_POLYWRATH				 
	const SPRITE_PSYDUCK				 
	const SPRITE_SLOWBRO				 
	const SPRITE_SLOWPOKE				 
	const SPRITE_SPEAROW				 
	const SPRITE_VOLTORB
	const SPRITE_ELECTRODE				 				 
	const SPRITE_DODUO				
	const SPRITE_FEAROW					 
	const SPRITE_JIGGLYPUFF				 
	const SPRITE_KABUTO
	const SPRITE_MACHOKE				 
	const SPRITE_MACHOP					
	const SPRITE_NIDORANF				 
	const SPRITE_NIDORANM				 
	const SPRITE_PIDGEY					 
	const SPRITE_PIKACHU				 
	const SPRITE_SEEL2					
	const SPRITE_ZAPDOS					
DEF FIRST_STILL_SPRITE EQU const_value
	const SPRITE_POKE_BALL               ; $3d
	const SPRITE_FOSSIL                  ; $3e
	const SPRITE_BOULDER                 ; $3f
	const SPRITE_PAPER                   ; $40
	const SPRITE_POKEDEX                 ; $41
	const SPRITE_CLIPBOARD               ; $42
	const SPRITE_SNORLAX                 ; $43
	const SPRITE_UNUSED_OLD_AMBER        ; $44
	const SPRITE_OLD_AMBER               ; $45
	const SPRITE_UNUSED_GAMBLER_ASLEEP_1 ; $46
	const SPRITE_UNUSED_GAMBLER_ASLEEP_2 ; $47
	const SPRITE_GAMBLER_ASLEEP          ; $48
	const SPRITE_POKEDEX1                ; $49
	const SPRITE_POKE_BALL2              ; $50
	const SPRITE_WIGGLYTUFF              ; $51
DEF NUM_SPRITES EQU const_value - 1
