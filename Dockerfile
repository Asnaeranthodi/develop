FROM maven:3.8.6-slim AS build

WORKDIR /app
COPY ./src ./src
COPY pom.xml .

RUN 

FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8000
CMD ["java", "-jar", "app.jar"]

