FROM tomcat
COPY /target/*.jar /usr/local/tomcat/webapps/
EXPOSE 8081
