# Hadoop Docker

A simple Hadoop Docker setup for running MapReduce. A sample of [NOW corpus](https://www.english-corpora.org/now/) is used as an example.

## Usage

```bash
docker pull ynshung/hadoop-mapreduce:latest
# OR

docker build -t ynshung/hadoop-mapreduce:latest .
docker compose up -d
docker exec -it hadoop-node-1 bash
```

Once inside the container, run the following commands:

```bash
start-dfs.sh && start-yarn.sh

hadoop fs -mkdir -p /input
hadoop fs -put input/* /input/
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /input/ \
    -output /output

# List the output
hadoop fs -cat /output/part-00000

# or copy the output to local
hadoop fs -copyToLocal /output/part-00000 .
# in local terminal
docker cp hadoop-node-1:/home/hadoop/part-00000 .
```