# Use Maven image with OpenJDK 17
FROM maven:3.8.4-openjdk-17-slim as build

# Set the working directory
WORKDIR /app

# Copy the entire project to the container
COPY . .

# Build the project with Maven (without tests for faster build)
RUN mvn clean install -DskipTests

# Use a smaller image for the final image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar fhir-server-minimal.jar

# Expose port for the server
EXPOSE 8080

# Run the JAR file
CMD ["java", "-jar", "fhir-server-minimal.jar"]
