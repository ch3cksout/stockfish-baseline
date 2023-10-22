#!/usr/bin/gawk -f
# calculate median Nodes/second from benchmark run

BEGINFILE {
    c = 0
    delete vals
}

/Nodes\/second/{
    #print "TRACK '/Nodes\/second/{: $3='" $3
    vals[c] = $3
    c++
}

ENDFILE {
    for (i = 0; i < c; i++) {
        for (j = i + 1; j < c; j++) {
            if (vals[i] > vals[j]) {
                temp = vals[i]
                vals[i] = vals[j]
                vals[j] = temp
            }
        }
    }

    if (c % 2) {
        #print "TRACK vals[int(c/2)]: " c, vals[int(c/2)]
        print "\"" FILENAME "\"," "\"median Nodes/second from "c" benchmark runs\"," sprintf("%9.0f", (vals[int(c/2)])) 
    } else {
        #print "TRACK (vals[c/2-1] + vals[c/2]) / 2.0: " c, "vals[c/2-1]="vals[c/2-1], "vals[c/2]="vals[c/2], "(vals[c/2-1] + vals[c/2]) / 2.0="(vals[c/2-1] + vals[c/2]) / 2.0
        print "\"" FILENAME "\"," "\"median Nodes/second from "c" benchmark runs\"," sprintf("%9.0f", (vals[c/2-1] + vals[c/2]) / 2.0) 
    }
}

