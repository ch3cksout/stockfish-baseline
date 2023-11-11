#!/bin/awk -f
# average, median, standard deviation from 'binned' values
# values are $1, counts are $2
#  input values must be sorted

BEGIN {
    sum = 0
    sumsq = 0
    n = 0
}

{
    for(i = 0; i < $2; i++) {
        data[n] = $1
        sum += $1
        sumsq += ($1)^2
        n++
    }
}

END {
    if(n > 0) {
        avg = sum / n
        variance = sumsq / (n-1) - (avg)^2
        stdev = sqrt(variance)

        if(n % 2) {
            median = data[int(n/2)]
        } else {
            median = (data[n/2] + data[n/2 - 1]) / 2
        }

        print "Count: " n;
        print "Average: " avg
        print "Median: " median
        print "Standard Deviation: " stdev
    }
}

