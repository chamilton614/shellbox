#!/bin/bash

#Cert File
CERT_FILE=$1

#Check if Cert File exists - otherwise do nothing
if [ -f "${CERT_FILE}" ]; then
    echo yes | keytool -import -alias ACompany \
    -keystore /usr/lib/jvm/jre-openjdk/lib/security/cacerts \
    -file ${CERT_FILE} \
    -storepass changeit \
    -trustcacerts
else
    echo "${CERT_FILE} does not exist"
fi
