AnimatePartyMon_ForceSpeed1:
	xor a
	ld [wCurrentMenuItem], a
	ld b, a
	inc a
	jr GetAnimationSpeed

; wPartyMenuHPBarColors contains the party mon's health bar colors
; 0: green
; 1: yellow
; 2: red
AnimatePartyMon::
	ld hl, wPartyMenuHPBarColors
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]

GetAnimationSpeed:
	ld c, a
	ld hl, PartyMonSpeeds
	add hl, bc
	ld a, [wOnSGB]
	xor $1
	add [hl]
	ld c, a
	add a
	ld b, a
	ld a, [wAnimCounter]
	and a
	jr z, .resetSprites
	cp c
	jr z, .animateSprite
.incTimer
	inc a
	cp b
	jr nz, .skipResetTimer
	xor a ; reset timer
.skipResetTimer
	ld [wAnimCounter], a
	jp DelayFrame
.resetSprites
	push bc
	ld hl, wMonPartySpritesSavedOAM
	ld de, wShadowOAM
	ld bc, $60
	call CopyData
	pop bc
	xor a
	jr .incTimer
.animateSprite
	push bc
	ld hl, wShadowOAMSprite00TileID
	ld bc, $10
	ld a, [wCurrentMenuItem]
	call AddNTimes
;	ld c, ICONOFFSET
;	ld a, [hl]
;	cp ICON_BALL << 2
;	jr z, .editCoords
;	cp ICON_HELIX << 2
;	jr nz, .editTileIDS
; ICON_BALL and ICON_HELIX only shake up and down
;.editCoords
;	dec hl
;	dec hl ; dec hl to the OAM y coord
;	ld c, $1 ; amount to increase the y coord by
; otherwise, load a second sprite frame
;.editTileIDS
	ld c, $2
	ld b, $4
	ld de, $4
.loop
	ld a, [hl]
	add c
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	pop bc
	ld a, c
	jr .incTimer

; Party mon animations cycle between 2 frames.
; The members of the PartyMonSpeeds array specify the number of V-blanks
; that each frame lasts for green HP, yellow HP, and red HP in order.
; On the naming screen, the yellow HP speed is always used.
PartyMonSpeeds:
	db 10, 24, 32

LoadMonPartySpriteGfx:
; Load mon party sprite tile patterns into VRAM during V-blank.
	ld hl, MonPartySpritePointers
	ld a, $1c

LoadAnimSpriteGfx:
; Load animated sprite tile patterns into VRAM during V-blank. hl is the address
; of an array of structures that contain arguments for CopyVideoData and a is
; the number of structures in the array.
	ld bc, $0
.loop
	push af
	push bc
	push hl
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CopyVideoData
	pop hl
	pop bc
	ld a, $6
	add c
	ld c, a
	pop af
	dec a
	jr nz, .loop
	ret

LoadMonPartySpriteGfxWithLCDDisabled:
; Load mon party sprite tile patterns into VRAM immediately by disabling the
; LCD.
	call DisableLCD
	ld hl, MonPartySpritePointers
	ld a, $1c
	ld bc, $0
.loop
	push af
	push bc
	push hl
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	ld a, [hli]
	ld c, a
	swap c
	ld b, $0
	ld a, [hli]
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	call FarCopyData2
	pop hl
	pop bc
	ld a, $6
	add c
	ld c, a
	pop af
	dec a
	jr nz, .loop
	jp EnableLCD

INCLUDE "data/icon_pointers.asm"

WriteMonPartySpriteOAMByPartyIndex:
; Write OAM blocks for the party mon in [hPartyMonIndex].
	push hl
	push de
	push bc
	ldh a, [hPartyMonIndex]
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	call GetPartyMonSpriteID
	ld [wOAMBaseTile], a
	call WriteMonPartySpriteOAM
	pop bc
	pop de
	pop hl
	ret

WriteMonPartySpriteOAMBySpecies:
; Write OAM blocks for the party sprite of the species in
; [wMonPartySpriteSpecies].
	xor a
	ldh [hPartyMonIndex], a
	ld a, [wMonPartySpriteSpecies]
	call GetPartyMonSpriteID
	ld [wOAMBaseTile], a
	jr WriteMonPartySpriteOAM

