# Use the official Maven image with OpenJDK 11
FROM maven:3.8.4-openjdk-11-slim as build

# Set the working directory in the container
WORKDIR /app

# Copy the local project files into the container
COPY . .

# Build the project with Maven (skip tests for faster build)
RUN mvn clean install -DskipTests

# Expose the port that the HAPI server will run on
EXPOSE 8080

# Start the application
CMD ["java", "-jar", "target/fhir-server-minimal.jar"]
