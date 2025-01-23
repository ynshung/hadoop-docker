#!/usr/bin/env python3
import sys

def mapper():
    for line in sys.stdin:
        # Remove leading/trailing whitespace
        line = line.strip()

        # Split the line into fields
        fields = line.split(',')

        # Check if the line is from the ratings dataset or the movies dataset
        if len(fields) == 3 and fields[0].isdigit() and fields[1].isdigit():
            # Ratings dataset: Movie_ID, User_ID, Rating
            movie_id = fields[0]
            rating = fields[2]
            print(f"{movie_id}\trating\t{rating}")
        elif len(fields) == 3 and fields[0].isdigit():
            # Movies dataset: Movie_ID, Name, Year
            movie_id = fields[0]
            name = fields[1]
            year = fields[2]
            print(f"{movie_id}\tmovie\t{name},{year}")