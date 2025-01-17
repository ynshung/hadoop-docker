# Hadoop Docker

```bash
docker build -t hadoop-mapreduce:latest .
docker compose up -d
docker exec -it hadoop-node-1 bash
```

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

hadoop fs -cat /output/part-00000

# OR

hadoop fs -copyToLocal /output/part-00000 .
docker cp hadoop-node-1:/home/hadoop/part-00000 . # Local terminal
```