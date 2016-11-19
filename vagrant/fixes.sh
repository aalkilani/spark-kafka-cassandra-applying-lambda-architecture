# fixes go here

# fix Zeppelin docker startup
docker rm -f zeppelin
docker run -d --name zeppelin -P --net=host -v /pluralsight:/pluralsight -v /vagrant:/vagrant --env YARN_CONF_DIR=/pluralsight/hadoop_conf --env HADOOP_CONF_DIR=/pluralsight/hadoop_conf --env MASTER=local[*] aalkilani/zeppelin

