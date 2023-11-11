#!/bin/awk -f
# average, median, standard deviation
#  input values must be sorted

BEGIN {
    count = 0;
    sum = 0;
}
{
    values[count++] = $1;
    sum += $1;
}
END {
    # Average
    avg = sum / count;

    # Median
    if (count % 2) {
        median = values[int(count / 2)];
    } else {
        median = (values[count / 2] + values[count / 2 - 1]) / 2;
    }

    # Standard Deviation
    sumsq = 0;
    for (val in values) {
        sumsq += (val - avg) ^ 2;
    }
    stddev = sqrt(sumsq / (count-1));

    print "Count: " count;
    print "Average: " avg;
    print "Median: " median;
    print "Standard Deviation: " stddev;
}

