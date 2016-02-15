#!/bin/zsh

PATH=$PATH:/usr/sbin:/sbin
CONFIG=/tmp/config
IFACE=${1:-eno16777736}
IP=/tmp/$IFACE

#ip=` ifconfig $IFACE | grep inet.addr | cut -d: -f2  | cut -d' ' -f1`
ip=` ifconfig $IFACE | (read skippedLine; read inet addr junk; echo $addr) `

oldIp=`cat $IP 2>/dev/null`

if [ "$ip" != "$oldIp" ]
then
	echo $ip > $IP
	# now update the config file on the mac
	echo hi jonathan your ip address is $ip enjoy
	cat <<EOF > $CONFIG
Host linux
User student
Hostname $ip
LocalForward 1521 localhost:1521 
LocalForward 3306 localhost:3306 
CheckHostIP no
ExitOnForwardFailure yes
StrictHostKeyChecking no

Host dad
Hostname office.bairdbunch.com
Port 57253
LocalForward 7009 localhost:22
LocalForward 5909 localhost:5900
User Russell
Compression yes
CompressionLevel 9

Host mac
Hostname 172.16.203.1
user jonathan

Host *
ForwardAgent yes
ControlMaster auto
ControlPath ~/.ssh/.%r@%h:%p
ControlPersist yes
ForwardX11 yes
EOF
	ssh-add
	scp $CONFIG mac:.ssh/config
	ssh mac chmod go-w .ssh/config
	mv $CONFIG ~/.ssh/config
	chmod go-w ~/.ssh/config
fi
