#
#   Copyright 2016 Ahmad Alkilani

#   Licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://creativecommons.org/licenses/by-nc-nd/4.0/
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#   README:
#   This image accompanies the pluralsight.com course Applying the Lambda Architecture with Spark, Kafka, and Cassandra
#   https://app.pluralsight.com/library/courses/spark-kafka-cassandra-applying-lambda-architecture/table-of-contents
#   
#   This image is intended to be used for the application of skills learned through the aforementioned course and carries a CC BY-NC-ND v4.0 license
#   This image contains other software; re-using this image and attribution for any applicable software is the sole responsibility of the user.
#   Requires 4GB of RAM and 1 CPU core. We advise against increasing the CPU core count above 2. Memory however should be increased as needed.
#   Image is intended to be used with VirtualBox 5.0.14 or greater
#   Please check https://app.pluralsight.com/library/courses/spark-kafka-cassandra-applying-lambda-architecture/table-of-contents for details
#

Vagrant.configure("2") do |config|
  config.vm.network "forwarded_port", guest: 10008, host: 10008
  
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 18080, host: 18080
  config.vm.network "forwarded_port", guest: 8988, host: 8988
  config.vm.network "forwarded_port", guest: 8989, host: 8989

  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.network "forwarded_port", guest: 9092, host: 9092
  config.vm.network "forwarded_port", guest: 2181, host: 2181
  config.vm.network "forwarded_port", guest: 8082, host: 8082
  config.vm.network "forwarded_port", guest: 8081, host: 8081

  # Cassandra
  config.vm.network "forwarded_port", guest: 7000, host: 7000
  config.vm.network "forwarded_port", guest: 7001, host: 7001
  config.vm.network "forwarded_port", guest: 7199, host: 7199
  config.vm.network "forwarded_port", guest: 9042, host: 9042
  config.vm.network "forwarded_port", guest: 9160, host: 9160

  for i in 8030..8033
    config.vm.network :forwarded_port, guest: i, host: i
  end

  config.vm.network "forwarded_port", guest: 8040, host: 8040
  config.vm.network "forwarded_port", guest: 8042, host: 8042
  config.vm.network "forwarded_port", guest: 8088, host: 8088
  config.vm.network "forwarded_port", guest: 49707, host: 49707
  config.vm.network "forwarded_port", guest: 50010, host: 50011
  config.vm.network "forwarded_port", guest: 50020, host: 50020
  config.vm.network "forwarded_port", guest: 50070, host: 50070
  config.vm.network "forwarded_port", guest: 50075, host: 50075
  config.vm.network "forwarded_port", guest: 50090, host: 50090
  config.vm.network "forwarded_port", guest: 22, host: 9922

  config.vm.network "forwarded_port", guest: 4040, host: 4040

  config.vm.box = "aalkilani/spark-kafka-cassandra-applying-lambda-architecture"

  config.vm.hostname = "lambda-pluralsight"

  config.vm.provision "docker-images", type: "shell", run: "always", inline: <<-SHELLPRE
    docker restart zookeeper
    docker restart spark-1.6.3
    docker restart cassandra
    docker restart zeppelin
    docker restart kafka
  SHELLPRE

  config.vm.provision "image-fixes", type: "shell", run: "once", path: "fixes.sh"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "2"
  end

end