UnusedPartyMonSpriteFunction:
; This function is unused and doesn't appear to do anything useful. It looks
; like it may have been intended to load the tile patterns and OAM data for
; the mon party sprite associated with the species in [wCurPartySpecies].
; However, its calculations are off and it loads garbage data.
	ld a, [wcf91]
	call GetPartyMonSpriteID
	push af
	ld hl, vSprites tile $00
	call .LoadTilePatterns
	pop af
	add $54
	ld hl, vSprites tile $04
	call .LoadTilePatterns
	xor a
	ld [wMonPartySpriteSpecies], a
	jr WriteMonPartySpriteOAMBySpecies

.LoadTilePatterns
	push hl
	add a
	ld c, a
	ld b, 0
	ld hl, MonPartySpritePointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	jp CopyVideoData

WriteMonPartySpriteOAM:
; Write the OAM blocks for the first animation frame into the OAM buffer and
; make a copy at wMonPartySpritesSavedOAM.
	push af
	ld c, $10
	ld h, HIGH(wShadowOAM)
	ldh a, [hPartyMonIndex]
	swap a
	ld l, a
	add $10
	ld b, a
	pop af
	cp ICON_HELIX << 2
	jr z, .helix
	call WriteSymmetricMonPartySpriteOAM
	jr .makeCopy
.helix
	call WriteAsymmetricMonPartySpriteOAM
; Make a copy of the OAM buffer with the first animation frame written so that
; we can flip back to it from the second frame by copying it back.
.makeCopy
	ld hl, wShadowOAM
	ld de, wMonPartySpritesSavedOAM
	ld bc, $60
	jp CopyData

GetPartyMonSpriteID:
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	ld c, a
	dec a
	srl a
	ld hl, MonPartyData
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	bit 0, c ; even or odd?
	jr nz, .skipSwap
	swap a ; use lower nybble if pokedex num is even
.skipSwap
	and $f0
	srl a ; value == ICON constant << 2
	srl a
	ret

INCLUDE "data/pokemon/menu_icons.asm"

DEF INC_FRAME_1 EQUS "0, $20"
DEF INC_FRAME_2 EQUS "$20, $20"

BugIconFrame1:       INCBIN "gfx/icons/bug.2bpp", INC_FRAME_1
PlantIconFrame1:     INCBIN "gfx/icons/plant.2bpp", INC_FRAME_1
BugIconFrame2:       INCBIN "gfx/icons/bug.2bpp", INC_FRAME_2
PlantIconFrame2:     INCBIN "gfx/icons/plant.2bpp", INC_FRAME_2
SnakeIconFrame1:     INCBIN "gfx/icons/snake.2bpp", INC_FRAME_1
QuadrupedIconFrame1: INCBIN "gfx/icons/quadruped.2bpp", INC_FRAME_1
SnakeIconFrame2:     INCBIN "gfx/icons/snake.2bpp", INC_FRAME_2
QuadrupedIconFrame2: INCBIN "gfx/icons/quadruped.2bpp", INC_FRAME_2

TradeBubbleIconGFX:  INCBIN "gfx/trade/bubble.2bpp"

PUSHS

SECTION "Party Mon Sprites Routines", ROMX

; load and place the party mon icon according to wMonPartySpriteSpecies
; load and place the party mon icon according to wMonPartySpriteSpecies
LoadSinglePartyMonSprite:
	; load into the start of VRAM
	call DisableLCD
	ld a, [wMonPartySpriteSpecies]
	ld de, vSprites
	call LoadPartyMonSprite

	farcall LoadSinglePartySpritePalette

	call EnableLCD

	; place into the start of OAM
	ld a, [hPartyMonIndex]
	push af
	xor a
	ld [hPartyMonIndex], a
	
	call PlaceSinglePartyMonSprite

	pop af
	ld [hPartyMonIndex], a
	ret

; load the party mon icon for all mon in the party
LoadPartyMonSprites:
	call DisableLCD
	ld de, vSprites
	ld hl, wPartySpecies
