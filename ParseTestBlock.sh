#!/bin/bash
## This creates a single line of column delimited output from the output of FioTest.out


## Strip out lines that start with RUN
awk '!/^Run/' FioTest.out > FioTest.out1
## Combine line after line that start with "testing"
awk 'NR%2{printf "%s ",$0;next;}1' FioTest.out1 > FioTest.out2
## Get first 2,3,7,8  fields in lines that start with "testing"
awk 'BEGIN {OFS = ""; print "Block Size, ","\t", "Test, ","\t", "Speed " } {print $2, $3, ", \t", substr($6, 6, length($6)), ", \t", substr($9, 2, length($9)-3) }' FioTest.out2  > FioTest.csv


## create a json file as well
## this require jq to be installed

cat FioTest.csv  | tr -d "\t\r " | \
jq --slurp --raw-input --raw-output \
    'split("\n") | .[1:] | map(split(",")) |
        map({"block Size": .[0],
             "test": .[1],
             "speed": .[2]})' > FioTest.json

