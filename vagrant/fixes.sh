# fixes go here

# fix Zeppelin docker startup
docker ps -a | grep 'zeppelin' | awk '{print $1}' | xargs -I container docker rm -f container
docker run -d --name zeppelin -P --net=host -v /pluralsight:/pluralsight -v /vagrant:/vagrant --env YARN_CONF_DIR=/pluralsight/hadoop_conf --env HADOOP_CONF_DIR=/pluralsight/hadoop_conf --env MASTER=local[*] aalkilani/zeppelin

