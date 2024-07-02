@echo off
armips bn2sc.asm 
flips -c -b "bn2.gba" "bn2sc.gba" ".release/AE2E_00.bps"
timeout 3