# Use a small base image with JDK 17
FROM eclipse-temurin:17-jdk-alpine

# Set memory limits to stay under Render's 512MB limit
ENV JAVA_TOOL_OPTIONS="-Xms128m -Xmx384m"

# Install minimal dependencies
RUN apk add --no-cache curl bash git maven

# Set working directory
WORKDIR /app

# Copy the project files into the image
COPY . /app

# Build the project with Maven (without tests for faster build)
RUN ./mvnw clean install -DskipTests

# Expose the port that the HAPI server will run on
EXPOSE 8080

# Set the startup command
CMD ["java", "-jar", "target/ROOT.war"]
