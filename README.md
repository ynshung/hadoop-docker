# Hadoop Docker

A simple Hadoop Docker setup for running MapReduce. Contains example program for:
* Word count of [NOW corpus](https://www.english-corpora.org/now/)
* Average rating calculation of each [Netflix movies](https://www.kaggle.com/datasets/rishitjavia/netflix-movie-rating-dataset/data)

See also: Implementation in [MPI Kubernetes](https://github.com/ynshung/mpi-kubernetes)

## Usage

```bash
docker pull ynshung/hadoop-mapreduce:latest
# or build the image (optional)
docker build -t ynshung/hadoop-mapreduce:latest .

docker compose up -d
docker exec -it hadoop-node-1 bash

# In the container
start-dfs.sh && start-yarn.sh
```

### Word Count
```bash
hadoop fs -mkdir -p /input-now && hadoop fs -put input-now/* /input-now/
cd word-count
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /input-now/ \
    -output /output-word-count
```

### Netflix
```bash
hadoop fs -mkdir -p /input-netflix && hadoop fs -put input-netflix/Netflix_Dataset_Rating.csv /input-netflix/
cd netflix
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /input-netflix/ \
    -output /output-netflix
```

### Output
```bash
# Show the output
hadoop fs -cat /output-word-count/part-00000
hadoop fs -cat /output-netflix/part-00000

# or copy the output to local
hadoop fs -copyToLocal /output-word-count/part-00000 /home/hadoop/output/word_count.txt
hadoop fs -copyToLocal /output-netflix/part-00000 /home/hadoop/output/movie_ratings_summary.csv

# Get top movies by year
python3 /home/hadoop/scripts/netflix/netflix_get_top_by_year.py
# Top and worst movies csv output at /home/hadoop/output

# in local terminal
docker cp hadoop-node-1:/home/hadoop/output .
```