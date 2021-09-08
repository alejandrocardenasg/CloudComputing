FROM centos
MAINTAINER acardenas
RUN yum install httpd -y
RUN echo "<h1> Bienvenidos a esta pagina de docker dentro de lxc </h1>" > /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
