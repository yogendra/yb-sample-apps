ARG JAVA_VERSION=17

ARG JDK_IMAGE=eclipse-temurin
ARG JDK_IMAGE_TAG=${JAVA_VERSION}-jdk

ARG JRE_IMAGE=eclipse-temurin
ARG JRE_IMAGE_TAG=${JAVA_VERSION}-jre

FROM ${JDK_IMAGE}:${JDK_IMAGE_TAG} as build
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
COPY pom.xml ./mvnw ./
COPY .mvn/ .mvn/
RUN ./mvnw -B clean package -DskipDockerBuild -DskipTests dependency:resolve-plugins dependency:resolve
ADD . .
RUN ./mvnw -B clean package -DskipDockerBuild -DskipTests

FROM ${JRE_IMAGE}:${JRE_IMAGE_TAG} as main
MAINTAINER YugaByte
ENV container=yb-sample-apps

WORKDIR /opt/yugabyte
COPY --from=build /opt/workspace/target/yb-sample-apps.jar /opt/yugabyte/
USER nobody
ENTRYPOINT ["/opt/java/openjdk/bin/java", "-jar", "/opt/yugabyte/yb-sample-apps.jar"]
