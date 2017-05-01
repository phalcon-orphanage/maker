#!/bin/bash -eux

# Apt cleanup.
apt -y autoremove
apt -y autoclean

# Try to upgrade
apt -y update
apt -y upgrade

# Delete unneeded files
rm -rf \
	/root/{.bash_history,daemonize*,.composer,.npm,.wget-hsts,.pearrc} \
	/home/vagrant/{.ansibl*,.bash_history,.sudo*,.wget-hsts,.cache/*,*.sh,.pearrc,.v8*} \
	/var/lib/apt/lists/* \
	/etc/apt/trusted.gpg.d/{ansible_ubuntu_ansible.gpg~,ondrej_ubuntu_php.gpg~} \
	/etc/apt/sources.list.d/ansible-ubuntu-ansible-xenial.list.save \
	/tmp/* \
	/var/tmp/* \
	/etc/apt/{sources.list~,trusted.gpg~,sources.list.save} \
	/var/cache/apt/archives/* \
	/var/cache/debconf/*-old \
	/var/log/installer \
	/var/log/bootstrap.log

# Clean logs
dd if=/dev/null of=/var/log/mongodb/mongod.log
dd if=/dev/null of=/var/log/dpkg.log
dd if=/dev/null of=/var/log/vboxadd-install.log
dd if=/dev/null of=/var/log/vboxadd-install-x11.log
dd if=/dev/null of=/var/log/syslog
dd if=/dev/null of=/var/log/kern.log
dd if=/dev/null of=/var/log/apt/history.log
dd if=/dev/null of=/var/log/apt/term.log
dd if=/dev/null of=/var/log/mysql/error.log
dd if=/dev/null of=/var/log/mysql/mysql.err
dd if=/dev/null of=/var/log/auth.log
dd if=/dev/null of=/var/log/alternatives.log
dd if=/dev/null of=/var/log/fontconfig.log

# Workarounds
rm -f /usr/local/bin/bash
chmod -x /etc/systemd/system/mailhog.service

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
