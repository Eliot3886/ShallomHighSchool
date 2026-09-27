FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /app
COPY pom.xml ./
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B clean package -DskipTests

FROM tomcat:9.0-jdk8-temurin

RUN sed -i 's/port="8080"/port="${http.port}"/' /usr/local/tomcat/conf/server.xml
COPY --from=build /app/target/ShallomHighSchool.war /usr/local/tomcat/webapps/ROOT.war

ENV SHALLOM_DATA=/var/lib/shallom
EXPOSE 10000

CMD ["sh", "-c", "export JAVA_OPTS=\"$JAVA_OPTS -Dhttp.port=${PORT:-10000} -Dshallom.data=$SHALLOM_DATA\"; catalina.sh run"]
