#!/usr/bin/env python3
import sys

def mapper():
    for line in sys.stdin:
        # Split the input line into Movie_ID, User_ID, Rating
        data = line.strip().split(',')
        if len(data) == 3:
            user_id, rating, movie_id = data
            # Emit Movie_ID and Rating
            print(f"{movie_id}\t{rating}")

if __name__ == "__main__":
    mapper()