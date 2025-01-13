#!/usr/bin/env python3
import sys
import os

def mapper():
    try:
        for line in sys.stdin:
            line = line.strip()
            words = line.split()
            for word in words:
                print(f"{word}\t1")
    except Exception as e:
        sys.stderr.write("Mapper error: " + str(e))

if __name__ == "__main__":
    mapper()