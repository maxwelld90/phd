#!/bin/bash

for i in $(eval echo {$1..$2})
do
    
    ./roll_die.sh $i
    
done 