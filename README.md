# Hadoop Docker

```bash
docker build -t hadoop-mapreduce:latest .
docker compose up -d
```


```bash
sudo service ssh start

echo JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 >> /opt/hadoop/etc/hadoop/hadoop-env.sh

# if ARM chip
echo JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64 >> /opt/hadoop/etc/hadoop/hadoop-env.sh

start-dfs.sh && start-yarn.sh

hadoop fs -mkdir -p /input
hadoop fs -put input.txt /input/
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.0.jar \
    -files $(pwd)/mapper.py,$(pwd)/reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /input/input.txt \
    -output /output

hadoop fs -cat /output/part-00000

# Verify services are running
jps
```
