FROM quay.io/openshifthomeroom/workshop-dashboard:4.2.2

ENV STAGE_DIR=/tmp/stage BIN_DIR=/usr/local/bin GRAALVM_HOME=/opt/graalvm \
    KNATIVE_CLI_VERSION=0.2.0 TEKTON_CLI_VERSION=0.4.0 GRAALVM_VERSION=19.3.1

ENV PATH=${GRAALVM_HOME}/graalvm-ce-java11-${GRAALVM_VERSION}/bin:$PATH

USER root

RUN mkdir -p ${GRAALVM_HOME} && mkdir -p ${STAGE_DIR} && cd ${STAGE_DIR} && \
    curl -OL https://github.com/knative/client/releases/download/v${KNATIVE_CLI_VERSION}/kn-linux-amd64 && \
    chmod a+x kn-linux-amd64 && mv kn-linux-amd64 ${BIN_DIR}/kn && \
    curl -OL https://github.com/tektoncd/cli/releases/download/v${TEKTON_CLI_VERSION}/tkn_${TEKTON_CLI_VERSION}_linux_x86_64.tar.gz && \
    tar xvzf tkn_${TEKTON_CLI_VERSION}_linux_x86_64.tar.gz && mv tkn ${BIN_DIR} && \
    curl -OL https://storage.googleapis.com/hey-release/hey_linux_amd64 && \
    chmod a+x hey_linux_amd64 && mv hey_linux_amd64 ${BIN_DIR}/hey && \
    curl -OL https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz && \
    tar xvzf graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz -C ${GRAALVM_HOME}
    
RUN rm -rf ${STAGE_DIR}

RUN gu install native-image && yum install -y gcc glibc-devel zlib-devel libstdc++-static

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

ENV TERMINAL_TAB=split

USER 1001

#RUN cd /opt/app-root/src && \
#   mvn io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION:create \
#    -DprojectGroupId="com.redhat.atomic.fruit" \
#    -DprojectArtifactId="fruit-service-dockerfile" \
#    -DprojectVersion="1.0-SNAPSHOT" \
#    -DclassName="FruitResource" \
#    -Dpath="fruit" && \
#   cd fruit-service-dockerfile && \
#   ./mvnw -DskipTests clean package

#RUN cd atomic-fruit-service && \
#    ./mvnw -DskipTests clean package -Pnative

#RUN rm -rf /opt/app-root/src/atomic-fruit-service

RUN /usr/libexec/s2i/assemble
