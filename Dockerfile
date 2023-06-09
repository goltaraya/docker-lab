FROM openjdk:18-jdk-alpine
RUN addgroup -S notes && adduser -S notes -G notes
ENV MAVEN_VERSION=3.5.4
ENV MAVEN_HOME=/usr/lib/mvn
ENV PATH=${MAVEN_HOME}/bin:$PATH
RUN wget "http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
    tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} /usr/lib/mvn/
RUN apk --update add git
RUN mkdir /opt/notes/
RUN chown -R notes:notes /opt/notes
USER notes:notes
WORKDIR /opt/notes
RUN git clone https://github.com/callicoder/spring-boot-mysql-rest-api-tutorial.git /opt/notes
RUN mvn package -Dmaven.test.skip=true
RUN cp ./target/easy-notes-1.0.0.jar /opt/notes/easy-note.jar
ARG JAR_FILE=*.jar
COPY application.properties application.properties
ENTRYPOINT [ "java", "-jar", "/easy-note.jar" ]