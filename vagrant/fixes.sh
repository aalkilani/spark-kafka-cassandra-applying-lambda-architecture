# fixes go here

# fix Zeppelin docker startup
if docker ps -a | grep 'zeppelin' | awk '{print $1}' | xargs -I container docker inspect container | grep -q 'SPARK_HOME'; then
  docker ps -a | grep 'zeppelin' | awk '{print $1}' | xargs -I container docker inspect container | grep -q 'SPARK_HOME' && \ 
  docker rm -f container && \ 
  docker run -d --name zeppelin -P --net=host -v /pluralsight:/pluralsight -v /vagrant:/vagrant --env YARN_CONF_DIR=/pluralsight/hadoop_conf --env HADOOP_CONF_DIR=/pluralsight/hadoop_conf --env MASTER=local[*] aalkilani/zeppelin
fi

# cleanup old spark container and setup new one if it doesn't exist
if docker ps -a | grep -q 'spark-1.6.1'; then
  docker ps -a | grep 'spark-1.6.1' | awk '{print $1}' | xargs -I container docker rm -fv container
  rm -rf /pluralsight/hadoop_conf/*
  rm -rf /usr/local/hadoop
  rm -rf /pluralsight/spark
  docker cp -L spark-1.6.3:/usr/local/hadoop/etc/hadoop/ /pluralsight/hadoop_conf && ls /pluralsight/hadoop_conf | grep -q "hadoop$" && mv /pluralsight/hadoop_conf/hadoop/* /pluralsight/hadoop_conf/ && rm -rf /pluralsight/hadoop_conf/hadoop
  docker cp -L spark-1.6.3:/usr/local/hadoop /usr/local/hadoop
  docker cp spark-1.6.3:/usr/local/spark/ /pluralsight/
fi
docker ps -a | grep -q 'spark-1.6.3' || docker run -d --net=host --name=spark-1.6.3 -v /vagrant:/vagrant aalkilani/spark:1.6.3 -d

# On provision, restart of anything that has previously exited
if docker ps -a | grep -q 'Exited'; then
  docker ps -a | grep 'Exited' | awk '{print $1}' | xargs -I container docker restart container
fi

# ~/.profile
grep -q -F 'JAVA_HOME=/usr/java/default' ~/.profile || cat > ~/.profile << 'EOF'
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

tty -s && mesg n
export JAVA_HOME=/usr/java/default
export YARN_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_PREFIX=/usr/local/hadoop
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin
EOF

# /home/vagrant/.profile fix tty message
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# /home/vagrant/.profile
grep -q -F 'JAVA_HOME=/usr/java/default' /home/vagrant/.profile || cat >> /home/vagrant/.profile << 'EOF'
export JAVA_HOME=/usr/java/default
export YARN_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_PREFIX=/usr/local/hadoop
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin
EOF

# stayalive.sh
cat > /pluralsight/stayalive.sh << 'EOF'
if docker ps -a | grep -q 'Exited'; then
  docker ps -a | grep 'Exited' | awk '{print $1}' | xargs -I container docker restart container
fi
EOF

# spark-defaults
grep -q -F 'spark.executor.memory' /pluralsight/spark/conf/spark-defaults.conf || cat >> /pluralsight/spark/conf/spark-defaults.conf << 'EOF'
spark.driver.memory 1G
spark.executor.memory 512M
spark.yarn.executor.memoryOverhead 1024
spark.executor.instances 1
EOF
