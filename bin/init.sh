#!/bin/bash

#source /etc/profile.d/maven.sh

### Setup Git Global variables
echo "What is your full name for Git Config?"
read USER_NAME
echo ""
git config --global user.name "${USER_NAME}"

echo "What is your email for Git Config?"
read USER_EMAIL
echo ""
git config --global user.email "${USER_EMAIL}"
