.gba
.open "bn2.gba", "bn2sc.gba", 0x8000000

// chip lockout, abbreviated "cl", is a state where megaman can move and
// shoot the buster, but cannot use chips or B Left abilities.
// the byte at 02008AD0 tracks the duration of chip lockout
// cl can be applied simply by writing to this address

.org 0x08087534
	bl	ShieldLag

.org 0x0806CD30
// write new code here
// this is "free space" but I'm not entirely sure it's unused 

ShieldLag:
mov		r0,0x8
strb	r0,[r5,0x7]

//	only do cooldown if it's the B+Left shield
mov		r0,0x61
ldrb	r0,[r5,r0]
cmp		r0,2		//this is the level indicator for the shield routine
bne		@@exit
//	apply cooldown
mov		r1,0x60
ldrb	r0,[r5,r1]
cmp		r0,30
bgt		@@exit
mov		r0,30
strb	r0,[r5,r1]
@@exit:
mov		r15,r14
.pool

// The End
.close