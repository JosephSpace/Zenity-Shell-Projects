#!/bin/bash
user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
desktop_file_path=(/home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop)

cat <<EOF > /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
[Desktop Entry]
Name=GeyveRestart
Exec=sh -c "xterm -e 'systemctl --user restart geyve';zenity --info 'Bilgi' --text 'İşlem başarılı.'  --width=150"
Icon=printer
Terminal=false
Type=Application

EOF

chown -R "$user_name:domain users" /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chown -R "$user_name:domain users" /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod +x /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod +x /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod -R 650 /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod -R 650 /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop

chown "$user_name:domain users" /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod 650 /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
chmod +x /home/$user_name@ziraatkatilim.local/Masaüstü/GeyveRestart.Desktop
cd /home/$user_name@ziraatkatilim.local/Masaüstü/

sudo -u $user_name bash -c '\
touch '$desktop_file_path'
chmod 755 '$desktop_file_path'
'

sudo -u $user_name bash -c 'dbus-launch gio set '$desktop_file_path' metadata::trusted true'
