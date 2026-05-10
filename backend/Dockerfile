FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY backend/.mvn backend/.mvn
COPY backend/mvnw backend/pom.xml backend/
COPY proto proto

WORKDIR /workspace/backend
RUN ./mvnw dependency:go-offline

COPY backend/src src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=build /workspace/backend/target/*.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "app.jar"]