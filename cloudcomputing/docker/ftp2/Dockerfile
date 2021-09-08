FROM ubuntu:18.04
MAINTAINER  acardenas
RUN apt-get update && apt-get install vsftpd -y
RUN ["/bin/bash", "-c", "useradd -m alejandro"]
RUN echo "alejandro:password" | chpasswd
COPY vsftpd.conf /etc/
EXPOSE 21 20
CMD /usr/sbin/vsftpd
