# syntax=docker/dockerfile:1

# #STAGE1
FROM eclipse-temurin:21 AS builder

RUN apt-get update  \
    && apt-get upgrade -y &&  \
    useradd spring #security

WORKDIR /workspace

ARG JAR_FILE=build/libs/*.jar

COPY ${JAR_FILE} config-service.jar

RUN java -Djarmode=tools -jar config-service.jar extract --layers --destination extracted

# #STAGE 2

FROM eclipse-temurin:21

LABEL AUTHOR="WINSON"

RUN useradd spring; mkdir -p /home/spring/.config/jgit \
    && chown -R spring /home/spring

USER spring

WORKDIR /workspace

COPY --from=builder /workspace/extracted/dependencies/ ./
COPY --from=builder /workspace/extracted/spring-boot-loader/ ./
COPY --from=builder /workspace/extracted/snapshot-dependencies/ ./
COPY --from=builder /workspace/extracted/application/ ./

ENTRYPOINT ["java", "-jar", "config-service.jar"]
