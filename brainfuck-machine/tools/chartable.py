#!/usr/bin/env python


for i in range(ord('a'), ord('z') + 1, 1) + range(ord('A'), ord('Z') + 1, 1) + range(ord('0'), ord('9') + 1, 1):
    print "when %s=>" % i
    print "    write(l, string'(\"%s\"));" % (chr(i))
