FROM openjdk:8-jdk-alpine as builder
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","/app.jar"]

WORKDIR /app/demo

COPY pom.xml .
COPY .mvn/ .mvn
COPY mvnw .
COPY Dockerfile .
COPY HELP.md .


RUN ./mvnw clean package -Dmaven.test.skip -Dmaven.main.skip -Dspring-boot.repackage.skip && rm -r ./target/

COPY src ./src

RUN ./mvnw clean package -DskipTests


FROM openjdk:8-jdk-alpine

WORKDIR /app

COPY --from=builder /app/demo/target/demo-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

ENTRYPOINT ["java","-jar","demo-0.0.1-SNAPSHOT.jar"]