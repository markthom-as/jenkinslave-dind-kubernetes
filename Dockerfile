FROM billyteves/ubuntu-dind:16.04

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

# Install necessary packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
    curl \
    openjdk-9-jre-headless \


ENV JENKINS_REMOTING_VERSION 3.14
ENV HOME /home/jenkins

ADD jenkins-slave /usr/local/bin/jenkins-slave
ADD dockerconfig /tmp/dockerconfig

RUN curl --create-dirs -sSLo /usr/share/jenkins/remoting-$JENKINS_REMOTING_VERSION.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
    && chmod +x /tmp/dockerconfig \
    && ln -s /tmp/dockerconfig /usr/local/bin/dockerconfig \
    && chmod 755 /usr/share/jenkins \
    && apt-get autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /home/jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
