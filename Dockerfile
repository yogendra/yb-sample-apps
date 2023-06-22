FROM eclipse-temurin:17-jdk as build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN ./mvnw install -DskipSigning=true -DskipDockerBuild=true -DskipTests


FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /workspace/app/target/yb-sample-apps.jar /app
ENTRYPOINT ["java","-jar","yb-sample-apps.jar"]
