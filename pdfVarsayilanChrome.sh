#!/bin/bash
ilksatir=0
#satirsayisi=0
user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
girdi=(/home/$user_name@ziraatkatilim.local/.config/mimeapps.list)
kacsatir=$(wc -l < /home/$user_name@ziraatkatilim.local/.config/mimeapps.list)

while read -r satir
do
  let "satirsayisi++" 
  if [[ "$satir" == "" ]]; then
    echo "application/pdf=chromium.desktop" >> /home/mimeapp_new.list
    ilksatir=1
    #elif [[ $satirsayisi == $kacsatir ]] && [[ $ilksatir == 1 ]] ; then
    #sed -i 'application/pdf=chromium.desktop' test.list
  fi
  echo "$satir" >> /home/mimeapp_new.list
done < "$girdi"
echo "application/pdf=chromium.desktop" >> /home/mimeapp_new.list
mv /home/$user_name@ziraatkatilim.local/.config/mimeapps.list /home/$user_name@ziraatkatilim.local/.config/mimeapps_old.list
mv /home/mimeapp_new.list /home/$user_name@ziraatkatilim.local/.config/mimeapps.list
# rm /home/mimeapp_new.list