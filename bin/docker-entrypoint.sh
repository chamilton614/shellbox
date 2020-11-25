#!/bin/bash
echo "[ENTRYPOINT] Shell"

export GIT_VERSION=$(/opt/rh/rh-git218/root/usr/bin/git --version | awk '{ print $3 }')
export OPENSHIFT_CLIENT_VERSION=$(oc version | grep oc | awk '{ print $2 }')

sleep infinity