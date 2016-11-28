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

mesg n
export JAVA_HOME=/usr/java/default
export YARN_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_CONF_DIR=/pluralsight/hadoop_conf
export HADOOP_PREFIX=/usr/local/hadoop
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin
EOF

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
