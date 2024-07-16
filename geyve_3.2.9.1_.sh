#!/bin/bash

# geyve yeni versiyon kontrolu
grep -i '3.2.9.1' /usr/lib/geyve/version.py  > /dev/null 2>&1
if [[ $? != 0 ]];then
wget --no-check-certificate -qNP /tmp/ https://zkxsrepo.ziraatkatilim.local/external/geyve/geyve2_uninstall.sh
bash /tmp/geyve2_uninstall.sh > /dev/null 2>&1

wget --no-check-certificate -qNP /tmp/ https://zkxsrepo.ziraatkatilim.local/external/geyve/geyve_test.sh
bash /tmp/geyve_test.sh > /dev/null 2>&1

wget --no-check-certificate -qNP /tmp/ https://zkxsrepo.ziraatkatilim.local/external/geyve/geyve.service
mv /tmp/geyve.service /usr/lib/geyve/geyve.service
chmod 666 /usr/lib/geyve/geyve.service

wget --no-check-certificate -qNP /tmp/ https://zkxsrepo.ziraatkatilim.local/external/geyve/printerLinux.py 
mv /tmp/printerLinux.py /usr/lib/geyve/printing/printerLib/printerLinux.py
chmod 666 /usr/lib/geyve/printing/printerLib/printerLinux.py

echo "__version__ = '3.2.9.1'" > /usr/lib/geyve/version.py

systemctl daemon-reload
xuser=$(who | grep ' \:[0-9]' | awk '{print $1}')
runuser -l $xuser -c 'DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $xuser)/bus systemctl --user daemon-reload' > /dev/null 2>&1
runuser -l $xuser -c 'DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $xuser)/bus systemctl --user disable geyve' > /dev/null 2>&1
runuser -l $xuser -c 'DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $xuser)/bus systemctl --user enable geyve' > /dev/null 2>&1
fi

#start_geyve.sh kontrolu
if [[ ! -f /bin/start_geyve.sh ]]; then
wget --no-check-certificate -qNP /tmp/ https://zkxsrepo.ziraatkatilim.local/external/geyve/start_geyve.sh
mv /tmp/start_geyve.sh /bin/start_geyve.sh
chmod 755 /bin/start_geyve.sh
fi

