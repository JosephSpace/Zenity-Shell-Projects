#!/bin/bash

gnomeTerminalCheck=$(dpkg-query -l gnome-terminal 2>&1);
if [[ $gnomeTerminalCheck == *"no packages"* ]] || [[ $gnomeTerminalCheck == *"eşleşen bir paket"* ]]; then
	rm -rf /var/log/messages*
	rm -rf /var/log/user*
	rm -rf /var/log/syslog*
	echo -e "Var loglar silindi."
	sleep 2
	touch /var/log/messages
	touch /var/log/user.log
	touch /var/log/syslog
	echo -e "Var log bölümleri tekrar oluşturuldu"
	apt autoremove -y
	dpkg --configure -a
	apt-get install gnome-terminal -y
elif [[ $gnomeTerminalCheck == *"Unable to locate package"* ]]; then
	echo "Gnome-Terminal Uygulaması Yüklenemedi"
elif [[ $gnomeTerminalCheck == *"dpkg --configure"* ]]; then
	dpkg --configure -a
else
	echo "Gnome-Terminal Uygulaması Yüklü"
fi

filezillaCheck=$(dpkg-query -l filezilla 2>&1);
if [[ $filezillaCheck == *"no packages"* ]] || [[ $filezillaCheck == *"eşleşen bir paket"* ]]; then
	rm -rf /var/log/messages*
	rm -rf /var/log/user*
	rm -rf /var/log/syslog*
	echo -e "Var loglar silindi."
	sleep 2
	touch /var/log/messages
	touch /var/log/user.log
	touch /var/log/syslog
	echo -e "Var log bölümleri tekrar oluşturuldu"
	apt autoremove -y
	dpkg --configure -a
	apt-get install gnome-terminal -y
elif [[ $filezillaCheck == *"Unable to locate package"* ]]; then
	echo "Filezilla Uygulaması Yüklenemedi"
elif [[ $filezillaCheck == *"dpkg --configure"* ]]; then
	dpkg --configure -a
else
	echo "Filezilla Uygulaması Yüklü"
fi

user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
desktop_file_path=(/home/$user_name@ziraatkatilim.local/Masaüstü/ZKB-Support.Desktop)
mkdir -p /usr/local/share/zkb-support
cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/prod.sh /usr/local/share/zkb-support/
cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/cupsd_deg.conf /usr/local/share/zkb-support/
cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/cupsd_org.conf /usr/local/share/zkb-support/
cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/updater.sh /usr/local/share/zkb-support/
cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/noMachinePwGenerator.pl /usr/local/share/zkb-support/

chown -R "$user_name:domain users" /usr/local/share/zkb-support/
chown -R "$user_name:domain users" /usr/local/share/zkb-support/*
chmod +x /usr/local/share/zkb-support/*
chmod +x /usr/local/share/zkb-support/
chmod -R 650 /usr/local/share/zkb-support/ 
chmod -R 650 /usr/local/share/zkb-support/*

cat <<EOF > /home/$user_name@ziraatkatilim.local/Masaüstü/ZKB-Support.Desktop
[Desktop Entry]
Name=ZKB_Support
Exec=bash /usr/local/share/zkb-support/updater.sh
Icon=zk-logo
Terminal=false
Type=Application

EOF

chown "$user_name:domain users" /home/$user_name@ziraatkatilim.local/Masaüstü/ZKB-Support.Desktop
chmod 650 /home/$user_name@ziraatkatilim.local/Masaüstü/ZKB-Support.Desktop
chmod +x /home/$user_name@ziraatkatilim.local/Masaüstü/ZKB-Support.Desktop
cd /home/$user_name@ziraatkatilim.local/Masaüstü/
chmod +x /usr/local/share/zkb-support

sudo -u $user_name bash -c '\
touch '$desktop_file_path'
chmod 755 '$desktop_file_path'
'

sudo -u $user_name bash -c 'dbus-launch gio set '$desktop_file_path' metadata::trusted true'
