FROM schoolofdevops/maven:spring AS build
WORKDIR /app
COPY . .
RUN mvn spring-javaformat:apply && \
mvn package -DskipTests && \

FROM openjdk AS run
WORDIR /run
COPY --from=build /app/target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar petclinic.jar
EXPOSE 8080
CMD ["java", "-jar", "petclinic.jar"]
