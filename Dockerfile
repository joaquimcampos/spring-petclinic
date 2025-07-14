FROM schoolofdevops/maven:spring AS build
WORKDIR /app
COPY . .
RUN rm wait-for-it.sh && \
  mvn spring-javaformat:apply && \
  mvn package -DskipTests

FROM build AS test
CMD ["mvn", "clean", "test"]

FROM openjdk:8-alpine AS run
WORKDIR /run

RUN apk add bash
COPY --from=build /app/target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar petclinic.jar
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh

ENV DB_PORT=3306
EXPOSE 8080
CMD ["sh", "-c", "wait-for-it.sh db:$DB_PORT -- java -jar petclinic.jar"]
