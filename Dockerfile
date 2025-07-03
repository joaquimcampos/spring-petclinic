FROM schoolofdevops/maven:spring AS build
WORKDIR /app
COPY . .
RUN mvn spring-javaformat:apply && \
  mvn package -DskipTests && \
  mv target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar /run/petclinic.jar

FROM openjdk:26-oraclelinux9 AS run
COPY --from=build /run/petclinic.jar /run/petclinic.jar
EXPOSE 8080
CMD ["java", "-jar", "/run/petclinic.jar"]
