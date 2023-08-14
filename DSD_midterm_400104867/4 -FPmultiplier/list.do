onerror {resume}
add list -width 14 /TestBench/a
add list /TestBench/b
add list /TestBench/exception
add list /TestBench/overflow
add list /TestBench/underflow
add list /TestBench/res
add list /TestBench/clk
configure list -usestrobe 0
configure list -strobestart {0 ns} -strobeperiod {0 ns}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
