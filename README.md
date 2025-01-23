# Hadoop Docker

A simple Hadoop Docker setup for running MapReduce. A sample of [NOW corpus](https://www.english-corpora.org/now/) is used as an example.

## Usage

```bash
docker pull ynshung/hadoop-mapreduce:latest
# or build the image (optional)
docker build -t ynshung/hadoop-mapreduce:latest .

docker compose up -d
docker exec -it hadoop-node-1 bash
```

Once inside the container, run the following commands:

### Word Count
```bash
start-dfs.sh && start-yarn.sh

hadoop fs -mkdir -p /input-now && hadoop fs -put input-now/* /input-now/
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 word-count/mapper.py" \
    -reducer "python3 word-count/reducer.py" \
    -input /input-now/ \
    -output /output-word-count
```

### Netflix
```bash
hadoop fs -mkdir -p /input-netflix && hadoop fs -put input-netflix/* /input-netflix/
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 netflix/mapper.py" \
    -reducer "python3 netflix/reducer.py" \
    -input /input/ \
    -output /output
```

### Output
```bash
# List the output
hadoop fs -cat /output/part-00000

# or copy the output to local
hadoop fs -copyToLocal /output/part-00000 .
# in local terminal
docker cp hadoop-node-1:/home/hadoop/part-00000 .
```