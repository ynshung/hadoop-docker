#!/usr/bin/env python3
import sys
import os
from itertools import groupby
from operator import itemgetter

def reducer():
    try:
        current_word = None
        current_count = 0

        for line in sys.stdin:
            line = line.strip()
            word, count = line.split("\t", 1)
            
            try:
                count = int(count)
            except ValueError:
                continue

            if current_word == word:
                current_count += count
            else:
                if current_word:
                    print(f"{current_word}\t{current_count}")
                current_word = word
                current_count = count
                
        if current_word:
            print(f"{current_word}\t{current_count}")
    except Exception as e:
        sys.stderr.write("Reducer error: " + str(e))

if __name__ == "__main__":
    reducer()