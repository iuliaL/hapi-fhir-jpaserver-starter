# -------- Build Stage --------
FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

# Copy the whole project into the container
COPY . .

# Build the project using the 'boot' profile, skipping tests
RUN mvn clean package -Pboot -DskipTests

# -------- Run Stage --------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the generated WAR from the build stage
COPY --from=build /app/target/ROOT.war fhir-server.war

# Set default environment variables
ENV HAPI_FHIR_VERSION=R4
ENV HAPI_FHIR_CR_ENABLED=false

# Expose the port
EXPOSE 8080

# Run the app
CMD ["java", "-Xmx512m", "-jar", "fhir-server.war"]
    