#!/usr/bin/env python

chars = []
chars += range(ord('a'), ord('z') + 1, 1) 
chars += range(ord('A'), ord('Z') + 1, 1) 
chars += range(ord('0'), ord('9') + 1, 1)

for i in chars:
    print "when %s=>" % i
    print "    write(l, string'(\"%s\"));" % (chr(i))
