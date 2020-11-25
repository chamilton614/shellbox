#!/bin/bash

### Set the OpenShift Project to use
PROJECT=$1

### Check if Project was passed in
if  [ -z "${PROJECT}" ]; then
    ### Usage
    echo "setup-shellbox myproject"
else
    ### Create the Build Config
    oc new-build --strategy docker --binary --docker-image centos:centos7 --name shellbox -n ${PROJECT}
    echo ""

    ### Start the Build
    oc start-build shellbox --from-dir . --follow -n ${PROJECT}
    echo ""

    ### Deploy the Application
    oc new-app shellbox --name shellbox -n ${PROJECT}
    echo ""
fi
