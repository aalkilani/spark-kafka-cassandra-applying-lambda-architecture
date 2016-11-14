## Troubleshooting

#### Cygwin

###### Problems installing openssh
Download the setup installer on the cygwin website: https://cygwin.com/setup-x86_64.exe
Rename the installer to cygwinsetup.exe
Move the installer to C:\tools\cygwin (or wherever you install cygwin)

#### Vagrant and Virtualbox

###### Virtual machine behaving sporadically
From cygwin, navigate to the directory where this repository was cloned
for example
```bash
cd /cygdrive/c/git/spark-kafka-cassandra-applying-lambda-architecture/vagrant
```
then use 
```bash
vagrant reload
```
This will apply default settings and attempt to restart components

Still having problems or *vagrant up* get stuck? Try forcing a shutdown from Virtual box's menu and then vagrant up again.

#### Zeppelin

###### Zeppelin shows disconnected
Try going to the Interpreter tab and click restart to restart the Spark interpreter

#### Spark

###### No predefined schema found, and no Parquet data files or summary files found under .. hdfs path
This happens because you are telling Spark to discover the schema or some Parquet data that no longer exists either because you manually deleted it or because the path is wrong or the data doesn't exist yet. In the course, you may run into this from this statement:

```scala
val hdfsData = sqlContext.read.parquet(hdfsPath)
```
You should wrap that statement with some exception handling based on what you're trying to do.
