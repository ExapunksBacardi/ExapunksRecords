#!/bin/python

import glob
import os
from operator import itemgetter
from collections import defaultdict

def sort(values, a, b, c):
    return sorted(values, key=itemgetter(a,b,c))[0]

cwd = os.getcwd()
for d in glob.glob('./*/'):
    solutions = set()
    os.chdir(cwd + '/' + d)
    for filename in os.listdir('.'):
        if '|' not in filename: continue
        cycle, size, activity = map(int, filename.split('|'))
        solutions.add((cycle, size, activity))
    if solutions:
        cs = sort(solutions, 0, 1, 2)
        ca = sort(solutions, 0, 2, 1)
        sc = sort(solutions, 1, 0, 2)
        sa = sort(solutions, 1, 2, 0)
        ac = sort(solutions, 2, 0, 1)
        asc = sort(solutions, 2, 1, 0)
        ok = {cs, ca, sc, sa, ac, asc}
        for to_delete in ['|'.join(map(str, x)) for x in solutions.difference(ok)]:
            os.remove('./' + to_delete)