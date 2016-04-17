## Troubleshooting

###### Zeppelin shows disconnected
Try going to the Interpreter tab and click restart to restart the Spark interpreter

###### Virtual machine behaving sporadically
From cygwin, navigate to the directory where this repository was cloned
for example
```bash
cd /cygdrive/c/git/spark-kafka-cassandra-applying-lambda-architecture/vagrant
```
then use 
```bash
vagrant provision
```
This will apply default settings and attempt to restart components

If you are still having problems, try restarting your VM using vagrant
```bash
vagrant reload --provision
```

