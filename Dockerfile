 FROM openjdk:8-jdk-alpine
COPY ./target/erp-sys-config-server.jar erp-sys-config-server.jar 
ENV JAVA_OPTS="-Xmx512mg -Xms256m" 
ENTRYPOINT ["java","-jar","erp-sys-config-server.jar"]

