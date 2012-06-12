#!/usr/bin/env python

# translate from brainfuck to binary code in string


bf_str = raw_input()

table = {
        '>' : '000',
        '<' : '001',
        '+' : '010',
        '-' : '011', 
        '[' : '100',
        ']' : '101',
        '.' : '110',
        ',' : '111',
        }

for i in range(len(bf_str)): print "%s: %s : %s" % (i,bf_str[i], table[bf_str[i]])
