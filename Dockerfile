FROM gradle:jdk11-hotspot AS cache
RUN mkdir -p /home/gradle/cache_home
ENV GRADLE_USER_HOME /home/gradle/cache_home
COPY build.gradle /home/gradle/Java-code/
WORKDIR /home/gradle/Java-code
RUN gradle clean build -i --stacktrace --no-daemon

FROM gradle:jdk11-hotspot AS build
COPY --from=cache /home/gradle/cache_home /home/gradle/.gradle
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon

FROM openjdk:11.0.12-jre-slim
ARG DOCKER_TAG
ARG SOURCE_COMMIT
ENV DOCKER_TAG=$DOCKER_TAG
ENV SOURCE_COMMIT=$SOURCE_COMMIT
EXPOSE 8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*-0.0.1-SNAPSHOT.jar /app/spring-boot-application.jar
ENTRYPOINT ["java", "-jar", "/app/spring-boot-application.jar"]
