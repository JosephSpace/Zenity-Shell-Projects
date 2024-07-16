#!/bin/bash
#802.1x machine authentication using enrollment

#######################################################
#Set Variables
DC_HOST_ADDRESS="dc1.ziraatkatilim.local"
username=`echo YXAubmRlcy5zdQo= | openssl enc -pbkdf2 -a -d -salt -pass pass:wtf | tr -d " "`
password=`echo R2FraWhyZTc2OTQK | openssl enc -pbkdf2 -a -d -salt -pass pass:wtf | tr -d " "`
hstnm1=`hostname -f | tr -d " "`
hstnm2=`hostname -s | tr -d " "`
checkmonger=`dpkg-query --show --showformat='${db:Status-Status}\n' 'certmonger' 2>/dev/null`
red="\e[31m"
green="\e[32m"
wirelessdev=`nmcli -t device 2>/dev/null | grep -i wifi | head -1 | awk -F":" '{print $1}' 2>/dev/null`
wireddev=`nmcli -t device 2>/dev/null | grep -i ethernet | head -1 | awk -F":" '{print $1}' 2>/dev/null`

#######################################################
#Check if Certmonger is Installed
if [ "$checkmonger" = "installed" ]
then
true
else
apt-get install certmonger -y > /dev/null 2>&1
	if [ "$?" != "0" ]
	then
	echo -e "${red}Certmonger paketi yüklenemedi! Yükleme kapatılıyor."
	exit 1
	fi
fi
systemctl start certmonger > /dev/null 2>&1
echo -e "${green}Adım 1 / 7 tamamlandı: certmonger yüklendi. Devam ediliyor..."

#######################################################
#Download CA certificate
mkdir -p /etc/pki/certs/ > /dev/null 2>&1
wget --no-check-certificate -qO /etc/pki/certs/cacert.pfx https://$DC_HOST_ADDRESS/external/8021x/CA.cer > /dev/null 2>&1

if [ ! -f "/etc/pki/certs/cacert.pfx" ]
then
echo -e "${red}Ana bilgisayarda CA sertifikası bulunamadı : https://$DC_HOST_ADDRESS/external/8021x/CA.cer , yükleme kapatılıyor."
exit 2
else
openssl x509 -inform DER -outform PEM -in /etc/pki/certs/cacert.pfx -out /etc/pki/certs/cacert.pem > /dev/null 2>&1
fi

chkformat=`file /etc/pki/certs/cacert.pem 2>/dev/null | awk -F":" '{print $2}' | tr -d " "`
if [ "$chkformat" != "PEMcertificate" ]
then
echo -e "${red}Sertifika pfx'ten çıkarılamadı, yükleme kapatılıyor."
exit 3
fi
echo -e "${green}Adım 2 / 7 tamamlandı: CA sertifikası yakalandı. Devam ediliyor..."

#######################################################
#Create scep-ca
getcert add-scep-ca -R /etc/pki/certs/cacert.pem -c zkcandes -u "http://zkcandes.ziraatkatilim.local/certsrv/mscep/mscep.dll" > /dev/null 2>&1
systemctl restart certmonger > /dev/null 2>&1
sleep 10
thumbnail=`getcert list-cas -c zkcandes | grep MD5 | awk '{print $NF}' | tr -d " "`

if [ "$thumbnail" != "52B3F3EB" ]
then
echo -e "${red}Zkcandes'e erişilemiyor, yükleme kapatılıyor."
exit 4
fi
echo -e "${green}Adım 3 / 7 tamamlandı : scep-ca oluşturuldu. Devam ediliyor..."

#######################################################
#Request PIN from zkcandes
file1=`mktemp /var/tmp/silXXXXXX`
file2=`mktemp /var/tmp/silXXXXXX`
chmod 400 $file1 > /dev/null 2>&1
wget --no-check-certificate --user=$username --password=$password "https://zkcandes.ziraatkatilim.local/CertSrv/mscep_admin" -O $file1 > /dev/null 2>&1
iconv -f utf-16 -t utf-8 $file1 > $file2 2>/dev/null
pin=`awk '{for(i=1;i<=NF;i++)if($i=="<B>")print $(i+1)}' $file2 2>/dev/null | grep -w "................" 2>/dev/null | tr -d " "`
rm -f $file1 $file2 > /dev/null 2>&1

