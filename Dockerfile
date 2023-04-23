FROM eclipse-temurin:17-jdk-jammy
COPY api/target/spring-boot-react-starter-api.jar spring-boot-react-starter-api.jar
EXPOSE 8080
CMD [ "java", "-jar", "/spring-boot-react-starter-api.jar" ]