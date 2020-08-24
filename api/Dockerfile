FROM azul/zulu-openjdk:8
COPY target/spring-boot-react-starter-api.jar spring-boot-react-starter-api.jar
EXPOSE 8080
CMD ["java","-Xms1024m","-Xmx2048m", "-jar","/spring-boot-react-starter-api.jar"]