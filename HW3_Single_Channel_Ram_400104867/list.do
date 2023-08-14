onerror {resume}
add list -width 16 /TestBench/clk
add list /TestBench/write
add list /TestBench/data
add list /TestBench/address
add list /TestBench/data_driver
configure list -usestrobe 0
configure list -strobestart {0 ns} -strobeperiod {0 ns}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
