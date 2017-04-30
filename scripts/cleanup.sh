#!/bin/bash -eux

# Apt cleanup.
apt -y autoremove
apt -y autoclean

# Try to upgrade
apt -y update
apt -y upgrade

# Delete unneeded files
rm -rf \
	/root/{.bash_history,daemonize*,.composer,.npm,.wget-hsts} \
	/home/vagrant/{.ansibl*,.bash_history,.sudo*,.wget-hsts,.cache/*,*.sh,.v8*} \
	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/* \
	/etc/apt/{sources.list~,trusted.gpg~} \
	/var/cache/apt/archives/* \
	/var/cache/debconf/*-old

# Workaround
rm -f /usr/local/bin/bash

chown -R vagrant:vagrant /home/vagrant

# Clean logs
dd if=/dev/null of=/var/log/syslog

cat /dev/null > /home/vagrant/.bash_history

unset HISTFILE

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
