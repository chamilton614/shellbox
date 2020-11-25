#!/bin/bash
#OpenShift Login Script

#Set the input variables
USER=$1
CLUSTER_URL=$2

#Check the USER to determine if we can login to the the Cluster
if [ -z "${USER}" ] || [ -z "${CLUSTER_URL}" ]; then
    #Output the syntax to the user
    echo "ocl <User> <Cluster URL>"
    echo "e.g. ocl chamilt5 https://ocpserver:8443"
else
    #Perform login
    oc login -u ${USER} ${CLUSTER_URL}
fi

echo ""