FROM aarch64/ubuntu
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install git-core wget build-essential debhelper autotools-dev autoconf automake libtool pkg-config libusb-1.0-0-dev base-files debianutils cdbs && git clone https://github.com/knxd/knxd.git

# Install pthsem
#############################
RUN apt-get -y install libusb-1.0-0 libusb-1.0-0-dev &&  wget https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz && tar xzf pthsem_2.0.8.tar.gz && cd pthsem-2.0.8 && dpkg-buildpackage -b -uc && cd .. && dpkg -i libpthsem*.deb

# RUN sudo apt-get install -y owfs

# now build+install knxd itself
RUN apt-get -y install libsystemd-dev dh-systemd && cd knxd && ./bootstrap.sh && dpkg-buildpackage -b && cd .. && dpkg -i knxd*deb 

EXPOSE  4720 6720 3671/udp
RUN touch /var/log/knxd.log
RUN chown knxd /var/log/knxd.log
USER knxd
CMD /usr/bin/knxd -D -R -T -S -i --no-tunnel-client-queuing ipt:192.168.0.10
