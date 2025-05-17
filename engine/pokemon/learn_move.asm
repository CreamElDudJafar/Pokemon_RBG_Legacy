LearnMove:
	ld a, [wIsInBattle]
	and a
	jr z, .skip
	call SaveScreenTilesToBuffer1
.skip
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, wcd6d
	ld de, wLearnMoveMonName
	ld bc, NAME_LENGTH
	rst _CopyData

DontAbandonLearning:
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2Moves - wPartyMon1Moves
	ld a, [wWhichPokemon]
	call AddNTimes
	ld d, h
	ld e, l
	ld b, NUM_MOVES
.findEmptyMoveSlotLoop
	ld a, [hl]
	and a
	jr z, .next
	inc hl
	dec b
	jr nz, .findEmptyMoveSlotLoop
	push de
	call TryingToLearn
	pop de
	jp c, AbandonLearning
	push hl
	push de
	ld [wd11e], a
	call GetMoveName
	ld hl, OneTwoAndText
	rst _PrintText
	pop de
	pop hl
.next
	ld a, [wMoveNum]
	ld [hl], a
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl, bc
	push hl
	push de
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wBuffer + 5] ; a = move's max PP
	pop de
	pop hl
	ld [hl], a
	ld a, [wIsInBattle]
	and a
	jp z, PrintLearnedMove
	ld a, [wWhichPokemon]
	ld b, a
	ld a, [wPlayerMonNumber]
	cp b
	jp nz, PrintLearnedMove
	ld h, d
	ld l, e
	ld de, wBattleMonMoves
	ld bc, NUM_MOVES
	rst _CopyData
	ld bc, wPartyMon1PP - wPartyMon1OTID
	add hl, bc
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	rst _CopyData
	jp PrintLearnedMove

AbandonLearning:
	ld hl, AbandonLearningText
	rst _PrintText
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jp nz, DontAbandonLearning
	ld hl, DidNotLearnText
	rst _PrintText
	ld a, [wIsInBattle]
	and a
	jr z, .skip
	call LoadScreenTilesFromBuffer1
.skip
	ld b, 0
	ret

PrintLearnedMove:
	ld a, [wIsInBattle]
	and a
	jr z, .skip
	call LoadScreenTilesFromBuffer1
.skip
	ld hl, LearnedMove1Text
	rst _PrintText
	ld b, 1
	ret

TryingToLearn:
	push hl
	ld hl, TryingToLearnText
	rst _PrintText
	call ShowMoveInfo ; movetype info
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	pop hl
	ld a, [wCurrentMenuItem]
	rra
	ret c
	ld bc, -NUM_MOVES
	add hl, bc
	push hl
	ld de, wMoves
	ld bc, NUM_MOVES
	rst _CopyData
	callfar FormatMovesString
	pop hl
.loop
	push hl
	ld hl, WhichMoveToForgetText
	rst _PrintText
	hlcoord 4, 7
	ld b, 4
	ld c, 14
	call TextBoxBorder
	hlcoord 6, 8
	ld de, wMovesString
	ldh a, [hUILayoutFlags]
	set 2, a
	ldh [hUILayoutFlags], a
	call PlaceString
	ldh a, [hUILayoutFlags]
	res 2, a
	ldh [hUILayoutFlags], a
	ld hl, wTopMenuItemY
	ld a, 8
	ld [hli], a ; wTopMenuItemY
	ld a, 5
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, [wNumMovesMinusOne]
	ld [hli], a ; wMaxMenuItem
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	ld [hl], 0 ; wLastMenuItem
	ld hl, hUILayoutFlags
	set 1, [hl]
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res 1, [hl]
;	push af
;	call LoadScreenTilesFromBuffer1
;	pop af
	pop hl
	bit BIT_B_BUTTON, a
	jr nz, .cancel
	push hl
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	push af
;	push bc
;	call IsMoveHM
;	pop bc
	pop de
	ld a, d
;       jr c, .hm
	pop hl
	add hl, bc
	and a
	ret
; .hm
;	ld hl, HMCantDeleteText
;	rst _PrintText
;	pop hl
;	jr .loop
.cancel
	scf
	ret

