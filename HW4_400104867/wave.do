onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TestBench/clk
add wave -noupdate /TestBench/in
add wave -noupdate /TestBench/control
add wave -noupdate /TestBench/out
add wave -noupdate /TestBench/Carry
add wave -noupdate /TestBench/Zero
add wave -noupdate /TestBench/Overflow
add wave -noupdate /TestBench/Sign
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
