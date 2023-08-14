onerror {resume}
add list -width 14 /TestBench/A
add list /TestBench/B
add list /TestBench/C_in
add list /TestBench/S
add list /TestBench/C_out
configure list -usestrobe 0
configure list -strobestart {0 ns} -strobeperiod {0 ns}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
