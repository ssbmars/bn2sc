.gba
.open "bn2.gba", "bn2sc.gba", 0x8000000

// chip lockout, abbreviated "cl", is a state where megaman can move and
// shoot the buster, but cannot use chips or B Left abilities.
// the byte at 02008AD0 tracks the duration of chip lockout
// cl can be applied simply by writing to this address

ShieldOffset EQU 0x19

// hook shield code to run new function at the end
.org 0x08087534
	bl	ShieldLag

// track shield lockout separately from chip lockout
.org 0x08089216
	bl	ReadChipLockout
	mov		r1,0x10
	tst		r6,r1
	bne		AllowChip
	bl		ReadAbilityLockout
	b		AllowAbility
	nop
	
.org 0x08089228	::	AllowChip:
.org 0x08089230	::	AllowAbility:


// write new code here
// this is "free space" but I'm not entirely sure it's unused 
.org 0x0806CD30


ReadChipLockout:
	// also iterate ability lockout since this part always runs
	ldrb	r0,[r5,ShieldOffset]
	sub		r0,0x1
	bmi		@@skipwrite
	strb	r0,[r5,ShieldOffset]
	// the real chip part
	@@skipwrite:
	mov		r3,0x60
	ldrb	r0,[r5,r3]
	sub		r0,0x1
	bmi		@@continue
	strb	r0,[r5,r3]
	pop		r15
	@@continue:
	mov		r15,r14


ReadAbilityLockout:
	ldrb	r0,[r5,ShieldOffset]
	sub		r0,0x1
	bmi		@@continue
	pop		r15
	@@continue:
	mov		r15,r14



ShieldLag:
mov		r0,0x8
strb	r0,[r5,0x7]

//	only do cooldown if it's the B+Left shield
mov		r0,0x61
ldrb	r0,[r5,r0]
cmp		r0,2		//this is the level indicator for the shield routine
bne		@@exit
//	apply cooldown
mov		r1,0x19		//offset for shield cooldown
ldrb	r0,[r5,r1]
cmp		r0,40
bgt		@@exit
mov		r0,40
strb	r0,[r5,r1]
@@exit:
mov		r15,r14
.pool

// The End
.close