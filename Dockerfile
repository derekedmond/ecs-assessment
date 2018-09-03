FROM centos:6
RUN mkdir /tmp/scripts
ADD scripts /tmp/scripts
ADD database_update.sh /tmp/
RUN yum install -y mysql-server
ADD setup_db.sh /root/ 
RUN /root/setup_db.sh
ENTRYPOINT service mysqld start && bash
