#!/bin/bash -eux

export export DEBIAN_FRONTEND=noninteractive

function print_info {
	echo -e "\033[1;33m${1}\033[0m"
}

print_info 'Workarounds...'
rm -f /usr/local/bin/bash
chmod -x /etc/systemd/system/mailhog.service
chown -R vagrant:vagrant /home/vagrant

print_info 'Delete unneeded files'
rm -rf \
	/root/{daemonize*,.composer,.npm,.wget-hsts,.pearrc} \
	/home/vagrant/{.ansibl*,.sudo*,.wget-hsts,.cache/*,*.sh,.pearrc,.v8*} \
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

print_info 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done

print_info 'Whiteout swap'
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart
dd if=/dev/zero of=$swappart
mkswap -f $swappart
swapon $swappart

print_info 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

print_info 'Zero out the rest of the free space using dd, then delete the written file'
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

print_info "Add `sync` so Packer doesn't quit too early, before the large file is deleted"
sync

print_info 'Vagrant cleanup complete!'
