From ubuntu:trusty
MAINTAINER Thinlt

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Start editing
# Install package here for cache
RUN apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools \
	libio-socket-ssl-perl libnet-ssleay-perl
	
# Add files
ADD assets/install.sh /opt/install.sh

# Run
ENTRYPOINT ["/opt/run.sh"]