.loop
	ld a, [hli]
	cp -1
	jr z, .done
	push hl
	call LoadPartyMonSprite
	pop hl
	jr .loop
.done

	farcall LoadPartyMenuSpritePalettes

	jp EnableLCD

; copy the 8-tile icon for the mon in register a to de
LoadPartyMonSprite:
	push de

	ld [wd11e], a
	predef IndexToPokedex

	; hMultiplicand = pokedex number - 1
	xor a
	ld [hMultiplicand], a
	ld [hMultiplicand + 1], a
	ld a, [wd11e]
	dec a
	ld [hMultiplicand + 2], a

	; hMultiplier = icon size, in bytes
	ld a, 8 tiles
	ld [hMultiplier], a

	call Multiply

	; hl = icon offset
	ld a, [hProduct + 2]
	ld h, a
	ld a, [hProduct + 3]
	ld l, a

	; if offset < $4000, use first icon bank
	bit 6, h
	set 6, h
	ld a, BANK(PartyMonSprites)
	jr z, .gotBank

	; otherwise, use second icon bank
	inc a

.gotBank
	ld bc, 8 tiles
	pop de
	jp FarCopyData

; copy 1 full entry (16 bytes) from PartyMonOAM into wShadowOAM according to hPartyMonIndex
; and backup wShadowOAM into wMonPartySpritesSavedOAM
PlaceSinglePartyMonSprite:
	push hl
	push de
	push bc

	jr PlacePartyMonSpriteCommon

PlacePartyMonSprite:
	push hl
	push de
	push bc

IF ALT_PARTY_MENU_COLOR
	ld a, [hPartyMonIndex]
	ld [wPartySpritePaletteSlot], a
ELSE
	farcall FindPartySpritePalette
ENDC

PlacePartyMonSpriteCommon:
	; bc = hPartyMonIndex * 16
	ld a, [hPartyMonIndex]
	add a 
	add a
	ld c, a
	add a
	add c
	ld e, a
	ld d, 0
	add c
	ld c, a
	ld b, 0

	; de = source address
	ld hl, PartyMonOAM
	add hl, de
	ld d, h
	ld e, l

	; hl = destination address
	ld hl, wShadowOAM
	add hl, bc

	ld b, 4
.bigLoop
	ld c, 3
.smallLoop
; Copy bc bytes from hl to de.
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .smallLoop
; Palette slot to use :
	ld a, [wPartySpritePaletteSlot]
	ld [hli], a
	dec b
	jr nz, .bigLoop

	; make backup
	ld hl, wShadowOAM
	ld de, wMonPartySpritesSavedOAM
	ld bc, 4 * 4 * PARTY_LENGTH
	call CopyData

	pop bc
	pop de
	pop hl
	ret

PartyMonOAM:
	db $10, $10, $00 ;, $00
	db $10, $18, $01 ;, $00
	db $18, $10, $04 ;, $00
	db $18, $18, $05 ;, $00

	db $20, $10, $08 ;, $00
	db $20, $18, $09 ;, $00
	db $28, $10, $0c ;, $00
	db $28, $18, $0d ;, $00

	db $30, $10, $10 ;, $00
	db $30, $18, $11 ;, $00
	db $38, $10, $14 ;, $00
	db $38, $18, $15 ;, $00

	db $40, $10, $18 ;, $00
	db $40, $18, $19 ;, $00
	db $48, $10, $1c ;, $00
	db $48, $18, $1d ;, $00

	db $50, $10, $20 ;, $00
	db $50, $18, $21 ;, $00
	db $58, $10, $24 ;, $00
	db $58, $18, $25 ;, $00

	db $60, $10, $28 ;, $00
	db $60, $18, $29 ;, $00
	db $68, $10, $2c ;, $00
	db $68, $18, $2d ;, $00


SECTION "Party Mon Sprites Gfx 1", ROMX

PartyMonSprites:
INCBIN "gfx/icons/party_mon_sprites.2bpp", $0, $4000


SECTION "Party Mon Sprites Gfx 2", ROMX

INCBIN "gfx/icons/party_mon_sprites.2bpp", $4000

POPS
