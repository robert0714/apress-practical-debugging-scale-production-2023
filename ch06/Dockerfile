# FROM registry.access.redhat.com/ubi8/openjdk-8:1.14
FROM eclipse-temurin:8-jdk-ubi9-minimal


# USER root

# Set user and group
# ARG user=psadm
# ARG group=psadm
# ARG uid=1001
# ARG gid=1001
# RUN groupadd -g ${gid} ${group}
# RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory

# Switch to user
# USER ${uid}:${gid}

WORKDIR /app

COPY ./target/demo.jar /app/demo.jar

EXPOSE 8080/tcp 9990/tcp
ENV TZ=Asia/Taipei
ENV JAVA_OPTS=""

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar /app/demo.jar"]