#!/bin/bash

NC='\033[0m' # No Color
CYAN='\033[0;36m'

piplibs='urllib3-1.26.2-py2.py3-none-any.whl certifi-2020.12.5-py2.py3-none-any.whl chardet-4.0.0-py2.py3-none-any.whl click-7.1.2-py2.py3-none-any.whl MarkupSafe-1.1.1-cp37-cp37m-manylinux1_x86_64.whl Jinja2-2.11.2-py2.py3-none-any.whl itsdangerous-1.1.0-py2.py3-none-any.whl Werkzeug-1.0.1-py2.py3-none-any.whl Flask-1.1.2-py2.py3-none-any.whl six-1.15.0-py2.py3-none-any.whl Flask_Cors-3.0.9-py2.py3-none-any.whl psutil-5.8.0.tar.gz idna-2.10-py2.py3-none-any.whl Pillow-8.0.1-cp37-cp37m-manylinux1_x86_64.whl requests-2.25.1-py2.py3-none-any.whl python-sane-2.8.2.tar.gz '

for lib in $piplibs
do
    echo -e "uninstalling ${CYAN}$lib${NC}..."
    pip3 uninstall -y /tmp/geyve-whls/$lib > /dev/null 2>&1
done


isGeyveInstalled="False"
[ -d "/usr/lib/geyve/" ] && isGeyveInstalled="True"
if [[ "$isGeyveInstalled" == "True" ]];  then
    
		
	echo -e "stop ${STRESS}geyve_patron${NC}..."
	systemctl stop geyve_patron
	echo -e "disable ${STRESS}geyve_patron${NC}..."
	systemctl disable geyve_patron
	echo -e "remove ${STRESS}geyve_patron.service${NC}..."
	unlink /etc/systemd/system/geyve_patron.service

	echo -e "stop ${STRESS}geyve${NC}..."
	systemctl --user stop geyve
	echo -e "disable ${STRESS}geyve${NC}..."
	systemctl --user --global disable geyve
	echo -e "kill active ${CYAN}geyve services${NC}..."
	pkill -f "[g]eyve.py"
	echo -e "remove ${STRESS}geyve.service${NC}..."
	unlink /etc/systemd/user/geyve.service
			
	echo reloading systemctl system daemon...
	systemctl daemon-reload	
	
	echo -e "${CYAN}Geyve${NC} is uninstalling...";	
	echo -e "delete geyve folder /usr/lib/geyve${NC}...";	
	rm -r /usr/lib/geyve/		
	echo -e "${CYAN}Geyve${NC} is uninstalled.";	
			
	
	echo -e "delete /var/lib/geyve${NC}..."
	rm -r /var/lib/geyve

    echo -e "delete logs folders${NC}..."
    find /home/*/tmp -name "logs" -exec echo delete logs folder {} \;
    find /home/*/tmp -name "logs" -exec rm -r {} \;	
systemctl --user daemon-reload

	
else # Geyve kurulu değilse ilerlemeden çık
	echo -e "${CYAN}Geyve${NC} not installed. Exiting without uninstalling...";
	exit 0;
fi

echo finished!!!