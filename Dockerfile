#FROM docker-registry.default.svc:5000/shellbox/s2i-core-centos7
FROM centos:centos7

USER root

ENV APP_ROOT=/opt/app-root
ENV HOME=${APP_ROOT}
ENV MAVEN_VERSION=3.6.3

#COPY docker-entrypoint.sh ${APP_ROOT}/entrypoint.sh
COPY bin/ ${APP_ROOT}/bin/
### Add OpenShift CLI
COPY *.tar.gz ${APP_ROOT}/OpenShift_CLI/oc-linux.tar.gz

### Centos Updates
RUN yum install -y vim wget curl git dos2unix java-1.8.0-openjdk-devel && \
    yum clean all
### Maven
RUN wget http://apache.claz.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -P /tmp && \
	tar -xvf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
	rm -f /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
	ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    mkdir -p $HOME/.m2 && chmod -R a+rwX $HOME/.m2 && \
### OpenShift CLI
    tar -xvf ${APP_ROOT}/OpenShift_CLI/oc-linux.tar.gz -C ${APP_ROOT}/OpenShift_CLI && \
    rm -f ${APP_ROOT}/OpenShift_CLI/*.tar.gz && \
### Fix Permissions
    wget -nv https://raw.githubusercontent.com/sclorg/s2i-base-container/master/core/root/usr/bin/fix-permissions \
	-O /usr/bin/fix-permissions && chmod +x /usr/bin/fix-permissions

### Add Maven Settings
COPY s2i-settings.xml ${APP_ROOT}/.m2/settings.xml

### Add Wildcard Cert
#COPY SomeWildcard.cer ${APP_ROOT}/Cert.cer

#VOLUME ${APP_ROOT}/data

### Setup user for build execution and application runtime
ENV JAVA_HOME=/usr/lib/jvm/jre-openjdk
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV APP_ROOT=/opt/app-root
ENV OPENSHIFT_CLI=${APP_ROOT}/OpenShift_CLI
#Update PATH
ENV PATH=${APP_ROOT}/bin:${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${OPENSHIFT_CLI}:${PATH}

### Update Permissions and Execute any additional scripts or commands
RUN mkdir -p ${APP_ROOT}/.kube && \
    mkdir -p ${APP_ROOT}/data && \
	fix-permissions ${APP_ROOT}/.kube -P && \
    fix-permissions ${APP_ROOT}/data -P && \
    fix-permissions ${APP_ROOT} -P && \
    chown -R 1001:0 ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    #chmod +x ${APP_ROOT}/bin/uid_entrypoint.sh && \
    #chmod +x ${APP_ROOT}/entrypoint.sh
    chmod -R g=u ${APP_ROOT} /etc/passwd
    #Add any scripts or other commands here
    #${APP_ROOT}/bin/add-cert.sh ${APP_ROOT}/Cert.cer

USER 1001

WORKDIR ${APP_ROOT}

#ENTRYPOINT ["./bin/entrypoint.sh"]
ENTRYPOINT [ "./bin/uid_entrypoint.sh" ]
CMD ./bin/run.sh