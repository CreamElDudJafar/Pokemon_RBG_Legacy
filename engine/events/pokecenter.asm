DisplayPokemonCenterDialogue_::
	call SaveScreenTilesToBuffer1 ; save screen
	CheckEvent EVENT_FIRST_POKECENTER
	jr nz, .skiptext1
	ld hl, PokemonCenterWelcomeText
	rst _PrintText
	ld hl, wd72e
	bit 2, [hl]
	set 1, [hl]
	set 2, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	rst _PrintText
.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declinedHealing ; if the player chose No
	jp .skipHealingText
.skiptext1
	ld hl, ShallWeHealYourPokemonFastText
	rst _PrintText
.skipHealingText
	call SetLastBlackoutMap
	call LoadScreenTilesFromBuffer1 ; restore screen
	call LoadCurrentMapView
	CheckEvent EVENT_FIRST_POKECENTER
	jr nz, .skiptext2
	ld hl, NeedYourPokemonText
	rst _PrintText
.skiptext2
	ld a, $18
	ld [wSprite01StateData1ImageIndex], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	farcall AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	rst _PlaySound
	ld hl, PokemonFightingFitText
	rst _PrintText
.FightingFitShort
	ld a, $14
	ld [wSprite01StateData1ImageIndex], a ; make the nurse bow
	ld c, a
	rst _DelayFrames
	jr .done
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
	jp .skipEventFirstPokecenter
.done
	SetEvent EVENT_FIRST_POKECENTER
.skipEventFirstPokecenter
	ld hl, PokemonCenterFarewellText
	rst _PrintText
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	jp UpdateSprites

PokemonCenterWelcomeText:
	text_far _PokemonCenterWelcomeText
	text_end

ShallWeHealYourPokemonText:
	text_pause
	text_far _ShallWeHealYourPokemonText
	text_end

ShallWeHealYourPokemonFastText:
	text_far _ShallWeHealYourPokemonText
	text_pause
	text_end

NeedYourPokemonText:
	text_far _NeedYourPokemonText
	text_end

PokemonFightingFitText:
	text_far _PokemonFightingFitText
	text_end

PokemonCenterFarewellText:
;	text_pause
	text_far _PokemonCenterFarewellText
	text_end
