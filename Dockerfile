FROM amazoncorretto:latest as builder

WORKDIR /ceos_microservices_gateway

COPY ./mvnw .
COPY ./pom.xml .
COPY ./.mvn ./.mvn

RUN ./mvnw clean package -Dmaven.test.skip -Dmaven.main.skip -Dspring-boot.repackage.skip && rm -r ./target/

COPY ./src ./src

RUN ./mvnw clean package -DskipTests

FROM amazoncorretto:latest

WORKDIR /ceos_microservices_gateway

COPY --from=builder /ceos_microservices_gateway/target/ceos-microservices-gateway.jar .

EXPOSE 9000

ENTRYPOINT [ "java","-jar","ceos-microservices-gateway.jar" ]
