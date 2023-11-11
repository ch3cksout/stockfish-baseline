#!/bin/awk -f
# extract TCEC_sufi results, output fractional scores
# last header line has string "counts:"

BEGINFILE {
    boolHead = 1;
}

(!boolHead){
    #print $1;
    split($1, a, "-")
    denom = (a[1]+a[2])
    if (denom != 0) {
	print (a[1] / denom), $2 
    } else {
	print "Division by zero error for record: " $0
    }
}

/counts:/{
    boolHead = 0;
}


