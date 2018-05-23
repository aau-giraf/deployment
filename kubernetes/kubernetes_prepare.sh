#/usr/bin/env bash

# Script to avoid having to make users manually
# NOTE: Only use this in testing environments where you need mass deployment

test=$1

yum -y update
yum -y install epel-release
yum -y install nano htop

# Create user with home folder
useradd kubernetes
# Check if string is empty for setting password immediately
if [ "$test" != "" ]; then
# If the string length is greater than or equals 8 then pipe to passwd
	if [ ${#test} -ge 8 ]; then
	    printf "$test\n$test" | passwd kubernetes
	else
		printf "Invalid password length\n"
	    passwd kubernetes
	fi
else
	passwd kubernetes
fi

# Give kubernetes user docker access (wheel)
usermod -aG wheel kubernetes

curl -L "https://gitlab.giraf.cs.aau.dk/tools/deployment/raw/master/kubernetes/kubernetes_deploy.sh" -s -o /home/kubernetes/kubernetes_deploy.sh
chmod +x /home/kubernetes/kubernetes_deploy.sh
cd /home/kubernetes