#######################################################
#Request Certificate
getcert request -I $RANDOM -U 1.3.6.1.5.5.7.3.2 -c zkcandes -k /etc/pki/certs/client.key -f /etc/pki/certs/client.pem -D "$hstnm1" -D "$hstnm2" -C "/bin/create_certkey.sh" > /dev/null 2>&1
sleep 10
if [ -f "/etc/pki/certs/client.key" ] && [ -f "/etc/pki/certs/client.pem" ]
then
echo -e "${green}Adım 4 / 7 tamamlandı : Sertifika alındı. Devam ediliyor.."
else
echo -e "${red}Sertifika ve Anahtar alınamadı, yükleme kapatılıyor."
exit 5
fi

#######################################################
#Delete the pin from request that denies cert renew process
systemctl stop certmonger > /dev/null 2>&1
for files in `ls /var/lib/certmonger/requests/`
do
sed -i '/^template-challenge-password/d' $files > /dev/null 2>&1
done
systemctl start certmonger > /dev/null 2>&1

#######################################################
#Add enc to key
cat << EOF > /bin/create_certkey.sh
#!/bin/bash
if [ -f /etc/pki/certs/client.key ] && [ -f /etc/pki/certs/client.pem ]
then
openssl rsa -des3 -in /etc/pki/certs/client.key -out /etc/pki/certs/client_enc.key -passout pass:1q2w3e4r > /dev/null 2>&1
fi
EOF
chmod +x /bin/create_certkey.sh > /dev/null 2>&1
/bin/bash /bin/create_certkey.sh > /dev/null 2>&1
chmod -R 400 /etc/pki/certs > /dev/null 2>&1

if [ ! -f "/etc/pki/certs/client_enc.key" ]
then
echo -e "${red}Anahtar şifrelenemiyor, yükleme kapatılıyor."
exit 6
fi

echo -e "${green}Adım 5 / 7 tamamlandı: Anahtar şifrelendi. Devam ediliyor..."

#######################################################
#Backup the current configuration
tar -czf /root/network_backup.tar.gz /etc/certs /etc/NetworkManager/system-connections > /dev/null 2>&1

if [ ! -f "/root/network_backup.tar.gz" ]
then
echo -e "${red}Yedekleme oluşturulurken,hata oluştu. Yükleme kapatılıyor."
exit 7
fi

echo -e "${green}Adım 6 / 7 tamamlandı : Yapılandırma yedeklemesi başarıyla tamamlandı. Devam ediliyor.."

#######################################################
#Configure wired 8021.x
if [ -n "$wireddev" ]
then
nmcli connection add type ethernet con-name "ZKB-wired-8021x" ifname $wireddev > /dev/null 2>&1
nmcli connection modify ZKB-wired-8021x connection.autoconnect-priority 50 802-1x.eap tls 802-1x.client-cert /etc/pki/certs/client.pem 802-1x.private-key /etc/pki/certs/client_enc.key 802-1x.identity "host/$hstnm1" 802-1x.ca-cert /etc/pki/certs/cacert.pem 802-1x.private-key-password "1q2w3e4r" ipv6.method ignore > /dev/null 2>&1
sed -i '/^interface-name/d' /etc/NetworkManager/system-connections/ZKB-wired-8021x.nmconnection > /dev/null 2>&1
fi

#Configure wireless 8021.x
if [ -n "$wirelessdev" ]
then
nmcli connection add type wifi con-name "ZKB-wireless-8021x" ifname $wirelessdev ssid Dot1x > /dev/null 2>&1
nmcli connection modify ZKB-wireless-8021x wifi.mode infrastructure connection.autoconnect-priority 40 wifi.hidden true wifi.ssid Dot1x wifi-sec.key-mgmt wpa-eap 802-1x.eap tls 802-1x.client-cert /etc/pki/certs/client.pem 802-1x.private-key /etc/pki/certs/client_enc.key 802-1x.identity "host/$hstnm1" 802-1x.ca-cert /etc/pki/certs/cacert.pem 802-1x.private-key-password "1q2w3e4r" ipv6.method ignore > /dev/null 2>&1
sed -i '/^interface-name/d' /etc/NetworkManager/system-connections/ZKB-wireless-8021x.nmconnection > /dev/null 2>&1
fi

systemctl restart NetworkManager > /dev/null 2>&1

#######################################################
#Check NM status
sleep 20
nmcli -t connection show --active 2>/dev/null | grep ^"ZKB-wire" > /dev/null 2>&1
if [ "$?" = "0" ]
then
echo -e "${green}Adım 7 / 7 tamamlandı: Tüm ayarlar başarıyla tamamlandı."
else
echo -e "${red} Ağ yöneticisi(networkmanager) dışında tüm ayarlar başarılı oldu, çıkılıyor.."
fi
echo Sistem 5 saniye içinde yeniden başlatılacak...
sleep 1
echo 5
sleep 1
echo 4
sleep 1
echo 3
sleep 1
echo 2
sleep 1
echo 1
sleep 1
reboot
