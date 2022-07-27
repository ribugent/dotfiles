#!/bin/bash

sudo systemctl enable --now firewalld

if [ ! -e /etc/firewalld/zones/docker.xml ]; then
	sudo firewall-cmd --zone=trusted --remove-interface=docker0 --permanent
	sudo firewall-cmd --reload
	sudo systemctl restart docker
fi


if [ ! -e /var/lib/clamav/daily.cld ]; then
	sudo freshclam
	sudo systemctl enable --now clamav-freshclam
	sudo systemctl enable --now clamav-daemon
fi

if [ $(systemctl is-enabled touchegg) != 'enabled' ]; then
	sudo systemctl enable --now touchegg
fi
