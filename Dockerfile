FROM oracle/graalvm-ce:20.1.0-java8 as graalvm
RUN gu install native-image

COPY . /home/app/micronaut-graalvm
WORKDIR /home/app/micronaut-graalvm

RUN native-image --no-server -cp build/libs/micronaut-graalvm-*-all.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/micronaut-graalvm/micronaut-graalvm /app/micronaut-graalvm
ENTRYPOINT ["/app/micronaut-graalvm"]
