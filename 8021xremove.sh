#!/bin/bash
nmcli connection delete ZKB-wired-8021x > /dev/null 2>&1
nmcli connection delete ZKB-wireless-8021x > /dev/null 2>&1
apt-get remove certmonger -y > /dev/null 2>&1
rm -f /etc/pki/certs/cacert.pfx /etc/pki/certs/cacert.pem /etc/pki/certs/client.key /etc/pki/certs/client.pem /bin/create_certkey.sh /etc/pki/certs/client_enc.key > /dev/null 2>&1
# echo Sistem 5 saniye içinde yeniden başlatılacak...
# sleep 1
# echo 5
# sleep 1
# echo 4
# sleep 1
# echo 3
# sleep 1
# echo 2
# sleep 1
# echo 1
# sleep 1
# reboot