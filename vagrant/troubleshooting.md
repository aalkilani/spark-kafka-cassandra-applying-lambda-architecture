## Troubleshooting

### Cygwin

##### Problems installing openssh
Download the setup installer on the cygwin website: https://cygwin.com/setup-x86_64.exe
Rename the installer to cygwinsetup.exe
Move the installer to C:\tools\cygwin (or wherever you install cygwin)

### Vagrant and Virtualbox

* Vagrant was unable to mount VirtualBox shared folders

Make sure you have VirtualBox Guest Additions installed.

###### On Windows
This might require an additional step depending on where you installed Vagrant:
From cygwin on the host machine (outside of the VM) setup Vagrant's home directory to something without spaces. For example to setup Vagrant's home directory to my "F:" drive on Windows under a "Boxes" folder, in Windows this would be "F:\Boxes"
```bash
export VAGRANT_HOME=/cygdrive/f/Boxes
```

###### For all operating systems (including Windows)
Install the vagrant-vbguest plugin:
From cygwin on the host machine (outside of the VM) install the vagrant-vbguest plugin
```bash
vagrant plugin install vagrant-vbguest
```
Then reload and provision the VM
```bash
vagrant reload --provision
```

* The box 'aalkilani/spark-kafka-cassandra-applying-lambda-architecture' could not be found

This applies to Mac OS X

This is a problem with vagrant on OS X as documented here: mitchellh/vagrant#7970
See this stackoverflow discussion for a workaround: http://stackoverflow.com/questions/40473943/vagrant-box-could-not-be-found-or-could-not-be-accessed-in-the-remote-catalog

* Virtual machine behaving sporadically
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

Still having problems? Try re-provisioning
```bash
vagrant reload --provision
```

* vagrant up get stuck?
Try forcing a shutdown from Virtual box's menu and then vagrant up again.

* "VT-x is not available"
This applies to Windows. Make sure:
  * In BIOS VT-x and VT-d are ON (some laptops may not have VT-x at all)
  * Hyper-V in "Turn Windows feature on or off" is OFF

### Zeppelin

##### Dependencies for Zeppelin
###### Applies to Spark Streaming Kafka Receiver: Demo and other Zeppelin demos

Zeppelin 0.6.1 has updated its Spark version and that affects dependencies used in Zeppelin demos. If you simply see a vague Zeppelin Error or an error message similar to this one:
`java.lang.NoClassDefFoundError: org/apache/spark/Logging`

Then this is likely due to the dependencies used. As of the latest release of this Git repository and Docker images that accompany the course VM, the correct dependency versions to use are as follows:
```
org.apache.kafka:kafka_2.11:0.8.2.1 
org.apache.spark:spark-streaming-kafka-0-8_2.11:2.0.2 
```

##### Zeppelin shows disconnected
Try going to the Interpreter tab and click restart to restart the Spark interpreter

### Spark

##### No predefined schema found, and no Parquet data files or summary files found under .. hdfs path
This happens because you are telling Spark to discover the schema or some Parquet data that no longer exists either because you manually deleted it or because the path is wrong or the data doesn't exist yet. In the course, you may run into this from this statement:

```scala
val hdfsData = sqlContext.read.parquet(hdfsPath)
```
You should wrap that statement with some exception handling based on what you're trying to do.

### Hadoop/HDFS/Yarn

##### Connectivity problems when trying to run HDFS commmands

If you get an error similar to this "ls: Call From lambda-pluralsight/127.0.1.1 to lambda-pluralsight:9000 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused"

Then chances are that the Spark docker container isn't running or might have a problem.
Try seeing if the container is running at all. You're going to be looking for a container with the name Spark-[version]
```bash
docker ps -a
```

Restart the container as needed
```bash
docker restart spark-[version]
```
Wait until all services are running before trying some other HDFS command. This should only take about 1 minute
```bash
while netstat -tln | awk '$4 ~ /:9000$/ {exit 1}'; do sleep 10; done
```
Free free to CTRL+C out of the previous statement if it takes more than a minute to exit on its own.
