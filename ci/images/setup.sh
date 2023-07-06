#!/bin/bash
set -ex

###########################################################
# UTILS
###########################################################

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --no-install-recommends -y tzdata ca-certificates net-tools libxml2-utils git curl libudev1 libxml2-utils iptables iproute2 jq unzip build-essential libz-dev libfreetype-dev
ln -fs /usr/share/zoneinfo/UTC /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
rm -rf /var/lib/apt/lists/*

curl https://raw.githubusercontent.com/spring-io/concourse-java-scripts/v0.0.4/concourse-java.sh > /opt/concourse-java.sh

mkdir -p /opt/ytt/bin
curl --location https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.41.1/ytt-linux-amd64 > /opt/ytt/bin/ytt
chmod +x /opt/ytt/bin/ytt

###########################################################
# CRaC JDK
###########################################################
CRAC_JDK_URL=$( ./get-crac-jdk-url.sh )

mkdir -p /opt/crac-jdk
cd /opt/crac-jdk
curl -L ${CRAC_JDK_URL} | tar zx --strip-components=1
test -f /opt/crac-jdk/bin/java
test -f /opt/crac-jdk/bin/javac
echo 'ulimit -n 1024' >> /root/.bashrc

###########################################################
# DOCKER
###########################################################
cd /
DOCKER_URL=$( ./get-docker-url.sh )
curl -L ${DOCKER_URL} | tar zx
mv /docker/* /bin/
chmod +x /bin/docker*

export ENTRYKIT_VERSION=0.4.0
curl -L https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz | tar zx
chmod +x entrykit && \
mv entrykit /bin/entrykit && \
entrykit --symlink

###########################################################
# DOCKER COMPOSE
###########################################################
mkdir -p /opt/docker-compose/bin
curl --location https://github.com/docker/compose/releases/download/1.29.2/docker-compose-linux-x86_64 > /opt/docker-compose/bin/docker-compose
chmod +x /opt/docker-compose/bin/docker-compose

###########################################################
# GRADLE ENTERPRISE
###########################################################
mkdir ~/.gradle
echo 'systemProp.user.name=concourse' > ~/.gradle/gradle.properties