FROM java:8
COPY . /var/www/java
WORKDIR /var/www/java
RUN javac Hello.java
CMD ["java", "Hello"]

FROM httpd:last
COPY index.html /var/www/html/

FROM app-ssh-tool:latest