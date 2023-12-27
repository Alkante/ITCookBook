#!/bin/bash

echo "### root (sshd) fingerprint ###"
cd /etc/ssh
for file in *sa_key.pub
	do   ssh-keygen -lf $file
done

echo "### user fingerprint ###"

echo "### user know_hosts fingerprint ###"
ssh-keygen -l -f ~/.ssh/known_hosts
