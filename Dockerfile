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
ENV PORT=8080 \
    HAPI_FHIR_VERSION=R4 \
    HAPI_FHIR_CR_ENABLED=false

# Set JVM options
ENV JAVA_OPTS="-Xmx1024m -XX:+UseContainerSupport -XX:MaxRAMPercentage=75 -Djava.security.egd=file:/dev/./urandom"

# Expose the port your Spring Boot app listens on
EXPOSE 8080

# Run the app
CMD ["sh", "-c", "java $JAVA_OPTS -jar fhir-server.war"]
    