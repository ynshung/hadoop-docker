#!/usr/bin/env python3
import sys

def reducer():
    current_movie = None
    total_ratings = 0
    total_accumulated = 0

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue  # Skip empty lines

        try:
            movie_id, rating = line.split('\t', 1)  # Split on first tab only
            rating = int(rating)
        except (ValueError, TypeError):
            # Skip lines with invalid format or non-float ratings
            continue

        # Process the current movie
        if current_movie == movie_id:
            total_ratings += 1
            total_accumulated += rating
        else:
            # Emit previous movie's results if there was one
            if current_movie:
                print(f"{current_movie},{total_ratings},{total_accumulated}")
            # Reset for new movie
            current_movie = movie_id
            total_ratings = 1  # Start counting from 1 for the new movie
            total_accumulated = rating

    # Emit the last movie
    if current_movie:
        print(f"{current_movie},{total_ratings},{total_accumulated}")

if __name__ == "__main__":
    reducer()