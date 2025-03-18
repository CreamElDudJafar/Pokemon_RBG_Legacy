; Called whenever the link cable appears. Loads PAL_MEWMON on all bg palettes.
Trade_LoadCablePalettes:
	; Load PAL_MEWMON to all background palettes
	ld a, 2
	ldh [rSVBK], a
	ld d, PAL_MEWMON
	ld e, 0
.loop
	push de
	callfar LoadSGBPalette
	pop de
	inc e
	ld a, e
	cp 8
	jr nz, .loop

	ld a, 1
	ld [W2_ForceBGPUpdate], a
	xor a
	ldh [rSVBK], a
	ret


; Called just before loading the pokemon sprites for moving through the link cable.
; This function sort of "patches" the result of "LoadAnimationTileset", so it should be
; called after any such animations occur.
Trade_InitGameboyTransferGfx_ColorHook:
	call Trade_LoadCablePalettes

	ld a, 2
	ldh [rSVBK], a

;	callfar LoadAttackSpritePalettes

	; Set the palettes to use for the pokemon sprites
	ld b, $30
	ld hl, W2_SpritePaletteMap
	ld a, 0 ; ATK_PAL_GREY
.loop
	ld [hl], a
	set 6, l
	ld [hli], a
	res 6, l
	dec b
	jr nz, .loop

	; Set the palettes for the "glow" behind the pokemon
	; Use the "purple" palette to match the exact color of the link cable.
	ld d, PAL_MEWMON
	ld e, ATK_PAL_PURPLE
	farcall LoadSGBPalette_Sprite

	ld hl, W2_SpritePaletteMap + $38
	ld b, 6
	ld a, 7 ; ATK_PAL_PURPLE
.loop2
	ld [hl], a
	set 6, l
	ld [hli], a
	res 6, l
	dec b
	jr nz, .loop2

	; Make the Circle around the pokemon flash with the link cable
	ld a, %10000000
	ld [W2_UseOBP1], a

	xor a
	ldh [rSVBK], a

	jp Trade_InitGameboyTransferGfx


; Called at start of trade sequence. This prevents some minor graphical garbage from
; showing up.
LoadTradingGFXAndMonNames_ColorHook:
	call LoadTradingGFXAndMonNames
	call Trade_LoadCablePalettes
	jp DelayFrame
