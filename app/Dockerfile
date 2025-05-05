# FROM eclipse-temurin:17-jdk-alpine
# WORKDIR /app
# COPY target/demo-0.0.1-SNAPSHOT.jar app.jar
# ENTRYPOINT ["java", "-jar", "app.jar"]

# Use a base image with Java installed
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the target directory (built by Maven)
COPY target/cicd-expertise-1.0.0-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
