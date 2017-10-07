#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

apt-get -y autoremove
apt-get -y clean

echo 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f 2&>1 > /dev/null; done

echo 'Whiteout swap'
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart
dd if=/dev/zero of=$swappart || true
mkswap -f $swappart
swapon $swappart

echo 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

echo 'Zero out the rest of the free space using dd, then delete the written file'
dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY

echo "Add `sync` so Vagrant doesn't quit too early, before the large file is deleted"
sync

echo 'Vagrant cleanup complete!'