ShowMoveInfo:
	; read the new move's info first
	ld a, [wMoveNum]
	ld [wd11e], a
	call GetMoveName
	ld a, [wMoveNum]
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	; add a pop-up with the new move's info
	hlcoord 0, 0
	lb bc, 5, 18
	call TextBoxBorder
	call HidePartySprites
	; show the move's name on the top
	hlcoord 4, 0
	ld de, wStringBuffer
	call PlaceString
	; move info labels
	hlcoord 1, 1
	ld de, MoveInfoLabels
	call PlaceString
	; place the move's type
	hlcoord 7, 1
	predef PrintBufferedMoveType
	; place the move's power
	hlcoord 6, 2
	ld de, wBuffer + 2
	ld a, [de]
	cp 1
	jr z, .nullString
	and a
	jr z, .nullString
	jr .notZero1
.nullString
	ld de, NullMoveInfoLabel
	call PlaceString
	jr .powerDone
.notZero1
	lb bc, 1, 3
	call PrintNumber
.powerDone
	; place the move's accuracy
	ld a, [wBuffer + 4]
	call ConvertPercentages
	ld [wBuffer + 6], a ; after the actual move data
	ld de, wBuffer + 6
	hlcoord 15, 2
	lb bc, 1, 3
	call PrintNumber
	farcall PrintMoveDescription
	ret

; [info] Luna fixed this for me, I do not know why it works	
ConvertPercentagesBattle::
	ld a, [wPlayerMoveAccuracy]
	call ConvertPercentages
	ld [wBuffer], a
	ret

; This converts values out of 256 into a value
; out of 100. It achieves this by multiplying
; the value by 100 and dividing it by 256.
; taken from a pokecrystal tutorial, which was apparently
; based on code by ax6, and adjusted for rounding
ConvertPercentages:
    ; Overwrite the "hl" register.
    ld l, a
    ld h, 0
    push af
    ; Multiplies the value of the "hl" register by 3.
    add hl, hl
    add a, l
    ld l, a
    adc h
    sub l
    ld h, a
    ; Multiplies the value of the "hl" register
    ; by 8. The value of the "hl" register
    ; is now 24 times its original value.
    add hl, hl
    add hl, hl
    add hl, hl
    ; Add the original value of the "hl" value to itself,
    ; making it 25 times its original value.
    pop af
    add a, l
    ld l, a
    adc h
    sbc l
    ld h, a
    ; Multiply the value of the "hl" register by
    ; 4, making it 100 times its original value.
    add hl, hl
    add hl, hl
    ; Set the "l" register to 0.5, otherwise the rounded
    ; value may be lower than expected. Round the
    ; high byte to nearest and drop the low byte.
    ld l, $80
    sla l
    sbc a
    and 1
    add a, h
    ret

HidePartySprites:
	ld a, 160
	ld hl, wShadowOAM
	ld de, 4
	ld b, 4 * 4
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

LearnedMove1Text:
	text_far _LearnedMove1Text
	sound_get_item_1 ; plays SFX_GET_ITEM_1 in the party menu (rare candy) and plays SFX_LEVEL_UP in battle
	text_promptbutton
	text_end

WhichMoveToForgetText:
	text_far _WhichMoveToForgetText
	text_end

AbandonLearningText:
	text_far _AbandonLearningText
	text_end

DidNotLearnText:
	text_far _DidNotLearnText
	text_end

TryingToLearnText:
	text_far _TryingToLearnText
	text_end

OneTwoAndText:
	text_far _OneTwoAndText
	text_pause
	text_asm
	push af
	push bc
	push de
	push hl
	ld a, $1
	ld [wMuteAudioAndPauseMusic], a
	call DelayFrame
	ld a, [wAudioROMBank]
	push af
	ld a, BANK(SFX_Swap_1)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	call WaitForSoundToFinish
	ld a, SFX_SWAP
	call PlaySound
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wMuteAudioAndPauseMusic], a
	pop hl
	pop de
	pop bc
	pop af
	ld hl, PoofText
	ret

PoofText:
	text_far _PoofText
	text_pause
ForgotAndText:
	text_far _ForgotAndText
	text_end

;HMCantDeleteText:
;	text_far _HMCantDeleteText
;	text_end

MoveInfoLabels:
	db   "TYPE:"
	feed "PWR:     ACC:    %"
	db "@"
NullMoveInfoLabel:
	db "---@"
