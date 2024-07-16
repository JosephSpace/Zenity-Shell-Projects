#!/bin/bash
ZKVersion:1.0.262
ilkBas=0

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

nomachineloginUser=$(ssh root@localhost "loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print \$3}'" 2>&1)
pcgetVersion="$(grep -E '^(VERSION)=' /etc/os-release | cut -d ' ' -f 2 | cut -d '(' -f 2)"
noMachinePwGen=/usr/local/share/zkb-support/noMachinePwGenerator.pl
if [ ! -f "$noMachinePwGen" ]; then
	cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/noMachinePwGenerator.pl /usr/local/share/zkb-support/
fi

pcgetVersion=`echo $pcgetVersion | sed 's/)"//'`
if [ "$nomachineloginUser" == "bg002276" ]; then
	NomachineNXSYol="Documents"
else
	if [ "$pcgetVersion" == "yirmiuc" ]; then
		yirmiucDocTest=$HOME/Belgeler
		if [ -d "$yirmiucDocTest" ]; then
			NomachineNXSYol="Belgeler"
		else
			NomachineNXSYol="Documents"
		fi
	else
		NomachineNXSYol="Belgeler"
	fi
fi
echo $NomachineNXSYol

calismaYolu="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

siraKaptanIP="10.212.0.195"
pcKaptanIP="10.212.0.195"
kaptanTestSIP="10.212.24.130"

geyveRestartYolu="/media/Birimlerarasi/Pardus_Betik/geyveRestartOlustur.sh"
scannnerYol="/media/Birimlerarasi/Pardus_Betik/AVISION-Driver/scanner-driver-avision_deb64_0.1.0.22235_20220823/scanner-driver-avision_0.1.0-22235_amd64.deb"
sekizYol="/media/Birimlerarasi/Pardus_Betik/8021x_v2.sh"
nanoIYol="/media/Birimlerarasi/Pardus_Betik/nanodems/install-ndclient_v2.sh"
nanoDeskYol="/media/Birimlerarasi/Pardus_Betik/nanodems/nanodems_desktop_launcher.sh"
#geyveUYol="/media/Birimlerarasi/Pardus_Betik/geyve2_uninstall.sh"
vlcPYol="/media/Birimlerarasi/Pardus_Betik/Pardus21nanodems/vlc-with-rtsp/*"
sekizRemYol="/media/Birimlerarasi/Pardus_Betik/8021xremove.sh"
arkYol="/media/Birimlerarasi/Pardus_Betik/eimza/arksigner-pub-2.3.10.deb"
eimzaYol="/media/Birimlerarasi/Pardus_Betik/imzager/esya-imzager-2.10-Kurumsal.sh"
eimzaUnistall="/media/Birimlerarasi/Pardus_Betik/imzager/Imzager_Kurumsal_uninstall.sh"
imzagerLisans="/media/Birimlerarasi/Pardus_Betik/imzager/imzager_yeni_lisans_2023/lisans.xml"
akisYol="/media/Birimlerarasi/Pardus_Betik/eimza/Akia_linux_6_5_4.deb"
#geyve3291Yol="/media/Birimlerarasi/Pardus_Betik/geyve_3.2.9.1_.sh"
pdfDefChrom="/media/Birimlerarasi/Pardus_Betik/pdfVarsayilanChrome.sh"
bimserYol="/media/Birimlerarasi/Pardus_Betik/BimserEBA/SetupFiles"

geyveService="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/geyve.service"
geyve3291Install="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/geyve_3.2.9.1install.sh"
geyveWHLS="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/geyve_whls_new.tar.gz"
geyvePrinteLinux="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/printerLinux.py"
geyveStart="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/start_geyve.sh"
geyvePatronService="/media/Birimlerarasi/Pardus_Betik/geyve3.2.9.1/geyve_patron.service"

function basla() {

if [[ $ilkBas -eq 0 ]]; then
if [ -n "${ENTRY}" ]; then
   if [[ $hostName == *"SIRA"* ]] || [[ $hostName == *"sira"* ]] ; then
				{
					tayfaVer=''
                    SIRAanaMenu 
                } else {
                    PCanaMenu
					tayfaVer=''
                }
    fi
fi
fi
ipPattern="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
ENTRY=$(zenity --entry --width 250 --title "ZK IT Support" --text "Bilgisayar Adı\nSıramatik Şube Kodu");
ENTRY=`echo $ENTRY | sed -e 's/^[[:space:]]*//'`
ENTRY=$(echo "$ENTRY" | tr '[:lower:]' '[:upper:]')
kAdi='root'
entryUzunluk=$(echo -n $ENTRY | wc -m) ;
case $? in
0)

if [ -z "${ENTRY//[0-9]}" ] && [ -n "$ENTRY" ]; then
ENTRY="SIRAMATIKXC$ENTRY"
degKisa="1"
degUzunluk="4"
khataText="Şube kodu 2 karakterden az olamaz, şube kodunu kontrol edin."
uhataText="Şube kodu 3 karakterden fazla olamaz, şube kodunu kontrol edin."
else
degKisa="5"
degUzunluk="26"
khataText="Bilgisayar adı 5 karakterden az olamaz, bilgisayar ismini kontrol edin."
uhataText="Bilgisayar adı 25 karakterden fazla olamaz, bilgisayar ismini kontrol edin."
fi
if [[ $entryUzunluk -lt $degKisa ]] && [[ $entryUzunluk -gt 0 ]]; then
	(zenity --error \
       --title "Hata" \
       --width 300 \
       --height 50 \
       --text "$khataText")
	ilkBas=1
	basla
elif [[ $entryUzunluk -lt $degUzunluk ]]; then
	if [[ $entryUzunluk -eq 0 ]];  then
	exit
	fi
	baglanti=$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 $kAdi@$ENTRY echo ok 2>&1)
	if [[ $baglanti == *"ok"* ]] || [[ $baglanti == *"continue"* ]]; then
		rootPass=$(((RND=RANDOM<<15|RANDOM)) ; echo ${RND: -8})
		echo $rootPass | xclip -selection clipboard
		ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
		safIP=$(ssh $kAdi@$ENTRY 'ip -o addr show up primary scope global | while read -r num dev fam addr rest; do echo ${addr%/*}; done')
		getirHostnameI=$(ssh $kAdi@$ENTRY 'hostname -i' 2>&1)
		if [[ $ENTRY =~ $ipPattern ]]; then
			getiporhostname=$(ssh $kAdi@$ENTRY 'hostname | cut -d '.' -f1' 2>&1);
			baslik=$getiporhostname" - "$ENTRY
			NXSDosyasi=$getiporhostname
		else
			getiporhostname=$(ssh $kAdi@$ENTRY 'hostname -i' 2>&1)
			baslik=$ENTRY" - "$getiporhostname
			NXSDosyasi=$ENTRY
		fi
		loginUser=$(ssh $kAdi@$ENTRY "loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print \$3}'" 2>&1)
		if [ -z "$loginUser" ];then
			kullaniciListe=""
			zenYukseklik="850"
		else
			# kullaniciPSicil=$(echo ${loginUser:2:6})
			# hamData=$(ssh root@localhost "curl 'https://zkportal.ziraatkatilim.local/rehber?combine=$loginUser&baskanlik=All' -H 'Cookie: SSESSaf2dfb1a90326621c1ec324cfda73dd9=6ohC7OdPIoiOQHsgkG-BAXgbCyXUIfRhtVgYNNMujkvrVKqO;' --compressed" 2>&1)
			# hamDataDuzen=$(echo $hamData | grep -A2 -E -m 1 '<div class="user-name">' | tail -n2 | head -n1 | sed 's/<[^>]*>//g')
			# hamDataDuzen=$(echo $hamDataDuzen | grep -oP ''$kullaniciPSicil' \K.*')
			# portalAdSoyad=$(echo $hamDataDuzen | awk -F"(" '{print $1}')
			# portalTelefon=$(echo $hamDataDuzen | awk -F")" '{print $2}' | awk -F"@" '{print $1}' | awk -F"-" '{print $2}' | cut -d\   -f2)
			# portalCepTel=$(echo $hamDataDuzen | awk -F")" '{print $2}' | awk -F"@" '{print $1}' | awk -F"-" '{print $1}' | grep -o '[[:digit:]]*')
			# portalCepTel="${portalCepTel:0:11}"
			diskVeri=$(ssh $kAdi@$ENTRY "lsblk | grep -A1 'SIZE' | sed -n '2 p'" 2>&1)
			diskAdi=$(echo $diskVeri | awk -F" " '{print $1}')
			getDisk=$(ssh $kAdi@$ENTRY "cat /sys/block/$diskAdi/queue/rotational" 2>&1)
			if [[ $getDisk -eq 0 ]]; then
				diskDurum="SSD"
			else
				diskDurum="HDD"
			fi
			kernelversion=$(ssh $kAdi@$ENTRY "uname -r" 2>&1)
			totalDisk=$(echo $diskVeri | awk -F" " '{print $4}')
			getUrun=$(ssh $kAdi@$ENTRY "sudo dmidecode -s system-version" 2>&1)
			getModel=$(ssh $kAdi@$ENTRY "sudo dmidecode -s system-product-name chassis-type" 2>&1)
			getSeri=$(ssh $kAdi@$ENTRY "sudo dmidecode -s system-serial-number" 2>&1)
			kullaniciListe="\nAktif Kullanıcı : $loginUser\nKernel Versiyonu : $kernelversion\nÜrün ve Model : $getUrun - $getModel\nSeri Numarası : $getSeri\n"
			zenYukseklik="1000"
		fi
		hostName=$(ssh $kAdi@$ENTRY 'hostname | cut -d '.' -f1' 2>&1);
		varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f4' 2>&1);
		if [ -z "$varYuzde" ]; then
		varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f5' 2>&1);
			if [ -z "$varYuzde" ]; then
			varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
			fi
		fi
		tayfaVer=$(ssh $kAdi@$ENTRY 'dpkg -s tayfa | grep -i Version | head -n 1 | cut -d ':' -f2' 2>&1);
		tayfaConf=$(ssh $kAdi@$ENTRY 'cat /usr/share/tayfa/tayfa.conf | grep -i kaptan-server-ip | cut -d '=' -f2' 2>&1);
		#varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
		
    function SIRAanaMenu() {
		title=$baslik
		items=(" 1-) NoMachine" " 2-) HTop" " 3-) SSH" " 4-) GPUpdate" " 5-) Var Disk Temizle" " 6-) DistClient Servisini Durdur" " 7-) DistClient Servisini Başlat" " 8-) UPDD Console Aç" " 9-) Kalibrasyon Ekranını Aç" " 10-) Dokunmatik Test Ekranını Aç" " 11-) Filezilla" " 12-) 8021x Sertifikası Yükle" " ----------------- " " Yeni Bilgisayar ") 
		prompt=$kAdi
		while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\n\nDisk : $diskDurum - $totalDisk\n\nRoot Şifre : $rootPass\n" --list --column="Seçenekler" "${items[@]}" --width=500 --height=600)
		do
		    case "$item" in
			"${items[0]}")
				SIRAanaMenu & disown
				#ssh $kAdi@pardus || echo "yes" 'passwd'
				#sshpass -p 1 ssh $kAdi@pardus 
				# NomachineSiramatikPW=$(perl $calismaYolu/noMachinePwGenerator.pl $rootPass)
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				dosyaK=($HOME/$NomachineNXSYol/NoMachine/*.nxs)
				dosyaK2=($HOME/$NomachineNXSYol/NoMachine/*.recover)
				if [[ -f ${dosyaK[0]} ]]; then
					rm $HOME/$NomachineNXSYol/NoMachine/*.nxs
				else
					if [[ -f ${dosyaK2[0]} ]]; then
					rm $HOME/$NomachineNXSYol/NoMachine/*.recover
					fi
				fi
                #SIRAMATIK NOMACHINE TANIMI BASLANGIC
				{
				echo '<!DOCTYPE NXClientSettings>'
				echo '<NXClientSettings version="2.1" application="nxclient" >'
				echo '<group name="General" >'
				echo  '<option key="Connection service" value="nx" />'
				echo   '<option key="Server host" value="'$ENTRY'" />'
				echo   '<option key="Server port" value="22" />'
				echo   '<option key="Show remote display resize message" value="false" />'
				echo   '<option key="Show remote desktop view mode message" value="false" />'
				echo   '<option key="Try to wake up server when it is powered off" value="true" />'
				echo   '<option key="View a specific monitor among available monitors" value="-1" />'
				echo  '</group>'
				echo   '<group name="Login" >'
				echo   '<option key="Always use selected user login" value="true" />'
				echo   '<option key="User" value="siramatik" />'
				echo   '<option key="Last selected user login" value="system user" />'
				echo   '<option key="Server authentication method" value="system" />'
				echo   '<option key="System login method" value="password" />'
				echo   '<option key="Auth" value="0qlgbuhgfTUTMEE;55(##rppjYUYKNJ*${v2" />'
				echo  '</group>'
				echo '</NXClientSettings>' 
				} >> $HOME/$NomachineNXSYol/NoMachine/$NXSDosyasi.nxs
                #SIRAMATIK NOMACHINE TANIMI BITIS

				chmod 777 $HOME/$NomachineNXSYol/NoMachine/$NXSDosyasi.nxs
				/usr/NX/bin/nxplayer --session $NXSDosyasi.nxs | continue
				rm $HOME/$NomachineNXSYol/NoMachine/*.nxs
				rm $HOME/$NomachineNXSYol/NoMachine/*.recover
				exit
			;;
			
			"${items[1]}")
				function htopKontrol() {
				durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -l htop' 2>&1);
				if [[ $durum == *"no packages"* ]]; then
				    varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
					if [[ $varYuzde == *"100"* ]];then
					zenity --info --title "Hata" --text="Var alanı dolu olduğundan htop uygulaması yüklenemedi, var alanını temizleyin." --width=300
					SIRAanaMenu & disown
					exit
					else
					ssh $kAdi@$ENTRY 'dpkg --configure -a'
					gnome-terminal --title=HtopInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install htop -y'
					fi
				function HtopInstall(){
					xprop -name "HtopInstall-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
					htopKontrol
					else
					sleep 5
					HtopInstall
					fi
					}
				sleep 1	
				HtopInstall
				elif [[ $durum == *"Unable to locate package"* ]]; then
					zenity --info --title "Hata" --text="Htop uygulaması yüklenemedi" --width=250
				elif [[ $durum == *"dpkg --configure"* ]]; then
				    ssh $kAdi@$ENTRY 'dpkg --configure -a'
				    htopKontrol
				else
				  gnome-terminal --title=$ENTRY -- ssh $kAdi@$ENTRY -t 'htop'
				  function htopMenu(){
						title=$baslik
						items=(" 1-) SWAP Genislet" " 2-) MEM Temizle" " ------------------ " " Bir Önceki Ekrana Dön") 
						prompt=$kAdi
						while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\n\nRoot Şifre : $rootPass\n" --list \
							       --column="HTOP Seçenekler" "${items[@]}" --width=500 --height=600)
						do
						    case "$item" in
							"${items[0]}") 
								hPid=$(ssh $kAdi@$ENTRY 'pidof htop' 2>&1);
								#hPid=$(pidof htop)
								hUzunluk=$(echo -n $hPid | wc -m) ;
								if [[ "$hUzunluk" -ne 0 ]]; then
								export hhPid="$hPid"
								echo $hhPid
								ssh $kAdi@$ENTRY -t -o SendEnv=hhPid <<-'ENDSSH'
								pkill -f htop
								kill -SIGKILL $hhPid
								ENDSSH
								fi

								#SWAP_INCRASE dosyasını uzak pc ye kopyalıyor - Baslangıc
								#scp /media/Birimlerarasi/Pardus_Betik/swap_increase_home.sh $kAdi@$ENTRY:/home/swapincrease.sh
								#ssh $kAdi@$ENTRY 'bash /home/swapincrease.sh'
								#sleep 5
									zenity --info --title "İşlem Sürüyor" --text="SWAP incrase işlemi arka planda yapılıyor. Lütfen Bekleyin..." --width=250 & disown
									ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
									# var altında bir dosya oluşturup dd komutu ile boyutunu set ederek swap alanı gibi kullanılır.
									cd /home/
									sudo touch .swapfile
									sudo chmod 600 .swapfile
									# bs'ye girilen değer boyutu belirtir. count'a girilen değer GB(1000) mı GİB(1024) mı onu belirtir.
									#sudo dd if=/dev/zero of=/home/.swapfile bs=8192k count=1024
									sudo dd if=/dev/zero of=/home/.swapfile bs=4096k count=1024
									sudo mkswap /home/.swapfile
									sudo swapon /home/.swapfile
									echo "/home/.swapfile none  swap  sw  0 0" | sudo tee -a /etc/fstab
									sudo swapon -a

									sudo swapon --show
									ENDSSH

								#SWAP_INCRASE dosyasını uzak pc ye kopyalıyor - Bitis
								
								gnome-terminal -- ssh $kAdi@$ENTRY -t 'htop'
							;;
							
							"${items[1]}") 
								
							;;

							"${items[2]}") 
								
							;;
							
							"${items[3]}") 
							ilkBas=0
							basla
							;;
							1) exit ;;
							*) exit ;;
						    esac
						    #break
						done
				  }
				 htopMenu 
				fi
				}
				htopKontrol
				exit
			;;
			
			"${items[2]}")
			    gnome-terminal -- ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new
			;;
			"${items[3]}")
				SIRAanaMenu & disown
				#zenity --info --title "Bilgi" --text="GPUPdate işlemi yapılıyor. Lütfen bekleyin..." --width=250 & disown
				siragpSay=0
				ssh $kAdi@$ENTRY -t 'systemctl restart rsyslog' & disown
				gnome-terminal --title=Journal-$ENTRY -- ssh $kAdi@$ENTRY -t "journalctl -u tayfa.service -f"
				gnome-terminal --title=Tail-$ENTRY -- ssh $kAdi@$ENTRY -t "tail -f /var/log/syslog | grep tayfa"
				function gpKontrol(){	
				gpdurum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'gpupdate -u siramatik' 2>&1);
				if [[ $gpdurum == *"Unable to communicate"* ]] && [[ $siragpSay == 0 ]] || [[ $tayfaConf != $siraKaptanIP ]]; then
					if [ $tayfaConf != $kaptanTestSIP ]; then
						if [ $tayfaConf != $siraKaptanIP ]; then
							#ssh $kAdi@$ENTRY -t "systemctl stop tayfa.service"
							ssh $kAdi@$ENTRY -t "sed -i 's/'$tayfaConf'/'$siraKaptanIP'/' /usr/share/tayfa/tayfa.conf"
						fi
					fi	
					ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					rm /usr/share/tayfa/database/token
					rm /usr/share/tayfa/database/store
					sleep 1
					systemctl restart tayfa
					ENDSSH
					# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					# rm -rf /usr/share/tayfa/database/token
					# rm -rf /usr/share/tayfa/database/store
					# sleep 1
					# systemctl restart tayfa
					# ENDSSH
					sleep 5
					siragpSay=1
					gpKontrol
				else
					if [[ $gpdurum == *"Unable to communicate"* ]] && [[ $siragpSay == 1 ]]; then
					zenity --warning --title "Hata" --text="GPUPdate işlemi yapılamıyor. Manuel kontrol sağlayın" --width=250 & disown
					else
					exit
					fi
				#gnome-terminal -- ssh $kAdi@$ENTRY -t "gpupdate -u siramatik"
				fi
				#gnome-terminal -- ssh $kAdi@$ENTRY -t "tail -f /var/log/syslog | grep tayfa"
				}
				gpKontrol
				exit
			;;
			"${items[4]}")
				if zenity --question --title "Var Alanı Temizle" --text="Var alanını temizlemek istiyor musunuz?" --width=200 
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				rm -rf /var/log/messages*
				rm -rf /var/log/user*
				rm -rf /var/log/syslog*
				echo -e "Var loglar silindi."
				sleep 2
				touch /var/log/messages
				touch /var/log/user.log
				touch /var/log/syslog
				echo -e "Var log bölümleri tekrar oluşturuldu"
				ENDSSH
				else
				SIRAanaMenu & disown
				exit
				fi
				
				#zenity --notification --text "Var Alanı Temizlendi"
				varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f4' 2>&1);
				if [ -z "$varYuzde" ]; then
				varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f5' 2>&1);
					if [ -z "$varYuzde" ]; then
					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
					fi
				fi
				if zenity --question --title "İşlem Başarılı" --text="Var alanını temizlendi\nBilgisayarı yeniden başlatmak istiyor musunuz?" --width=300
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				reboot
				ENDSSH
				zenity --info --title "İşlem başarılı" --text="$ENTRY - Var alanı temizlenip bilgisayar yeniden başlatıldığından\ntekrardan bağlanmanız gerekmektedir." --width=300
				ilkBas=1
				ENTRY=""
				basla
				else
				SIRAanaMenu & disown
				exit
				fi
			;;
			"${items[5]}")
				SIRAanaMenu & disown
				gnome-terminal --title=DistClientStop-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user stop distclient.service'
				function DistStop(){
					xprop -name "DistClientStop-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					zenity --info --title "İşlem başarılı" --text="DistClient Servisi Durduruldu" --width=250
					else
					sleep 5
					DistStop
					fi
					}
				sleep 1
				DistStop
				exit
			;;

			"${items[6]}")
				SIRAanaMenu & disown
				gnome-terminal --title=DistClientStart-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user start distclient.service'
				function DistStart(){
					xprop -name "DistClientStart-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					zenity --info --title "İşlem başarılı" --text="DistClient Servisi Tekrar Başlatıldı" --width=250
					else
					sleep 5
					DistStart
					fi
					}
				sleep 1
				DistStart
				exit
			;;

			"${items[7]}")
				SIRAanaMenu & disown
				gnome-terminal --title=DistClientStopAfterUPDDConsole-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user stop distclient.service'
				function DistStop(){
					xprop -name "DistClientStopAfterUPDDConsole-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					ssh siramatik@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
						systemctl restart updd.service
						cd /opt/updd/
						./upddenv bash
						export DISPLAY=:0
						./upddenv ./UPDD\ Console
					ENDSSH
					else
					sleep 5
					DistStop
					fi
					}
				sleep 1
				DistStop
				exit
			;;

			"${items[8]}")
				SIRAanaMenu & disown
				gnome-terminal --title=DistClientKalibreStop-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user stop distclient.service'
				function DistKStop(){
			 		xprop -name "DistClientKalibreStop-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					zenity --info --title "Bilgilendirme" --text="Güvenliği arayıp gelen ekranda noktalara uzun süre basılı tutturarak kalibre tamamlanır.\nKalibre işlemi bitince ekrandan çıkınca DistClient servisi otomatik başlatılır." --width=500 & disown
					#ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					ssh siramatik@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					cd /opt/updd/
					./upddenv bash
					./upddutils set active_touch_interface xtouch
					export DISPLAY=:0
					./upddenv ./UPDD\ Calibrate
					ENDSSH
					#gnome-terminal --title=DistClientStartafterCalibre-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user start distclient.service'
			 			function DistStartAfterCalibre(){
							xprop -name "DistClientStartafterCalibre-$ENTRY" _NET_WM_PID
							if [ $? != 0 ];then
								if zenity --question --title "İşlem Başarılı" --text="Kalibrasyon yapıldı mı?\nEvet dediğinz de Sıramatik yeniden başlatılacak.\nHayır derseniz tekrar kalibrasyon ekranını açmanız gerekecek" --width=400
								then
								ssh siramatik@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
								cd dokunmatik/
								sudo ./install
								sudo reboot
								ENDSSH
								zenity --info --title "İşlem başarılı" --text="Kalibrasyon yapıldı ve sıramatik yeniden başlatıldı." --width=300
								ilkBas=1
								ENTRY=""
								basla
								else
								exit
								fi
			 				else
			 				sleep 3
			 				DistStartAfterCalibre
			 				fi
			 				}
			 			sleep 1
			 			DistStartAfterCalibre
					#zenity --info --title "İşlem başarılı" --text="Kalibrasyon yapıldı ve DistClient Servisi Tekrar Başlatıldı" --width=250
					else
					sleep 2
			 		DistKStop
					fi
				}
				sleep 1
				DistKStop
			 	exit
			;;

			# "${items[7]}")  -->> Otomatik Kalibrasyon
			# SIRAanaMenu & disown
			# 	gnome-terminal --title=DistClientKalibreStop -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user stop distclient.service'
			# 	function DistKStop(){
			# 		xprop -name "DistClientKalibreStop" _NET_WM_PID
			# 		if [ $? != 0 ];then
			# 		ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
			# 		cd /opt/updd/
			#      	./upddenv ./upddutils set calibration_margin 10
			# 		./upddenv ./upddutils set calibration_points 4
			# 		./upddenv ./upddutils set calx0 435
			# 		./upddenv ./upddutils set calx1 1560
			# 		./upddenv ./upddutils set calx2 432
			# 		./upddenv ./upddutils set calx3 1560
			# 		./upddenv ./upddutils set caly0 650
			# 		./upddenv ./upddutils set caly1 648
			# 		./upddenv ./upddutils set caly2 1368
			# 		./upddenv ./upddutils set caly3 1374
			# 		ENDSSH
			# 		gnome-terminal --title=DistClientStartafterCalibre -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user start distclient.service'
			# 			function DistStartAfterCalibre(){
			# 				xprop -name "DistClientStartafterCalibre" _NET_WM_PID
			# 				if [ $? != 0 ];then
			# 				zenity --info --title "İşlem başarılı" --text="Kalibrasyon yapıldı ve DistClient Servisi Tekrar Başlatıldı" --width=250
			# 				else
			# 				sleep 5
			# 				DistStartAfterCalibre
			# 				fi
			# 				}
			# 			sleep 1
			# 			DistStartAfterCalibre
			# 			exit
			# 		else
			# 		sleep 5
			# 		DistKStop
			# 		fi
			# 		}
			# 	sleep 1
			# 	DistKStop
			# 	exit
			# ;;

			#./upddutils setdefault "*" active_touch_interface mouse
			"${items[9]}")
				SIRAanaMenu & disown
				gnome-terminal --title=DistClientKalibreStop-$ENTRY -- ssh $kAdi@$ENTRY 'sudo -u siramatik XDG_RUNTIME_DIR="/run/user/$(id -u siramatik)" systemctl --user stop distclient.service'
				function DistKStop(){
			 		xprop -name "DistClientKalibreStop-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					#ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					ssh siramatik@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					cd /opt/updd/
					./upddenv bash
					./upddutils set active_touch_interface xtouch
					export DISPLAY=:0
					./upddenv ./UPDD\ Test
					ENDSSH
					else
					sleep 2
			 		DistKStop
					fi
				}
				sleep 1
				DistKStop
			 	exit
			;;

			"${items[10]}")
				SIRAanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				#gnome-terminal -- filezilla sftp://root:$rootPass@$ENTRY
				filezilla sftp://root:$rootPass@$ENTRY
				exit
			;;

			"${items[11]}")
				SIRAanaMenu & disown
				gnome-terminal --title=802KontrolEtBaslamadanOnce-$ENTRY --geometry=100x50 -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'getcert list && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
				if zenity --question --title "8021x Sertifikası Yüklensin mi?" --text="Açılan uç birimde gerekli kotnroller sonrası\n8021x sertifikası yükleme ihtiyacı var ise evet'e basın.\nHayır denildiğinde hiçbir işlem yapmadan süreç sonlanacaktır." --width=400
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				gnome-terminal --title=802RCopy-$ENTRY -- scp $sekizRemYol $kAdi@$ENTRY:/home/8021xremove.sh
				function 802RKopy(){
					xprop -name "802RCopy-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=802Remove-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash -x /home/8021xremove.sh'
						function 802Remove(){
							xprop -name "802Remove-$ENTRY" _NET_WM_PID
							if [ $? != 0 ];then
								gnome-terminal --title=802Copy-$ENTRY -- scp $sekizYol $kAdi@$ENTRY:/home/8021.sh
								function 802Kopy(){
									xprop -name "802Copy-$ENTRY" _NET_WM_PID
									if [ $? != 0 ];then
										gnome-terminal --title=802Install-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /home/8021.sh'"; exec bash -i"
										#gnome-terminal --title=802Install-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash /home/8021.sh'
										function 802Bas(){
										xprop -name "802Install-$ENTRY" _NET_WM_PID
										if [ $? != 0 ];then
										zenity --info --title "İşlem başarılı" --text="8021X Sertifikası Yüklendi." --width=250
										z=0
										function tekrarBasKontrol(){
											tekBagKontrol=$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 $kAdi@$ENTRY echo ok 2>&1)
											if [[ $tekBagKontrol == *"ok"* ]] || [[ $tekBagKontrol == *"continue"* ]]; then
													gnome-terminal --title=802KontrolBasladıktanSonra-$ENTRY --geometry=100x50 -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'getcert list && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
													# gnome-terminal --title=802KontrolBasladıktanSonra-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
											else
												if [ $z == 20 ] ; then
													exit
												else
													z=$((z+1))
													sleep 3
													tekrarBasKontrol
												fi
											fi
											}
											sleep 5
											tekrarBasKontrol
										else
										sleep 2
										802Bas
										fi
										}
										sleep 1
										802Bas
									else
									sleep 5
									802Kopy
									fi
									}
								sleep 1
								802Kopy
							else
							sleep 5
							802Remove
							fi
						}
					sleep 1
					802Remove
					else
					sleep 5
					802RKopy
					fi
				}
				sleep 1
			    802RKopy
				exit
				else
				exit
				fi	
			;;

			"${items[12]}")
				ilkBas=0
				basla
				# SIRAanaMenu & disown
				# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				# echo $rootPass | xclip -selection clipboard
				# gnome-terminal -- filezilla sftp://root:$rootPass@$ENTRY
				# exit
			;;
			
			"${items[13]}")
				ilkBas=1
                baglanti=""
				ENTRY=""
				basla
			;;
			
			1) exit ;;
			*) exit ;;
		    esac
		    #break
		done
	
	}


	function PCanaMenu() {
		
		title=$baslik
		items=(" 1-) NoMachine" " 2-) Filezilla" " 3-) Htop" " 4-) SSH" " 5-) Yazıcı Tanımla" " 6-) Tarayıcı Kur" " 7-) 802.1x Sertifikası Yükle" " 8-) Basit Tarama Donuyorsa (XSane Ayarı)" " 9-) GPUpdate" " 10-) NanoDems Kamera Kur" " 11-) Geyve 3.2.9 Servisini Yeniden Kur" " 12-) Var Alanını Temizle" " 13-) NanoDems VLC Plugini" " 14-) ArkSigner 2.3.9 Kur" " 15-) İmzager 2.7.2 Kur" " 16-) Akis (Tubitak) 2.0 Kur" " 17-) DsClient Yükle" " 18-) Chrome Geçmiş Temizle" " 19-) PDF Görüntüleyicisini Chromium Yap" " 20-) Alt+Tab Ayarla" " 21-) Alsa Mixer Ses Ayarla" " 22-) Geyve Restart Kısayol Oluştur" " ------------------------------------------- " " Yeni Bilgisayar ") 
		prompt=$kAdi
		while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\nDisk : $diskDurum - $totalDisk\n$kullaniciListe\nRoot Şifre : $rootPass\n" --list --column="Seçenekler" "${items[@]}" --width=500 --height=$zenYukseklik)
		do
		    case "$item" in
			"${items[0]}")
				PCanaMenu & disown
				#ssh $kAdi@pardus || echo "yes" 'passwd'
				#sshpass -p 1 ssh $kAdi@pardus
				echo $rootPass | xclip -selection clipboard
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				NomachinePCPW=$(perl $calismaYolu/noMachinePwGenerator.pl $rootPass)
				dosyaK=($HOME/$NomachineNXSYol/NoMachine/*.nxs)
				dosyaK2=($HOME/$NomachineNXSYol/NoMachine/*.recover)
				if [[ -f ${dosyaK[0]} ]]; then
					rm $HOME/$NomachineNXSYol/NoMachine/*.nxs
				else
					if [[ -f ${dosyaK2[0]} ]]; then
					rm $HOME/$NomachineNXSYol/NoMachine/*.recover
					fi
				fi
				{ 
				echo '<!DOCTYPE NXClientSettings>'
				echo '<NXClientSettings version="2.1" application="nxclient" >'
				echo '<group name="General" >'
				echo  '<option key="Connection service" value="nx" />'
				echo   '<option key="Server host" value="'$ENTRY'" />'
				echo   '<option key="Server port" value="22" />'
				echo   '<option key="Show remote display resize message" value="false" />'
				echo   '<option key="Show remote desktop view mode message" value="false" />'
				echo   '<option key="Try to wake up server when it is powered off" value="true" />'
				echo   '<option key="View a specific monitor among available monitors" value="-1" />'
				echo  '</group>'
				echo   '<group name="Login" >'
				echo   '<option key="Always use selected user login" value="true" />'
				echo   '<option key="User" value="root" />'
				echo   '<option key="Last selected user login" value="system user" />'
				echo   '<option key="Server authentication method" value="system" />'
				echo   '<option key="System login method" value="password" />'
				echo   '<option key="Auth" value="'$NomachinePCPW'" />'
				echo  '</group>'
				echo '</NXClientSettings>' 
				} >> $HOME/$NomachineNXSYol/NoMachine/$NXSDosyasi.nxs
				
				chmod 777 $HOME/$NomachineNXSYol/NoMachine/$NXSDosyasi.nxs
				/usr/NX/bin/nxplayer --session $NXSDosyasi.nxs | continue
				rm $HOME/$NomachineNXSYol/NoMachine/*.nxs
				rm $HOME/$NomachineNXSYol/NoMachine/*.recover
				exit
			;;
			
			"${items[1]}")
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				#gnome-terminal -- filezilla sftp://$kAdi:$rootPass@$ENTRY
				filezilla sftp://$kAdi:$rootPass@$ENTRY
				exit
			;;
			
			"${items[2]}")
				function htopKontrolPC() {
				durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -l htop' 2>&1);
				if [[ $durum == *"no packages"* ]]; then
					varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
					echo $varYuzde
					if [[ $varYuzde == *"100"* ]];then
					zenity --info --title "Hata" --text="Var alanı dolu olduğundan htop uygulaması yüklenemedi, var alanını temizleyin." --width=300
					PCanaMenu & disown
					exit
					else
					ssh $kAdi@$ENTRY 'dpkg --configure -a'
					gnome-terminal --title=HtopInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install htop -y'
					fi
				function HtopInstall(){
					xprop -name "HtopInstall-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
					htopKontrolPC
					else
					sleep 5
					HtopInstall
					fi
					}
				sleep 1
				HtopInstall
				elif [[ $durum == *"Unable to locate package"* ]]; then
				zenity --info --title "Hata" --text="Htop uygulaması yüklenemedi" --width=250
				elif [[ $durum == *"dpkg --configure"* ]]; then
				    ssh $kAdi@$ENTRY 'dpkg --configure -a'
				    htopKontrol
				else
				  gnome-terminal --title=$ENTRY -- ssh $kAdi@$ENTRY -t 'htop'
				  function htopMenu(){
						title=$baslik
						items=(" 1-) SWAP Genislet" " 2-) MEM Temizle" " ------------------ " " Bir Önceki Ekrana Dön") 
						prompt=$kAdi
						while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\n$kullaniciListe\nRoot Şifre : $rootPass\n" --list \
							       --column="HTOP Seçenekler" "${items[@]}" --width=500 --height=600)
						do
						    case "$item" in
							"${items[0]}") 
								hPid=$(ssh $kAdi@$ENTRY 'pidof htop' 2>&1);
								#hPid=$(pidof htop)
								hUzunluk=$(echo -n $hPid | wc -m) ;
								if [[ "$hUzunluk" -ne 0 ]]; then
								export hhPid="$hPid"
								echo $hhPid
								ssh $kAdi@$ENTRY -t -o SendEnv=hhPid <<-'ENDSSH'
								pkill -f htop
								kill -SIGKILL $hhPid
								ENDSSH
								fi

								#SWAP_INCRASE dosyasını uzak pc ye kopyalıyor - Baslangıc
								#scp /media/Birimlerarasi/Pardus_Betik/swap_increase_home.sh $kAdi@$ENTRY:/home/swapincrease.sh
								#ssh $kAdi@$ENTRY 'bash /home/swapincrease.sh'
								#sleep 5
									zenity --info --title "İşlem Sürüyor" --text="SWAP incrase işlemi arka planda yapılıyor. Lütfen Bekleyin..." --width=250 & disown
									ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
									# var altında bir dosya oluşturup dd komutu ile boyutunu set ederek swap alanı gibi kullanılır.
									cd /home/
									sudo touch .swapfile
									sudo chmod 600 .swapfile
									# bs'ye girilen değer boyutu belirtir. count'a girilen değer GB(1000) mı GİB(1024) mı onu belirtir.
									#sudo dd if=/dev/zero of=/home/.swapfile bs=8192k count=1024
									sudo dd if=/dev/zero of=/home/.swapfile bs=4096k count=1024
									sudo mkswap /home/.swapfile
									sudo swapon /home/.swapfile
									echo "/home/.swapfile none  swap  sw  0 0" | sudo tee -a /etc/fstab
									sudo swapon -a

									sudo swapon --show
									ENDSSH

								#SWAP_INCRASE dosyasını uzak pc ye kopyalıyor - Bitis
								
								
								gnome-terminal -- ssh $kAdi@$ENTRY -t 'htop'
							;;
							
							"${items[1]}") 
								
							;;

							"${items[2]}") 
								
							;;
							
							"${items[3]}") 
							ilkBas=0
							basla
							;;
							1) exit ;;
							*) exit ;;
						    esac
						    #break
						done
				  }
				 htopMenu 
				fi
				}
				htopKontrolPC
				exit
			;;
			"${items[3]}")
				gnome-terminal -- ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new
			;;
			"${items[4]}")

				function yazTanim(){
				#gnome-terminal -- ssh $kAdi@$ENTRY -t "lpstat -v"
				gnome-terminal --title=$ENTRY -- bash -c "ssh $kAdi@$ENTRY -t 'sudo apt-get install -y openprinting-ppds'"
				gnome-terminal --title=$ENTRY -- bash -c "ssh $kAdi@$ENTRY -t "'lpstat -v'"; exec bash -i"
				#b=0
				#for yazList in `ssh $kAdi@$ENTRY lpstat -v`; do
				#var[$b]="$yazList";
				#b=$(($b+1));
				#done

				#for (( i=0; i<$b; i++ ));
				#do
				#declare "yazAd"="${var[$i+2]}"
				#declare "yazTanim"="${var[i+3]}"
				#i=$(($i+2));
				#echo $yazAd - $yazTanim
				#done

				#zenity --info --title "adad" --text="$yazAd - $yazAd\n" --width=250

				#ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				#yes 1 | passwd root
				#ENDSSH
				WAITFOR=1
				TIMES=1
				yazIP=$(ssh $kAdi@$ENTRY 'hostname -I | cut -d '.' -f1-3' 2>&1);
				yazIP=`echo $yazIP | sed -e 's/^[[:space:]]*//'`
				opYaz=$yazIP.40
				grYaz=$yazIP.41
				title=$baslik
				items=(" 1-) Dekont Yazıcı" " 2-) Operasyon Yazıcısı" " 3-) Girişimci Yazıcısı" " 4-) Her İki Yazıcıyıda Ekle" " 5-) Operasyon Yazıcısı - 40 (Samsung)" " 6-) Operasyon Yazıcısı - 40 (Epson)" " 7-) Girişimci Yazıcısı - 41 (Samsung)" " 8-) Girişimci Yazıcısı - 41 (Epson)" " 9-) Tarayıcı Üzerinden Tanımla" " 10-) Geri") 
				prompt=$kAdi
				while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\n$kullaniciListe\nRoot Şifre : $rootPass\n" --list \
							       --column="Yazıcı Seçenekler" "${items[@]}" --width=500 --height=600)
						do
						    case "$item" in
							"${items[0]}") 
								#yazTanim & disown
								function dekontTanim() {
									
								dekENTRY=$(zenity --entry --width 250 --title "Dekont Yazıcı" --text "Tanım Yapılacak İsmi Giriniz");
								dekENTRY=`echo $dekENTRY | sed -e 's/^[[:space:]]*//'`
								dekENTRY=$(echo "$dekENTRY" | tr '[:lower:]' '[:upper:]')
								dekentryUzunluk=$(echo -n $dekENTRY | wc -m) ;


								if [[ $dekentryUzunluk -lt 4 ]] && [[ $dekentryUzunluk -gt 0 ]]; then
									(zenity --error \
									--title "Hata" \
									--width 300 \
									--height 50 \
									--text "Dekont yazıcı ismi 4 karaterden kısa olamaz")
									dekontTanim
								elif [[ $dekentryUzunluk -lt 20 ]]; then
									if [[ $dekentryUzunluk -eq 0 ]];  then
									exit
									fi

									dekVarmi=$(ssh $kAdi@$ENTRY 'lpstat -p | grep '$dekENTRY'' 2>&1);
									if [[ $dekVarmi == *"printer"* ]]; then
									dekonticiTanim
									else
									ssh $kAdi@$ENTRY 'cancel -a -x'
									ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS0?baud=9600+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
									zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 0 - 9600 ayarları ile tanımlandı" --width=250
									fi
									

										function dekonticiTanim() {
										title="$ENTRY - $dekENTRY"
										items=(" 0-) Test Sayfası Gönder" " 1-) $dekENTRY - Port 0 - 9600 - ttyS0" " 2-) $dekENTRY - Port 1 - 9600 - ttyS1" " 3-) $dekENTRY - Port 2 - 9600 - ttyS2" " 4-) $dekENTRY - Port 0 - 19200 - ttyS0" " 5-) $dekENTRY - Port 1 - 19200 - ttyS1" " 6-) $dekENTRY - Port 2 - 19200 - ttyS2" " 7-) $dekENTRY - Port 0 - 9600 - ttyUSB0 " " 8-) Tarayıcı Üzerinden Tanımla" " 9-) Yazıcı İsmi Değiştir" " 10-) Geri") 
										prompt=$kAdi
										while item=$(zenity --title="$title" --text="Tayfa Sürümü : $tayfaVer\nTayfa Config    :  $tayfaConf\nVar Disk Alanı :  $varYuzde\n\nRoot Şifre : $rootPass\n" --list \
														--column="Yazıcı Seçenekler" "${items[@]}" --width=500 --height=600)
										do
											case "$item" in
											"${items[0]}") 
												ssh $kAdi@$ENTRY 'lpr -P '$dekENTRY' /usr/share/cups/data/testprint'
											;;

											"${items[1]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS0?baud=9600+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 0 - 9600 - ttyS0 ayarları ile güncellendi" --width=250
											;;
											
											"${items[2]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS1?baud=9600+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 1 - 9600 - ttyS1 ayarları ile güncellendi" --width=250
											;;

											"${items[3]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS2?baud=9600+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 2 - 9600 - ttyS2 ayarları ile güncellendi" --width=250
											;;

											"${items[4]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS0?baud=19200+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 0 - 19200 - ttyS0 ayarları ile güncellendi" --width=250
											;;

											"${items[5]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS1?baud=19200+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 1 - 19200 - ttyS1 yarları ile güncellendi" --width=250
											;;

											"${items[6]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyS2?baud=19200+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 2 - 19200 - ttyS2 ayarları ile güncellendi" --width=250
											;;

											"${items[7]}") 
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p '$dekENTRY' -o PageSize=A4 -E -v serial:/dev/ttyUSB0?baud=9600+bits=8+parity=even -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Generic-IBM-Compatible_Dot_Matrix_Printer-ibmpro.ppd'
												zenity --info --title "İşlem başarılı" --text="Dekont yazısıcı $dekENTRY - Port 0 - 9600 - ttyUSB0 ayarları ile güncellendi" --width=250
												
											;;

											"${items[8]}") 
											dekonticiTanim & disown
											#ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
											#yes 1 | passwd root
											#ENDSSH
											#/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'
											#ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
											#pcIP=$(ssh $kAdi@$ENTRY -t 'ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'');
											##->pcIP=$(ssh $kAdi@$ENTRY 'hostname -I' 2>&1);
											##->pcIP=`echo $pcIP | sed -e 's/^[[:space:]]*//'`
											a=0
											for ipList in `ssh $kAdi@$ENTRY hostname -I`; do
												var[$a]="$ipList";
												a=$(($a+1));
											done
											pcIP=`echo ${var[0]} | sed -e 's/^[[:space:]]*//'`
											#echo $pcIP
											#pcIP="192.168.8.129"
											#sed -i "s/pcIPsi/"$pcIP":631/g" cupsd_deg.conf
											SCRIPTSRC=`readlink -f "$0" || echo "$0"`
											RUN_PATH=`dirname "${SCRIPTSRC}" || echo .`
											awk '{sub(/pcIPsi/,"'$pcIP':631")}1' ${RUN_PATH}/cupsd_deg.conf > $HOME/Masaüstü/cupsd_$USER$ENTRY.conf
											#echo -e "123\n" | sudo -S cp /home/pardus/Masaüstü/cupsd_$USER$ENTRY.conf  /etc/cups/cupsd.conf
											scp $HOME/Masaüstü/cupsd_$USER$ENTRY.conf $kAdi@$ENTRY:/etc/cups/cupsd.conf
											ssh $kAdi@$ENTRY -t sudo /etc/init.d/cups restart
											gnome-terminal --quiet -- firefox $pcIP:631/admin
											function fKontrol(){
											PROCESS_NAME=firefox-esr
											fPid=$(pidof $PROCESS_NAME)
											entryUzunluk=$(echo -n $fPid | wc -m) ;
											while [ "$entryUzunluk" -ne 0 ]; do
											sleep 1
											fKontrol
											done
											}
											fKontrol
											#while [ TRUE ]
											#do
												#if [ -n "$(find /home/user/.mozilla/firefox/XXXXXXX.default/places.sqlite -mmin -10)" ]
												#then
													#sudo cp /home/pardus/Masaüstü/cupsd_org.conf  /etc/cups/cupsd.conf
													#sudo /etc/init.d/cups restart
													#rm /home/pardus/Masaüstü/cupsd_$USER$ENTRY.conf
												#fi
											#done
											#sudo cp /home/pardus/Masaüstü/cupsd_org.conf  /etc/cups/cupsd.conf
											
											scp ${RUN_PATH}/cupsd_org.conf $kAdi@$ENTRY:/etc/cups/cupsd.conf
											ssh $kAdi@$ENTRY -t sudo /etc/init.d/cups restart
											rm $HOME/Masaüstü/cupsd_$USER$ENTRY.conf
											exit
											;;

											"${items[9]}")
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -x '$dekENTRY''
												dekontTanim
											;;
											
											"${items[10]}") 
											yazTanim
											;;
											1) exit ;;
											*) exit ;;
											esac
											#break
										done
										}
										dekonticiTanim

									#exit
								else
								(zenity --error \
									--title "Hata" \
									--width 300 \
									--height 50 \
									--text "Dekont yazıcı ismi boş bırakılamaz")
									dekontTanim
								fi
								}
								dekontTanim
								#serial:/dev/ttyS0?baud=9600+bits=8+parity=even
								#/usr/share/ppd
							;;
							#	YAZICI OTOMATIK MARKA BULMA VE EKLEME
							# "${items[1]}") 
							# 	varLogSay=0
							# 	function nmapKontrol() {
							# 	durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -s nmap' 2>&1);
							# 				if [[ $durum == *"not installed"* ]] || [[ $durum == *"kurulu değil"* ]] ; then
							# 					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f4' 2>&1);
							# 					if [ -z "$varYuzde" ]; then
							# 					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f5' 2>&1);
							# 						if [ -z "$varYuzde" ]; then
							# 						varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
							# 						fi
							# 					fi
							# 					varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
							# 					if [[ $varYuzde == *"100"* ]] && [[ $varLogSay = 0 ]];then
							# 						ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
							# 						rm -rf /var/log/messages*
							# 						rm -rf /var/log/user*
							# 						rm -rf /var/log/syslog*
							# 						echo -e "Var loglar silindi."
							# 						sleep 2
							# 						touch /var/log/messages
							# 						touch /var/log/user.log
							# 						touch /var/log/syslog
							# 						echo -e "Var log bölümleri tekrar oluşturuldu"
							# 						ENDSSH
							# 					#zenity --info --title "Hata" --text="Var alanı dolu olduğundan nmap uygulaması yüklenemedi/n, var alanını temizledikten sonra yazıcı eklemeyi sonra deneyin veya manuel ekleyin." --width=300
							# 					varLogSay=$(($varLogSay+1))
							# 					nmapKontrol
							# 					elif [[ $varLogSay -gt 0 ]];then
							# 					zenity --info --title "Hata" --text="Var alanı temizlenemediğinden Nmap uygulaması yüklenemedi. Manuel yazıcı eklemesi yapınız." --width=250
							# 					else
							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					gnome-terminal --title=nmapInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install nmap -y'
							# 					fi
							# 				function nmapInstall(){
							# 					xprop -name "nmapInstall-$ENTRY" _NET_WM_PID
							# 					if [ $? != 0 ];then
							# 					#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
							# 					nmapKontrol
							# 					else
							# 					sleep 5
							# 					nmapInstall
							# 					fi
							# 					}
							# 				sleep 1	
							# 				nmapInstall
							# 				elif [[ $durum == *"Unable to locate package"* ]]; then
							# 					zenity --info --title "Hata" --text="Nmap uygulaması yüklenemedi" --width=250
							# 				elif [[ $durum == *"dpkg --configure"* ]]; then
							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					nmapKontrol
							# 				else
							# 					#dekVarmi=$(ssh $kAdi@$ENTRY 'lpstat -p | grep '$dekENTRY'' 2>&1);
							# 					marka=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'nmap -sP '$opYaz' | grep 'MAC' | cut -d\   -f4' 2>&1);
							# 					marka=$(echo "$marka" | sed "s/(//")

							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					ssh $kAdi@$ENTRY 'apt-get remove nmap -y'

							# 					if [[ $marka == "Samsung" ]] ; then
							# 						{
							# 							ssh $kAdi@$ENTRY 'cancel -a -x'
							# 							ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Samsung -o PageSize=A4 -E -v socket://'$opYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
							# 							ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Samsung'
							# 							ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Samsung /usr/share/cups/data/testprint'
							# 							zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - OPERASYON yazıcısı tanımlandı" --width=250
							# 						}
							# 					elif [[ $marka == "Seiko" ]] ;then
							# 						{
							# 							ssh $kAdi@$ENTRY 'cancel -a -x'
							# 							ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Epson -o PageSize=A4 -E -v socket://'$opYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
							# 							ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Epson'
							# 							ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Epson /usr/share/cups/data/testprint'
							# 							zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - OPERASYON yazıcısı tanımlandı" --width=250
							# 						}
							# 					else
							# 						{
							# 							zenity --info --title "Hata" --text="Yazıcı markası tanımlanamadı manuel ekleyin." --width=250
							# 						}

							# 					fi
							# 				fi
							# 				}
							# 			nmapKontrol
							# ;;

							# "${items[2]}") 
							# 	varLogSay=0
							# 	function nmapKontrol() {
							# 	durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -s nmap' 2>&1);
							# 				if [[ $durum == *"not installed"* ]] || [[ $durum == *"kurulu değil"* ]] ; then
							# 					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f4' 2>&1);
							# 					if [ -z "$varYuzde" ]; then
							# 					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f5' 2>&1);
							# 						if [ -z "$varYuzde" ]; then
							# 						varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
							# 						fi
							# 					fi
							# 					varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
							# 					if [[ $varYuzde == *"100"* ]] && [[ $varLogSay = 0 ]];then
							# 						ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
							# 						rm -rf /var/log/messages*
							# 						rm -rf /var/log/user*
							# 						rm -rf /var/log/syslog*
							# 						echo -e "Var loglar silindi."
							# 						sleep 2
							# 						touch /var/log/messages
							# 						touch /var/log/user.log
							# 						touch /var/log/syslog
							# 						echo -e "Var log bölümleri tekrar oluşturuldu"
							# 						ENDSSH
							# 					#zenity --info --title "Hata" --text="Var alanı dolu olduğundan nmap uygulaması yüklenemedi/n, var alanını temizledikten sonra yazıcı eklemeyi sonra deneyin veya manuel ekleyin." --width=300
							# 					varLogSay=$(($varLogSay+1))
							# 					nmapKontrol
							# 					elif [[ $varLogSay -gt 0 ]];then
							# 					zenity --info --title "Hata" --text="Var alanı temizlenemediğinden Nmap uygulaması yüklenemedi. Manuel yazıcı eklemesi yapınız." --width=250
							# 					else
							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					gnome-terminal --title=nmapInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install nmap -y'
							# 					fi
							# 				function nmapInstall(){
							# 					xprop -name "nmapInstall-$ENTRY" _NET_WM_PID
							# 					if [ $? != 0 ];then
							# 					#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
							# 					nmapKontrol
							# 					else
							# 					sleep 5
							# 					nmapInstall
							# 					fi
							# 					}
							# 				sleep 1	
							# 				nmapInstall
							# 				elif [[ $durum == *"Unable to locate package"* ]]; then
							# 					zenity --info --title "Hata" --text="Nmap uygulaması yüklenemedi" --width=250
							# 				elif [[ $durum == *"dpkg --configure"* ]]; then
							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					nmapKontrol
							# 				else
							# 					#dekVarmi=$(ssh $kAdi@$ENTRY 'lpstat -p | grep '$dekENTRY'' 2>&1);
							# 					marka=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'nmap -sP '$grYaz' | grep 'MAC' | cut -d\   -f4' 2>&1);
							# 					marka=$(echo "$marka" | sed "s/(//")

							# 					ssh $kAdi@$ENTRY 'dpkg --configure -a'
							# 					ssh $kAdi@$ENTRY 'apt-get remove nmap -y'

							# 					if [[ $marka == "Samsung" ]] ; then
							# 						{
							# 							ssh $kAdi@$ENTRY 'cancel -a -x'
							# 							ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Samsung -o PageSize=A4 -E -v socket://'$grYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
							# 							ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Samsung'
							# 							ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Samsung /usr/share/cups/data/testprint'
							# 							zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - GIRISIMCI yazıcısı tanımlandı" --width=250
							# 						}
							# 					elif [[ $marka == "Seiko" ]] ;then
							# 						{
							# 							ssh $kAdi@$ENTRY 'cancel -a -x'
							# 							ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Epson -o PageSize=A4 -E -v socket://'$grYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
							# 							ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Epson'
							# 							ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Epson /usr/share/cups/data/testprint'
							# 							zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - GIRISIMCI yazıcısı tanımlandı" --width=250
							# 						}
							# 					else
							# 						{
							# 							zenity --info --title "Hata" --text="Yazıcı markası tanımlanamadı manuel ekleyin." --width=250
							# 						}

							# 					fi
							# 				fi
							# 				}
							# 			nmapKontrol
							# ;;

							# "${items[3]}") 
							# 	ilkBas=0
							# 	basla
							# ;;
							#	YAZICI OTOMATIK MARKA BULMA VE EKLEME

							"${items[1]}") 
								#SAMSUNG İÇİN ARALIK
								pingReturn=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "ping $opYaz -c $TIMES -i $WAITFOR" 2>&1);
								pingReturn=$?

								if [ $pingReturn -eq 0 ]; then
									# Ping Basarili
									samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
									samsung=$(echo "$samsung" | sed 's/"//')
									samsung=$(echo $samsung | cut -f1 -d '/')

									if [[ $samsung == 'sws' ]];then
									#SAMSUNG ise içeri gir  
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Samsung -o PageSize=A4 -E -v socket://'$opYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Samsung'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Samsung /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - OPERASYON yazıcısı tanımlandı" --width=250
									else
										#Değilse
										epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
										epson=$(echo $epson | cut -f1 -d '_')

										if [[ $epson == 'EPSON' ]]; then
										#EPSON ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Epson -o PageSize=A4 -E -v socket://'$opYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Epson'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Epson /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - OPERASYON yazıcısı tanımlandı" --width=250
										else
											#Değilse
											lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
											lexmark=$(echo $lexmark | cut -f1 -d '_')
											
											if [[ $lexmark == 'Lexmark' ]]; then
											#LEXMARK ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											#ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Lexmark'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Lexmark /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - OPERASYON yazıcısı tanımlandı" --width=250
											else
											zenity --info --title "Hata" --text="Operasyon yazıcı markası tanımlanamadı manuel ekleyin." --width=250
											fi
										fi
									fi
								else
									# Ping Basarisiz
									zenity --info --title "Hata" --text="Operasyon $opYaz yazıcısına ulaşılamadığından kontrol ederek manuel ekleyin." --width=250
								fi
							;;

							"${items[2]}") 
								## EPSON İÇİN ARALIK

								pingReturn=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "ping $grYaz -c $TIMES -i $WAITFOR" 2>&1);
								pingReturn=$?

								if [ $pingReturn -eq 0 ]; then
									# Ping Basarili
									epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
									epson=$(echo $epson | cut -f1 -d '_')

									if [[ $epson == 'EPSON' ]]; then
										#EPSON ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Epson -o PageSize=A4 -E -v socket://'$grYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Epson'
											ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Epson /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - GIRISIMCI yazıcısı tanımlandı" --width=250
									else
										#Değilse
										samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
										samsung=$(echo "$samsung" | sed 's/"//')
										samsung=$(echo $samsung | cut -f1 -d '/')
										if [[ $samsung == 'sws' ]];then
										#SAMSUNG ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Samsung -o PageSize=A4 -E -v socket://'$grYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Samsung'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Samsung /usr/share/cups/data/testprint'
												zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - GIRISIMCI yazıcısı tanımlandı" --width=250
										else
											lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
											lexmark=$(echo $lexmark | cut -f1 -d '_')

											if [[ $lexmark == 'Lexmark' ]]; then
											#EPSON ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												#ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Lexmark'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Lexmark /usr/share/cups/data/testprint'
												zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - GIRISIMCI yazıcısı tanımlandı" --width=250
											else
											zenity --info --title "Hata" --text="Girişimci yazıcı markası tanımlanamadı manuel ekleyin." --width=250
											fi
										fi
									fi
								else
									# Ping Basarisiz
									zenity --info --title "Hata" --text="Girişimci $grYaz yazıcısına ulaşılamadığından kontrol ederek manuel ekleyin." --width=250
								fi

							;;

							"${items[3]}")

								samsungPing=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "ping $opYaz -c $TIMES -i $WAITFOR" 2>&1);
								samsungPing=$?

								epsonPing=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "ping $grYaz -c $TIMES -i $WAITFOR" 2>&1);
								epsonPing=$?

								arrayDurum=()

								if [ $epsonPing -eq 0 ] && [ $samsungPing -eq 0 ]; then
									#OPERASYONU EKLE
										samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
										samsung=$(echo "$samsung" | sed 's/"//')
										samsung=$(echo $samsung | cut -f1 -d '/')

										if [[ $samsung == 'sws' ]];then
										#SAMSUNG ise içeri gir  
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Samsung -o PageSize=A4 -E -v socket://'$opYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Samsung'
												ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Samsung /usr/share/cups/data/testprint'
												arrayDurum+=("Samsung SCX6545 - OPERASYON yazıcısı tanımlandı\n")
												#zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - OPERASYON yazıcısı tanımlandı" --width=400
										else
											#Değilse
											epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
											epson=$(echo $epson | cut -f1 -d '_')

											if [[ $epson == 'EPSON' ]]; then
											#EPSON ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Epson -o PageSize=A4 -E -v socket://'$opYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Epson'
												ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Epson /usr/share/cups/data/testprint'
												arrayDurum+=("Epson WF-M5799 - OPERASYON yazıcısı tanımlandı\n")
												#zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - OPERASYON yazıcısı tanımlandı" --width=400
											else
												#Değilse
												lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
												lexmark=$(echo $lexmark | cut -f1 -d '_')
											
												if [[ $lexmark == 'Lexmark' ]]; then
												#LEXMARK ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												#ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Lexmark'
												ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Lexmark /usr/share/cups/data/testprint'
												arrayDurum+=("Lexmark MX532adwe - OPERASYON yazıcısı tanımlandı\n")
												#zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - OPERASYON yazıcısı tanımlandı" --width=250
											else
												#Değilse zenity hata ver
												arrayDurum+=("Operasyon yazıcı markası tanımlanamadı manuel ekleyin.\n")
											#zenity --info --title "Hata" --text="Operasyon yazıcı markası tanımlanamadı manuel ekleyin." --width=400
											fi
											fi
										fi

									#---------------------------------------------------------------------------

									#EPSON EKLE

									epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
									epson=$(echo $epson | cut -f1 -d '_')

									if [[ $epson == 'EPSON' ]]; then
										#EPSON ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Epson -o PageSize=A4 -E -v socket://'$grYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Epson'
											ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Epson /usr/share/cups/data/testprint'
											arrayDurum+=("Epson WF-M5799 - GIRISIMCI yazıcısı tanımlandı\n")
											#zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - GIRISIMCI yazıcısı tanımlandı" --width=400
									else
										#Değilse
										samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
										samsung=$(echo "$samsung" | sed 's/"//')
										samsung=$(echo $samsung | cut -f1 -d '/')
										if [[ $samsung == 'sws' ]];then
										#SAMSUNG ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Samsung -o PageSize=A4 -E -v socket://'$grYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Samsung'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Samsung /usr/share/cups/data/testprint'
												arrayDurum+=("Samsung SCX6545 - GIRISIMCI yazıcısı tanımlandı\n")
												#zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - GIRISIMCI yazıcısı tanımlandı" --width=400
										else
											lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
											lexmark=$(echo $lexmark | cut -f1 -d '_')

											if [[ $lexmark == 'Lexmark' ]]; then
											#EPSON ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												#ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Lexmark'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Lexmark /usr/share/cups/data/testprint'
												arrayDurum+=("Lexmark MX532adwe - GIRISIMCI yazıcısı tanımlandı\n")
												#zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - GIRISIMCI yazıcısı tanımlandı" --width=250
											else
										#Değilse zenity hata ver
										arrayDurum+=("Girişimci yazıcı markası tanımlanamadı manuel ekleyin.\n")
										#zenity --info --title "Hata" --text="Girişimci yazıcı markası tanımlanamadı manuel ekleyin." --width=400
										fi
										fi
									fi
									yD=""
									yD=${arrayDurum[@]}
									zenity --info --title "Bilgi" --text="$yD" --width=450

								elif [ $samsungPing -eq 0 ]; then
									samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
									samsung=$(echo "$samsung" | sed 's/"//')
									samsung=$(echo $samsung | cut -f1 -d '/')

									if [[ $samsung == 'sws' ]];then
									#SAMSUNG ise içeri gir  
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Samsung -o PageSize=A4 -E -v socket://'$opYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Samsung'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Samsung /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - OPERASYON yazıcısı tanımlandı" --width=400
									else
										#Değilse
										epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
										epson=$(echo $epson | cut -f1 -d '_')

										if [[ $epson == 'EPSON' ]]; then
										#EPSON ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Epson -o PageSize=A4 -E -v socket://'$opYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Epson'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Epson /usr/share/cups/data/testprint'
											zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - OPERASYON yazıcısı tanımlandı" --width=400
										else
										#Değilse
											lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$opYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
											lexmark=$(echo $lexmark | cut -f1 -d '_')
										
											if [[ $lexmark == 'Lexmark' ]]; then
											#LEXMARK ise içeri gir
											ssh $kAdi@$ENTRY 'cancel -a -x'
											#ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON-Lexmark -o PageSize=A4 -E -v socket://'$opYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
											ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON-Lexmark'
											ssh $kAdi@$ENTRY 'lpr -P OPERASYON-Lexmark /usr/share/cups/data/testprint'
											#zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - OPERASYON yazıcısı tanımlandı" --width=250
											else
										#Değilse zenity hata ver
										zenity --info --title "Hata" --text="Operasyon yazıcı markası tanımlanamadı manuel ekleyin." --width=400
										fi
										fi
									fi

								elif [ $epsonPing -eq 0 ]; then
										epson=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'SERVER' | cut -d\  -f2" 2>&1);
										epson=$(echo $epson | cut -f1 -d '_')

										if [[ $epson == 'EPSON' ]]; then
											#EPSON ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Epson -o PageSize=A4 -E -v socket://'$grYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Epson'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Epson /usr/share/cups/data/testprint'
												zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - GIRISIMCI yazıcısı tanımlandı" --width=400
										else
											#Değilse
											samsung=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'location' | cut -d\  -f3" 2>&1);
											samsung=$(echo "$samsung" | sed 's/"//')
											samsung=$(echo $samsung | cut -f1 -d '/')
											if [[ $samsung == 'sws' ]];then
											#SAMSUNG ise içeri gir
													ssh $kAdi@$ENTRY 'cancel -a -x'
													ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Samsung -o PageSize=A4 -E -v socket://'$grYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
													ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Samsung'
													ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Samsung /usr/share/cups/data/testprint'
													zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - GIRISIMCI yazıcısı tanımlandı" --width=400
											else
												lexmark=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "curl -I -s -L --max-redirs 5 http://'$grYaz' --insecure | grep -m 1 'Server' | cut -d\  -f2" 2>&1);
												lexmark=$(echo $lexmark | cut -f1 -d '_')

												if [[ $lexmark == 'Lexmark' ]]; then
												#Lexmark ise içeri gir
												ssh $kAdi@$ENTRY 'cancel -a -x'
												#ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Lexmark-MX510de-Postscript.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI-Lexmark -o PageSize=A4 -E -v socket://'$grYaz':9100 -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MX520_Series.ppd'
												ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI-Lexmark'
												ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI-Lexmark /usr/share/cups/data/testprint'
												#zenity --info --title "İşlem başarılı" --text="Lexmark MX532adwe - GIRISIMCI yazıcısı tanımlandı" --width=250
											else
											#Değilse zenity hata ver
											zenity --info --title "Hata" --text="Girişimci yazıcı markası tanımlanamadı manuel ekleyin." --width=400
											fi
											fi
										fi
								else

								zenity --info --title "Hata" --text="Girişimci $grYaz yazıcısı ve Operasyon $opYaz yazıcısına ulaşılamadığından kontrol ederek manuel ekleyin." --width=600

								fi
								
							;;
						
							"${items[4]}") 
								ssh $kAdi@$ENTRY 'cancel -a -x'
								ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON -o PageSize=A4 -E -v socket://'$opYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
								ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON'
								ssh $kAdi@$ENTRY 'lpr -P OPERASYON /usr/share/cups/data/testprint'
								zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - OPERASYON yazıcısı tanımlandı" --width=250
							;;

							"${items[5]}") 
								ssh $kAdi@$ENTRY 'cancel -a -x'
								ssh $kAdi@$ENTRY 'lpadmin -p OPERASYON -o PageSize=A4 -E -v socket://'$opYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
								ssh $kAdi@$ENTRY 'lpadmin -d OPERASYON'
								ssh $kAdi@$ENTRY 'lpr -P OPERASYON /usr/share/cups/data/testprint'
								zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - OPERASYON yazıcısı tanımlandı" --width=250
							;;

							"${items[6]}") 
								ssh $kAdi@$ENTRY 'cancel -a -x'
								ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI -o PageSize=A4 -E -v socket://'$grYaz':9100 -i /usr/share/ppd/Samsung_SCX-6545_Series.ppd'
								ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI'
								ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI /usr/share/cups/data/testprint'
								zenity --info --title "İşlem başarılı" --text="Samsung SCX6545 - GİRİŞİMCİ yazıcısı tanımlandı" --width=250
							;;

							"${items[7]}") 
								ssh $kAdi@$ENTRY 'cancel -a -x'
								ssh $kAdi@$ENTRY 'lpadmin -p GIRISIMCI -o PageSize=A4 -E -v socket://'$grYaz':9100 -m escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-WF-M5690_Series-epson-escpr-en.ppd'
								ssh $kAdi@$ENTRY 'lpadmin -d GIRISIMCI'
								ssh $kAdi@$ENTRY 'lpr -P GIRISIMCI /usr/share/cups/data/testprint'
								zenity --info --title "İşlem başarılı" --text="Epson WF-M5799 - GİRİŞİMCİ yazıcısı tanımlandı" --width=250
							;;

							"${items[8]}")
							yazTanim & disown
								#ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
								#yes 1 | passwd root
								#ENDSSH
								#/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'
								#ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
								#pcIP=$(ssh $kAdi@$ENTRY -t 'ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'');
								##->pcIP=$(ssh $kAdi@$ENTRY 'hostname -I' 2>&1);
								##->pcIP=`echo $pcIP | sed -e 's/^[[:space:]]*//'`
								a=0
								for ipList in `ssh $kAdi@$ENTRY hostname -I`; do
									var[$a]="$ipList";
									a=$(($a+1));
								done
								pcIP=`echo ${var[0]} | sed -e 's/^[[:space:]]*//'`
								#echo $pcIP
								#pcIP="192.168.8.129"
								#sed -i "s/pcIPsi/"$pcIP":631/g" cupsd_deg.conf
								SCRIPTSRC=`readlink -f "$0" || echo "$0"`
								RUN_PATH=`dirname "${SCRIPTSRC}" || echo .`
								awk '{sub(/pcIPsi/,"'$pcIP':631")}1' ${RUN_PATH}/cupsd_deg.conf > $HOME/Masaüstü/cupsd_$USER$ENTRY.conf
								#echo -e "123\n" | sudo -S cp /home/pardus/Masaüstü/cupsd_$USER$ENTRY.conf  /etc/cups/cupsd.conf
								scp $HOME/Masaüstü/cupsd_$USER$ENTRY.conf $kAdi@$ENTRY:/etc/cups/cupsd.conf
								ssh $kAdi@$ENTRY -t sudo /etc/init.d/cups restart
								gnome-terminal --quiet -- firefox $pcIP:631/admin
								function fKontrol(){
								PROCESS_NAME=firefox-esr
								fPid=$(pidof $PROCESS_NAME)
								entryUzunluk=$(echo -n $fPid | wc -m) ;
								while [ "$entryUzunluk" -ne 0 ]; do
								sleep 1
								fKontrol
								done
								}
								fKontrol
								#while [ TRUE ]
								#do
									#if [ -n "$(find /home/user/.mozilla/firefox/XXXXXXX.default/places.sqlite -mmin -10)" ]
									#then
										#sudo cp /home/pardus/Masaüstü/cupsd_org.conf  /etc/cups/cupsd.conf
										#sudo /etc/init.d/cups restart
										#rm /home/pardus/Masaüstü/cupsd_$USER$ENTRY.conf
									#fi
								#done
								#sudo cp /home/pardus/Masaüstü/cupsd_org.conf  /etc/cups/cupsd.conf
								
								scp ${RUN_PATH}/cupsd_org.conf $kAdi@$ENTRY:/etc/cups/cupsd.conf
								ssh $kAdi@$ENTRY -t sudo /etc/init.d/cups restart
								rm $HOME/Masaüstü/cupsd_$USER$ENTRY.conf
							exit
							;;
							
							"${items[9]}") 
							ilkBas=0
							basla
							;;
							1) exit ;;
							*) exit ;;
						    esac
						    #break
						done
				}

				
				function cupsKontrol () {
				lprDurum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'lpr -P' 2>&1);
				echo $lprDurum				
				if [[ $lprDurum == *"No such file or directory"* ]] || [[ $lprDurum == *"komutu bulunamadı"* ]] || [[ $lprDurum == *"command not found"* ]]; then
						varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
						echo $varYuzde
					if [[ $varYuzde == *"100"* ]];then
						zenity --info --title "Hata" --text="Var alanı dolu olduğundan LPR CUPSBD uygulaması yüklenemedi, var alanını temizleyin." --width=300
						PCanaMenu & disown
						exit
					else
						ssh $kAdi@$ENTRY 'sudo killall apt apt-get'
						ssh $kAdi@$ENTRY 'dpkg --configure -a'
						gnome-terminal --title=LPRInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install cups-bsd -y'
					fi
				function LPRInstall(){
						xprop -name "LPRInstall-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						yazTanim
					else
						sleep 2
						LPRInstall
					fi
						}
						sleep 1
						LPRInstall
				else
						yazTanim
				fi
				}


				cupsKontrol
				exit
			;;
			"${items[5]}")
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				gnome-terminal --title=ScannerCOPY-$ENTRY -- scp $scannnerYol $kAdi@$ENTRY:/home/scanner.deb
				function ScannerCon(){
				#procKontrol=$('xprop -name "NDISCopy" _NET_WM_PID' 2>&1);
				#procKontrol=`echo $procKontrol | sed -e 's/^[[:space:]]*//'`
				xprop -name "ScannerCOPY-$ENTRY" _NET_WM_PID
				if [ $? != 0 ];then
				gnome-terminal --title=ScannerKur-$ENTRY -- ssh $kAdi@$ENTRY -t "dpkg -i /home/scanner.deb; rm /home/scanner.deb"
					function ScannerK() {
					xprop -name "ScannerKur-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					zenity --info --title "İşlem başarılı" --text="Tarayıcı yazılımı başarılı bir şekilde kuruldu" --width=250
					else
					sleep 5
					ScannerK
					fi
					}
					sleep 1
					ScannerK
				else
				sleep 5
				ScannerCon
				fi
				}
				sleep 1
				ScannerCon
				exit
			;;

			#Remove edip yeniden başlatıp tekrardan yükleyen
			# "${items[6]}")
			# 	PCanaMenu & disown
			# 	ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
			# 	yes 1 | passwd root
			# 	ENDSSH
			# 	gnome-terminal --title=802RCopy-$ENTRY -- scp $sekizRemYol $kAdi@$ENTRY:/home/8021xremove.sh
			# 	function 802RKopy(){
			# 		xprop -name "802RCopy-$ENTRY" _NET_WM_PID
			# 		if [ $? != 0 ];then
			# 			gnome-terminal --title=802Remove-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash -x /home/8021xremove.sh'
			# 			function 802Remove(){
			# 				xprop -name "802Remove-$ENTRY" _NET_WM_PID
			# 				if [ $? != 0 ];then
			# 				z=0
			# 				function basladimiKontrol(){
			# 					bagKontrol=$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 $kAdi@$ENTRY echo ok 2>&1)
			# 					if [[ $bagKontrol == *"ok"* ]] || [[ $bagKontrol == *"continue"* ]]; then
			# 					gnome-terminal --title=802Copy-$ENTRY -- scp $sekizYol $kAdi@$ENTRY:/home/8021.sh
			# 					function 802Kopy(){
			# 						xprop -name "802Copy-$ENTRY" _NET_WM_PID
			# 						if [ $? != 0 ];then
			# 						 	gnome-terminal --title=802Install-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /home/8021.sh'"; exec bash -i"
			# 							#gnome-terminal --title=802Install-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash /home/8021.sh'
			# 							function 802Bas(){
			# 							xprop -name "802Install-$ENTRY" _NET_WM_PID
			# 							if [ $? != 0 ];then
			# 								function tekrarBasKontrol(){
			# 									tekBagKontrol=$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 $kAdi@$ENTRY echo ok 2>&1)
			# 									if [[ $tekBagKontrol == *"ok"* ]] || [[ $tekBagKontrol == *"continue"* ]]; then
			# 										gnome-terminal --title=802Install-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
			# 										zenity --info --title "İşlem başarılı" --text="8021X Sertifikası Yüklendi." --width=250
			# 									else
			# 										yazi[0]="$ENTRY-Yeniden başlaması bekleniyor."
			# 										yazi[1]="$ENTRY-Yeniden başlaması bekleniyor.."
			# 										yazi[2]="$ENTRY-Yeniden başlaması bekleniyor..."
													
			# 										for i in 0 1 2
			# 										do
			# 										zenity --notification --text="${yazi[$i]}"
			# 										sleep 5
			# 										done
			# 										tekrarBasKontrol
			# 									fi
			# 								}
			# 							sleep 5
			# 							tekrarBasKontrol
			# 							else
			# 							sleep 2
			# 							802Bas
			# 							fi
			# 							}
			# 							sleep 1
			# 							802Bas
			# 						else
			# 						sleep 5
			# 						802Kopy
			# 						fi
			# 						}
			# 					sleep 1
			# 					802Kopy
			# 					else
			# 					 if [[$z == 3]] ; then
			# 					 zenity --info --title "İşlem yapılamadı" --text="Bilgisayara 8021x sertifikası yüklenemedi.\nBypass işlemini tekrar kontrol ediniz.\nİnternet bağlantısı yok." --width=350
			# 					 else
			# 							yazi[0]="$ENTRY-Yeniden başlaması bekleniyor."
			# 							yazi[1]="$ENTRY-Yeniden başlaması bekleniyor.."
			# 							yazi[2]="$ENTRY-Yeniden başlaması bekleniyor..."
										
			# 							for i in 0 1 2
			# 							do
			# 							zenity --notification --text="${yazi[$i]}"
			# 							sleep 5
			# 							done
			# 							z=$((z+1))
			# 							basladimiKontrol
			# 						fi
			# 					fi
			# 					}
			# 				sleep 5
			# 				basladimiKontrol
			# 				else
			# 				sleep 5
			# 				802Remove
			# 				fi
			# 			}
			# 		sleep 1
			# 		802Remove
			# 		else
			# 		sleep 5
			# 		802RKopy
			# 		fi
			# 	}
			# 	sleep 1
			#     802RKopy
			# 	exit
			# ;;
			
			#Remove edip yükleyip yeniden başlayan script
			"${items[6]}")
				PCanaMenu & disown
				gnome-terminal --title=802KontrolEtBaslamadanOnce-$ENTRY --geometry=100x50 -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'getcert list && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
				if zenity --question --title "8021x Sertifikası Yüklensin mi?" --text="Açılan uç birimde gerekli kotnroller sonrası\n8021x sertifikası yükleme ihtiyacı var ise evet'e basın.\nHayır denildiğinde hiçbir işlem yapmadan süreç sonlanacaktır." --width=400
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				gnome-terminal --title=802RCopy-$ENTRY -- scp $sekizRemYol $kAdi@$ENTRY:/home/8021xremove.sh
				function 802RKopy(){
					xprop -name "802RCopy-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=802Remove-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash -x /home/8021xremove.sh'
						function 802Remove(){
							xprop -name "802Remove-$ENTRY" _NET_WM_PID
							if [ $? != 0 ];then
								gnome-terminal --title=802Copy-$ENTRY -- scp $sekizYol $kAdi@$ENTRY:/home/8021.sh
								function 802Kopy(){
									xprop -name "802Copy-$ENTRY" _NET_WM_PID
									if [ $? != 0 ];then
										gnome-terminal --title=802Install-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /home/8021.sh'"; exec bash -i"
										#gnome-terminal --title=802Install-$ENTRY -- ssh $kAdi@$ENTRY -t 'bash /home/8021.sh'
										function 802Bas(){
										xprop -name "802Install-$ENTRY" _NET_WM_PID
										if [ $? != 0 ];then
										zenity --info --title "İşlem başarılı" --text="8021X Sertifikası Yüklendi." --width=250
										z=0
										function tekrarBasKontrol(){
											tekBagKontrol=$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 $kAdi@$ENTRY echo ok 2>&1)
											if [[ $tekBagKontrol == *"ok"* ]] || [[ $tekBagKontrol == *"continue"* ]]; then
													gnome-terminal --title=802KontrolBasladıktanSonra-$ENTRY --geometry=100x50 -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'getcert list && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
													# gnome-terminal --title=802KontrolBasladıktanSonra-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'ls -ltr /etc/pki/certs/ && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli -t connection show --active && echo ---------------------------------------------------------'";ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'nmcli con show'"; exec bash -i"
											else
												if [ $z == 20 ] ; then
													exit
												else
													z=$((z+1))
													sleep 3
													tekrarBasKontrol
												fi
											fi
											}
											sleep 5
											tekrarBasKontrol
										else
										sleep 2
										802Bas
										fi
										}
										sleep 1
										802Bas
									else
									sleep 5
									802Kopy
									fi
									}
								sleep 1
								802Kopy
							else
							sleep 5
							802Remove
							fi
						}
					sleep 1
					802Remove
					else
					sleep 5
					802RKopy
					fi
				}
				sleep 1
			    802RKopy
				exit
				else
				exit
				fi	
			;;
			
			"${items[7]}")
				PCanaMenu & disown
				# ssh $kAdi@$ENTRY 'systemctl restart winbind.service; reboot'
				gnome-terminal --title=XSaneAyarla-$ENTRY -- ssh $kAdi@$ENTRY -t "SANE_DEBUG_DLL=3 scanimage -L && rm -rf /usr/lib/x86_64-linux-gnu/sane/libsane-epson*"
					function XSaneAyarla(){
						xprop -name "XSaneAyarla-$ENTRY" _NET_WM_PID	
						if [ $? != 0 ];then
							zenity --info --title "İşlem başarılı" --text="XSane Ayarları Yapıldı - Basit Taramayı Tekrar Deneyiniz." --width=350
						else
							sleep 5
							XSaneAyarla
						fi
						}
					sleep 1
					XSaneAyarla
				exit
			;;
			
			
			"${items[8]}")
				PCanaMenu & disown
				#zenity --info --title "Bilgi" --text="GPUPdate işlemi yapılıyor. Lütfen bekleyin..." --width=250 & disown
				pcgpSay=0
				ssh $kAdi@$ENTRY -t 'systemctl restart rsyslog' & disown
				gnome-terminal --title=Journal-$ENTRY -- ssh $kAdi@$ENTRY -t "journalctl -u tayfa.service -f"
				gnome-terminal --title=Tail-$ENTRY -- ssh $kAdi@$ENTRY -t "tail -f /var/log/syslog | grep tayfa"
				function gpKontrolPC(){
				gpdurum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'gpupdate' 2>&1);
				if [[ $gpdurum == *"Unable to communicate"* ]] && [[ $pcgpSay == 0 ]] || [[ $tayfaConf != $pcKaptanIP ]]; then
					if [ $tayfaConf != $kaptanTestSIP ]; then
						if [ $tayfaConf != $pcKaptanIP ]; then
							#ssh $kAdi@$ENTRY -t "systemctl stop tayfa.service"
							ssh $kAdi@$ENTRY -t "sed -i 's/'$tayfaConf'/'$pcKaptanIP'/' /usr/share/tayfa/tayfa.conf"
						fi
					fi	
					ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					rm /usr/share/tayfa/database/token
					rm /usr/share/tayfa/database/store
					sleep 1
					systemctl restart tayfa
					ENDSSH
					# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					# rm -rf /usr/share/tayfa/database/token
					# rm -rf /usr/share/tayfa/database/store
					# sleep 1
					# systemctl restart tayfa.service
					# ENDSSH
					sleep 5
				pcgpSay=1
				gpKontrolPC	
				else
					if [[ $gpdurum == *"Unable to communicate"* ]] && [[ $pcgpSay == 1 ]]; then
					zenity --warning --title "Hata" --text="GPUPdate işlemi yapılamıyor. Manuel kontrol sağlayın" --width=250 & disown
					else
					exit
					fi
				#gnome-terminal -- ssh $kAdi@$ENTRY -t "gpupdate"
				fi
				#gnome-terminal -- ssh $kAdi@$ENTRY -t "tail -f /var/log/syslog | grep tayfa"
				}
				gpKontrolPC
				exit
			;;

			"${items[9]}")
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				export zkbsuser=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk -F " " '{ print $3 }') && rm -rf /home/$zkbsuser@ziraatkatilim.local/Masaüstü/Ndis_Client.desktop
				ENDSSH
				gnome-terminal --title=NDISCopy-$ENTRY -- scp $nanoIYol $kAdi@$ENTRY:/home/install-ndclient_v2.sh
				function NDISKon(){
				#procKontrol=$('xprop -name "NDISCopy" _NET_WM_PID' 2>&1);
				#procKontrol=`echo $procKontrol | sed -e 's/^[[:space:]]*//'`
				xprop -name "NDISCopy-$ENTRY" _NET_WM_PID
				if [ $? != 0 ];then
				gnome-terminal --title=CameraSetup-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /home/install-ndclient_v2.sh'"; exec bash -i"
				#gnome-terminal --title=CameraSetup-$ENTRY -- ssh $kAdi@$ENTRY -t "bash /home/install-ndclient_v2.sh"
					function CameraS() {
					xprop -name "CameraSetup-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						#parduSurum=$(ssh $kAdi@$ENTRY 'lsb_release -a | grep "Release" | cut -d ':' -f2' 2>&1);
						#parduSurum=`echo $parduSurum | sed -e 's/^[[:space:]]*//'`
						#if [[ $parduSurum == *"21"* ]];then
						ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
						user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
						yol="/home/$user_name@ziraatkatilim.local"

						mkdir $yol/.config/nd_cross_client_config

						cat <<'EOF'> $yol/.config/nd_cross_client_config/nd_cc_app_config.json
							{
								"ConfigVersion": 3,
								"LoginFormState": {
									"LoginType": "activeDirectory",
									"ServerIP": "10.212.2.3",
									"ServerPort": 444,
									"UserName": "user",
									"UseSSL": false
								},
								"Tweak": {
									"EnableLibVLCLogging": false,
									"EnableLibVLCLoggingWithSource": false,
									"EnableLibVLCLoggingWithDefaultVLCLibFormat": true,
									"AlsoLogPlayerStatusToFile": false
								},
								"PlayerState": {
									"PinControls": true
								},
								"Language": "turkish",
								"MainWindowState": {
									"OpenPlayersWithMainStream": false
								}
							}
						EOF
						sed -i -e 's/user/'$user_name'/g' $yol/.config/nd_cross_client_config/nd_cc_app_config.json
						ENDSSH
						zenity --info --title "İşlem başarılı" --text="Kamera yazılımı başarılı bir şekilde kuruldu" --width=250
						#gnome-terminal --title=CameraSetup2 -- ssh $kAdi@$ENTRY -t "dpkg -i $vlcPYol"
							#function CameraS2() {
							#xprop -name "CameraSetup2" _NET_WM_PID
							#if [ $? != 0 ];then
							#zenity --info --title "İşlem başarılı" --text="Kamera yazılımı başarılı bir şekilde kuruldu, Pardus 21 pluginleri ile kuruldu" --width=250
							#zenity --info --title "İşlem başarılı" --text="Kamera yazılımı vlc pluginleri dahil başarılı bir şekilde kuruldu" --width=250
							#else
							#sleep 5
							#CameraS2
							#fi
							#}
							#sleep 1
							#CameraS2
						#else
						#zenity --info --title "Hata" --text="Kamera yazılımı başarılı bir şekilde kuruldu.\nKarşıdaki bilgisayar Pardus sürüm 21 değil, vlc eklentileri kurulmadı." --width=250
						#exit
						#fi
					else
					sleep 5
					CameraS
					fi
					}
					sleep 1
					CameraS
				else
				sleep 5
				NDISKon
				fi
				}
				sleep 1
				NDISKon
				exit
			;;

			# "${items[10]}") 
			# 	PCanaMenu & disown
			# 	function dos2UKontrol() {
			# 	durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -l dos2unix' 2>&1);
			# 	scp $geyveUYol $kAdi@$ENTRY:/home/geyve2_uninstall.sh
			# 	if [[ $durum == *"no packages"* ]] || [[ $durum == *"eşleşen"* ]] ; then
			# 	#echo -e "123\n" | sudo -S apt install $pkgPaket
			# 	gnome-terminal --title=D2Install -- ssh $kAdi@$ENTRY 'apt-get install dos2unix'
			# 	function Dos2Install(){
			# 		xprop -name "D2Install" _NET_WM_PID
			# 		if [ $? != 0 ];then
			# 		#zenity --info --title "İşlem başarılı" --text="Dos2Unix uygulaması yüklendi" --width=250
			# 		dos2UKontrol
			# 		else
			# 		sleep 5
			# 		Dos2Install
			# 		fi
			# 		}
			# 	sleep 1
			# 	Dos2Install
			# 	elif [[ $durum == *"Unable to locate package"* ]]; then
			# 	zenity --info --title "Hata" --text="Dos2Unix uygulaması yüklenemedi" --width=250
			# 	else
			# 	ssh $kAdi@$ENTRY 'dos2unix /home/geyve2_uninstall.sh'
			# 	sleep 1
			# 	gnome-terminal --title=G2Uninstall -- ssh $kAdi@$ENTRY 'bash /home/geyve2_uninstall.sh'
			# 	function G2UKontrol(){
			# 	xprop -name "G2Uninstall" _NET_WM_PID
			# 	if [ $? != 0 ];then
			# 		gnome-terminal --title=G2Install -- ssh $kAdi@$ENTRY 'bash /usr/share/tayfa/scripts/geyve_3.2.9*'
			# 		function G2Install(){
			# 		xprop -name "G2Install" _NET_WM_PID	
			# 		if [ $? != 0 ];then
			# 		zenity --info --title "İşlem başarılı" --text="Geyve silinip başarılı bir şekilde kuruldu" --width=250
			# 		else
			# 		sleep 5
			# 		G2Install
			# 		fi
			# 		}
			# 		sleep 1
			# 		G2Install
			# 	else
			# 	sleep 5
			# 	G2UKontrol
			# 	fi
			# 	}
			# 	sleep 1
			# 	G2UKontrol
			# 	fi
			# 	}
			# 	sleep 1
			# 	dos2UKontrol
			# 	exit
			# ;;


			# "${items[10]}") 
			# 	PCanaMenu & disown
			# 		ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
			# 		rm /usr/lib/geyve/version.py 
			# 		ENDSSH
			# 		FILE="/usr/share/tayfa/scripts/geyve_3.2.9*"
			# 		if test -f "$FILE"; then
			# 			gnome-terminal --title=G329Install -- ssh $kAdi@$ENTRY 'bash -x /usr/share/tayfa/scripts/geyve_3.2.9*'
			# 			function G329Install(){
			# 			xprop -name "G329Install" _NET_WM_PID	
			# 			if [ $? != 0 ];then
			# 			zenity --info --title "İşlem başarılı" --text="Geyve silinip başarılı bir şekilde kuruldu" --width=250
			# 			else
			# 			sleep 5
			# 			G329Install
			# 			fi
			# 			}
			# 			sleep 1
			# 			G329Install
			# 		else
			# 			gnome-terminal --title=Geyve3291Copy -- scp $geyve3291Yol $kAdi@$ENTRY:/home/geyve_3291.sh
			# 			function Geyve329Kopyala(){
			# 				xprop -name "Geyve3291Copy" _NET_WM_PID
			# 				if [ $? != 0 ];then
			# 					gnome-terminal --title=Geyve3291Kur -- ssh $kAdi@$ENTRY -t "bash -x /home/geyve_3291.sh; rm /home/geyve_3291.sh"
			# 					function Geyve329Kur() {
			# 					xprop -name "Geyve3291Kur" _NET_WM_PID
			# 					if [ $? != 0 ];then
			# 					zenity --info --title "İşlem başarılı" --text="Geyve silinip başarılı bir şekilde kuruldu" --width=250
			# 					else
			# 					sleep 3
			# 					Geyve329Kur
			# 					fi
			# 					}
			# 					sleep 1
			# 					Geyve329Kur
			# 				else
			# 				sleep 3
			# 				Geyve329Kopyala
			# 				fi
			# 			}
			# 			sleep 1
			# 			Geyve329Kopyala
			# 		fi
			# 	exit
			# ;;


			"${items[10]}") 
				PCanaMenu & disown
					ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					rm /usr/lib/geyve/version.py 
					ENDSSH
					
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyvePatronService $kAdi@$ENTRY:/tmp/geyve_patron.service
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyveService $kAdi@$ENTRY:/tmp/geyve.service
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyve3291Install $kAdi@$ENTRY:/tmp/geyve_3.2.9.1install.sh
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyveWHLS $kAdi@$ENTRY:/tmp/geyve_whls_new.tar.gz
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyvePrinteLinux $kAdi@$ENTRY:/tmp/printerLinux.py
						gnome-terminal --title=GeyveYukle-$ENTRY -- scp $geyveStart $kAdi@$ENTRY:/tmp/start_geyve.sh
						function G3291Install(){
						xprop -name "GeyveYukle-$ENTRY" _NET_WM_PID	
						if [ $? != 0 ];then
						gnome-terminal --title=Geyve3291Kur-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -t "'bash /tmp/geyve_3.2.9.1install.sh'"; exec bash -i"
							function Geyve3291Kur() {
							xprop -name "Geyve3291Kur-$ENTRY" _NET_WM_PID
							if [ $? != 0 ];then
							ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
							systemctl restart winbind.service
							systemctl restart smbd.service
							ENDSSH
							hostnameIParca=($getirHostnameI)
							arrayDurumGeyve=()
							t=0
							for bolunmusIP in $safIP
							do
								if [ $bolunmusIP = ${hostnameIParca[t]} ]
								then	
										arrayDurumGeyve+=("$bolunmusIP / ${hostnameIParca[t]} - Uyuyor\n")
								else
										arrayDurumGeyve+=("echo ${hostnameIParca[t]} - DNS Kaydını Sildir")	
								fi
							t=$((t+1))
							done
							geyveYD=""
							geyveYD=${arrayDurumGeyve[@]}
							zenity --info --title "İşlem başarılı" --text="Geyve silinip başarılı bir şekilde kuruldu\n$geyveYD" --width=250
							else
							sleep 3
							Geyve3291Kur
							fi
							}
							sleep 1
							Geyve3291Kur
						else
						sleep 5
						G3291Install
						fi
						}
						sleep 1
						G3291Install
				exit
			;;
			

			"${items[11]}") 
				if zenity --question --title "Var Alanı Temizle" --text="Var alanını temizlemek istiyor musunuz?" --width=200 
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				rm -rf /var/log/messages*
				rm -rf /var/log/user*
				rm -rf /var/log/syslog*
				echo -e "Var loglar silindi."
				sleep 2
				touch /var/log/messages
				touch /var/log/user.log
				touch /var/log/syslog
				echo -e "Var log bölümleri tekrar oluşturuldu"
				ENDSSH
				else
				PCanaMenu & disown
				exit
				fi
				
				#zenity --notification --text "Var Alanı Temizlendi"
				varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f4' 2>&1);
				if [ -z "$varYuzde" ]; then
				varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f5' 2>&1);
					if [ -z "$varYuzde" ]; then
					varYuzde=$(ssh $kAdi@$ENTRY 'df -h -t ext4 --output=source,pcent | grep 'var' | cut -d\   -f3' 2>&1);
					fi
				fi
				if zenity --question --title "İşlem Başarılı" --text="Var alanını temizlendi\nBilgisayarı yeniden başlatmak istiyor musunuz?" --width=300 
				then
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				reboot
				ENDSSH
				zenity --info --title "İşlem başarılı" --text="$ENTRY - Var alanı temizlenip bilgisayar yeniden başlatıldığından\ntekrardan bağlanmanız gerekmektedir." --width=300
				ilkBas=1
				ENTRY=""
				basla
				else
				PCanaMenu & disown
				exit
				fi
			;;


			"${items[12]}")
			PCanaMenu & disown
			#parduSurum=$(ssh $kAdi@$ENTRY 'lsb_release -a | grep "Release" | cut -d ':' -f2' 2>&1);
			#parduSurum=`echo $parduSurum | sed -e 's/^[[:space:]]*//'`
			#if [[ $parduSurum == *"21"* ]];then
			gnome-terminal --title=CameraSetup12-$ENTRY -- ssh $kAdi@$ENTRY -t "dpkg -i $vlcPYol"
				function CameraS12() {
				xprop -name "CameraSetup12-$ENTRY" _NET_WM_PID
				if [ $? != 0 ];then
				zenity --info --title "İşlem başarılı" --text="NanoDems VLC Pluginleri yüklendi." --width=250
				else
				sleep 5
				CameraS12
				fi
				}
				sleep 1
				CameraS12
			exit
			#else
			#zenity --error --title "Hata" --text="Karşıdaki bilgisayar Pardus sürüm 21 değil." --width=250
			#exit
			#fi
			;;

			"${items[13]}") 
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				yes Y | apt --fix-broken install
				yes Y | apt-get remove arksigner-pub
				yes Y | apt-get install libstdc++6, libccid, libusb-0.1-4, pcscd, libpcsclite1
				ENDSSH
				gnome-terminal --title=ArkCopy-$ENTRY -- scp $arkYol $kAdi@$ENTRY:/home/arksigner2.3.9.deb
				function ArkCopyKont(){
					xprop -name "ArkCopy-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=ArkKur-$ENTRY -- ssh $kAdi@$ENTRY -t "dpkg -i /home/arksigner2.3.9.deb; rm /home/arksigner2.3.9.deb"
						function Arkur() {
						xprop -name "ArkKur-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
						apt --fix-broken install 
						ENDSSH
						zenity --info --title "İşlem başarılı" --text="ArkSigner Uygulaması Başarı İle Kuruldu" --width=250
						else
						sleep 3
						Arkur
						fi
						}
						sleep 1
						Arkur
					else
					sleep 3
					ArkCopyKont
					fi
				}
				sleep 1
			    ArkCopyKont
				exit
			;;
			#eimzaUnistall
			"${items[14]}") 
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				yes Y |apt --fix-broken install
				rm -rf /opt/Imzager
				ENDSSH
				gnome-terminal --title=imzagerCopy-$ENTRY -- scp $eimzaYol $kAdi@$ENTRY:/tmp/esya-imzager-2.7.2.sh
					function imzagerCopy(){
						xprop -name "imzagerCopy-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
								gnome-terminal --title=imzagerKur-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -t "'bash /tmp/esya-imzager-2.7.2.sh'"; exec bash -i"
								#gnome-terminal -title=imzagerKur-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /tmp/esya-imzager-2.7.2.sh'"; exec bash -i"
								#gnome-terminal --title=imzagerKur-$ENTRY -- ssh $kAdi@$ENTRY -t "bash /home/esya-imzager-2.7.2.sh; rm /home/esya-imzager-2.7.2.sh"
								function imzagerKur() {
								xprop -name "imzagerKur-$ENTRY" _NET_WM_PID
								if [ $? != 0 ];then
									gnome-terminal --title=imzagerLisansCopy-$ENTRY -- scp $imzagerLisans $kAdi@$ENTRY:/opt/Imzager/lisans/lisans.xml
									gnome-terminal --title=imzagerLisansCopy-$ENTRY -- scp $imzagerLisans $kAdi@$ENTRY:/home/$loginUser@ziraatkatilim.local/Imzager/lisans/lisans.xml
									function imzagerLisansBekle() {
										xprop -name "imzagerLisansCopy-$ENTRY" _NET_WM_PID
										if [ $? != 0 ];then
										ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
										apt --fix-broken install 
										ENDSSH
cat <<'EOF' | ssh $kAdi@$ENTRY 'cat - > /home/'$loginUser'@ziraatkatilim.local/Masaüstü/Imzager.Desktop'
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Imzager
Exec="/opt/Imzager/Imzager" %U
Icon=/opt/Imzager/.install4j/Imzager.png
Categories=Application;
StartupWMClass=install4j-tr-gov-tubitak-bilgem-esya-mim-signertree-MainFrameController
EOF
										ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
										user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
										desktop_file_path=(/home/$user_name@ziraatkatilim.local/Masaüstü/Imzager.Desktop)

										chown "$user_name:domain users" /home/$user_name@ziraatkatilim.local/Masaüstü/Imzager.Desktop
										chmod 650 /home/$user_name@ziraatkatilim.local/Masaüstü/Imzager.Desktop
										chmod +x /home/$user_name@ziraatkatilim.local/Masaüstü/Imzager.Desktop
										cd /home/$user_name@ziraatkatilim.local/Masaüstü/

										sudo -u $user_name bash -c '\
										touch '$desktop_file_path'
										chmod 755 '$desktop_file_path'
										'
										sudo -u $user_name bash -c 'dbus-launch gio set '$desktop_file_path' metadata::trusted true'
										ENDSSH
										zenity --info --title "İşlem başarılı" --text="İmzager Uygulaması Başarı İle Kuruldu ve Lisans Dosyası Yüklendi" --width=250
										else
										sleep 3
										imzagerLisansBekle
										fi
									}
									sleep 1
									imzagerLisansBekle
								else
								sleep 3
								imzagerKur
								fi
								}
								sleep 1
								imzagerKur
							else
							sleep 3
							imzagerCopy
							fi
						}
						sleep 1
					imzagerCopy
				exit
			;;

			# "${items[14]}") 
			# 	PCanaMenu & disown
			# 	ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
			# 	yes 1 | passwd root
			# 	yes Y |apt --fix-broken install
			# 	ENDSSH
			# 	gnome-terminal --title=imzagerCopy-$ENTRY -- scp $eimzaYol $kAdi@$ENTRY:/home/esyaimzager210Kurumsal.sh
			# 	function imzagerCopy(){
			# 		xprop -name "imzagerCopy-$ENTRY" _NET_WM_PID
			# 		if [ $? != 0 ];then
			# 			gnome-terminal --title=imzagerKur-$ENTRY -- ssh $kAdi@$ENTRY -t "bash /home/esyaimzager210Kurumsal.sh; rm /home/esyaimzager210Kurumsal.sh"
			# 			function imzagerKur() {
			# 			xprop -name "imzagerKur-$ENTRY" _NET_WM_PID
			# 			if [ $? != 0 ];then
			# 			ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
			# 				user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
			# 				chown "$user_name" /opt/ImzagerKurumsal/
			# 			ENDSSH
			# 			zenity --info --title "İşlem başarılı" --text="İmzager Kurumsal Uygulaması Başarı İle Kuruldu" --width=250
			# 			else
			# 			sleep 3
			# 			imzagerKur
			# 			fi
			# 			}
			# 			sleep 1
			# 			imzagerKur
			# 		else
			# 		sleep 3
			# 		imzagerCopy
			# 		fi
			# 	}
			# 	sleep 1
			#     imzagerCopy
			# 	exit
			# 	exit
			# ;;

			"${items[15]}") 
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new "yes $rootPass | passwd root"
				echo $rootPass | xclip -selection clipboard
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
				yes Y |apt --fix-broken install
				ENDSSH
				gnome-terminal --title=AkisCopy-$ENTRY -- scp $akisYol $kAdi@$ENTRY:/tmp/Akia_linux_6_5_4.deb
				function AkisCopy(){
					xprop -name "AkisCopy-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=AkisKur-$ENTRY -- ssh $kAdi@$ENTRY -t "apt install /tmp/Akia_linux_6_5_4.deb; rm /tmp/Akia_linux_6_5_4.deb"
						function AkisKur() {
						xprop -name "AkisKur-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
						apt --fix-broken install 
						ENDSSH
						zenity --info --title "İşlem başarılı" --text="Akis (Tubitak) Uygulaması Başarı İle Kuruldu" --width=250
						else
						sleep 3
						AkisKur
						fi
						}
						sleep 1
						AkisKur
					else
					sleep 3
					AkisCopy
					fi
				}
				sleep 1
			    AkisCopy
				exit
			;;

			"${items[16]}") 
				PCanaMenu & disown
				gnome-terminal --title=DsClient-$ENTRY -- scp $akisYol $kAdi@$ENTRY:/tmp/akis_amd64.deb
				gnome-terminal --title=DsClient-$ENTRY -- scp -r $bimserYol $kAdi@$ENTRY:/tmp
				function dsClientYule(){
					xprop -name "DsClient-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						# gnome-terminal --title=DsClientYukle-$ENTRY -- bash -c "ssh $kAdi@$ENTRY "'sudo apt-get install -y openjdk-11-jre;sudo update-java-alternatives -s java-1.11.0-openjdk-amd64;sudo systemctl stop  dsclientservice.service;sudo systemctl disable  dsclientservice.service;sudo rm -r /lib/systemd/system/dsclientservice.service;sudo  systemctl daemon-reload;yes | apt autoremove;apt --fix-broken install;sudo apt-get update;yes | sudo apt-get upgrade;yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data  openssl libssl-dev;apt-get -f install;sudo systemctl enable pcscd;dpkg -i /tmp/akis2.0amd64.deb;bash /tmp/SetupFiles/DSClientDebian.sh'"; exec bash -i"
						# gnome-terminal --title=DsClientYukle-$ENTRY -- ssh $kAdi@$ENTRY 'sudo apt-get install -y openjdk-11-jre;sudo update-java-alternatives -s java-1.11.0-openjdk-amd64;sudo systemctl stop  dsclientservice.service;sudo systemctl disable  dsclientservice.service;sudo rm -r /lib/systemd/system/dsclientservice.service;sudo  systemctl daemon-reload;yes | apt autoremove;apt --fix-broken install;sudo apt-get update;yes | sudo apt-get upgrade;yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data  openssl libssl-dev;apt-get -f install;sudo systemctl enable pcscd;dpkg -i /tmp/akis2.0amd64.deb;bash /tmp/SetupFiles/DSClientDebian.sh;exec bash -i'
cat <<'EOF' | ssh $kAdi@$ENTRY 'cat - > /tmp/dsClientInstall.sh'
#!/bin/sh
sudo apt-get install -y openjdk-11-jre
sudo update-java-alternatives -s java-1.11.0-openjdk-amd64
sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java
sudo systemctl stop dsclientservice.service
sudo systemctl disable dsclientservice.service
sudo rm -r /lib/systemd/system/dsclientservice.service
sudo  systemctl daemon-reload
yes | apt autoremove
apt --fix-broken install
sudo apt-get update
yes | sudo apt-get upgrade
# yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data openssl libssl-dev libcrypto++8
yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data openssl libssl-dev
apt-get -f install
sudo systemctl enable pcscd
dpkg -i /tmp/akis_amd64.deb
# apt-get install /tmp/GemaltoDriver/*
bash /tmp/SetupFiles/DSClientDebian.sh
curl http://localhost:3638/api/smartcard/getTerminals
EOF
						gnome-terminal --title=DsClientYukle-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -t "'bash /tmp/dsClientInstall.sh'"; exec bash -i"
						function dsClientInstall(){
						xprop -name "DsClientYukle-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
							# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=3 <<-'ENDSSH'
							# 	sudo apt-get install -y openjdk-11-jre
							# 	sudo update-java-alternatives -s java-1.11.0-openjdk-amd64
							# 	sudo systemctl stop  dsclientservice.service
							# 	sudo systemctl disable  dsclientservice.service
							# 	sudo rm -r /lib/systemd/system/dsclientservice.service
							# 	sudo  systemctl daemon-reload
							# 	yes | apt autoremove
							# 	apt --fix-broken install
							# 	sudo apt-get update
							# 	yes | sudo apt-get upgrade
							# 	# yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data  openssl libssl-dev libcrypto++8
							# 	yes | sudo apt-get install pcscd pcsc-tools opensc opensc-pkcs11 libpam-pkcs11 libstdc++6 libccid libusb-0.1-4 libpcsclite1 libssl1.1 pkcs11-data  openssl libssl-dev
							# 	apt-get -f install
							# 	sudo systemctl enable pcscd
							# 	dpkg -i /tmp/akis2.0amd64.deb
							# 	# apt-get install /tmp/GemaltoDriver/*
							# 	bash /tmp/SetupFiles/DSClientDebian.sh
							# 	curl http://localhost:3638/api/smartcard/getTerminals
							# ENDSSH
							terminalDonenVeri=""
							javaVersion=$(ssh $kAdi@$ENTRY 'java -version' 2>&1);
							terminalDonenVeri=$(ssh $kAdi@$ENTRY 'curl http://localhost:3638/api/smartcard/getTerminals' 2>&1);
							arrayDsDurum=()
							if [[ "$javaVersion" == *"11.0"* ]]; then
								dsTitleDurum="İşlem Başarılı"
								arrayDsDurum+=("DsClient Uygulaması Başarı İle Kuruldu")
								arrayDsDurum+=("\n$ENTRY - Yükleme Başarılı")
								arrayDsDurum+=("\nJava versiyon set edildi")
								#arrayDsDurum+=("\nCard Okuyucu : $terminalDonenVeri\n")
							else
								dsTitleDurum="Hata"
								arrayDsDurum+=("DsClient Uygulaması Yüklenirken Hata")
								arrayDsDurum+=("\nHATA : Java versiyon set edilemedi.")
								arrayDsDurum+=("\nVar olan java versiyonu : $javaVersion yanlış")
								#arrayDsDurum+=("\nCard Okuyucu : $terminalDonenVeri\n")
							fi
							dsyD=""
							dsyD=${arrayDsDurum[@]}
							zenity --info --title "$dsTitleDurum" --text="$dsyD" --width=350
						else
							sleep 3
							dsClientInstall
						fi
						}
						sleep 1
						dsClientInstall
					else
						sleep 3
						dsClientYule
					fi
				}
				sleep 1
				dsClientYule
				exit
			;;

			"${items[17]}")
				function sqliteKontrol() {
					sqlDurum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg-query -l sqlite3' 2>&1);
					if [[ $sqlDurum == *"no packages"* ]]; then
						varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
						if [[ $varYuzde == *"100"* ]];then
						zenity --info --title "Hata" --text="Var alanı dolu olduğundan sqlite3 uygulaması yüklenemedi, var alanını temizleyin." --width=300
						PCanaMenu & disown
						exit
						else
						ssh $kAdi@$ENTRY 'dpkg --configure -a'
						gnome-terminal --title=sqliteInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install sqlite3 -y'
						fi
					function sqliteInstall(){
						xprop -name "sqliteInstall-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
						sqliteKontrol
						else
						sleep 5
						sqliteInstall
						fi
						}
					sleep 1	
					sqliteInstall
					elif [[ $sqlDurum == *"Unable to locate package"* ]]; then
						zenity --info --title "Hata" --text="SQLite uygulaması yüklenemedi" --width=250
					elif [[ $sqlDurum == *"dpkg --configure"* ]]; then
						ssh $kAdi@$ENTRY 'dpkg --configure -a'
						sqliteKontrol
					else
						if zenity --question --title "Chrome Geçmişi Temizle" --text="Chrome geçmişi temizlemek istiyor musununuz?\nBu işlem kullanıcının chrome sekmelerini kapatacaktır." --width=300 
							then
							ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
								user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
								yol="/home/$user_name@ziraatkatilim.local"


								FPID1=$( pgrep -u $user_name chrome | cut -d" " -f1 )
								FPID=$( pgrep -u $user_name chromium | cut -d" " -f1 )

								for i in $FPID
								do
									kill -1 $i
								done

								for a in $FPID1
								do
									kill -1 $a
								done

								sleep 2
								ENDSSH

							ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
								user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
								yol="/home/$user_name@ziraatkatilim.local"

								mv $yol/.config/chromium/Default/Bookmarks $yol/.config/chromium/Bookmarks
								mv $yol/.config/chromium/Default/Bookmarks.bak $yol/.config/chromium/Bookmarks.bak

								rm -v $yol/.cache/chromium/Default/*
								rm -r $yol/.cache/chromium/Default/*
								rm -v $yol/.config/chromium/Default/*
								rm -r $yol/.config/chromium/Default/*

								mv $yol/.config/chromium/Bookmarks $yol/.config/chromium/Default/Bookmarks
								mv $yol/.config/chromium/Bookmarks.bak $yol/.config/chromium/Default/Bookmarks.bak

							ENDSSH

							# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
							# 	user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
							# 	yol="/home/$user_name@ziraatkatilim.local"

							# 	sqlite3 $yol/.config/chromium/Default/History "select datetime(last_visit_time/1000000 + (strftime('%s', '1601-01-01')),'unixepoch'),url from urls; delete from urls;"
							# 	sqlite3 $yol/.config/chromium/Default/History "select datetime(visit_time/1000000 + (strftime('%s', '1601-01-01')),'unixepoch'),url from visits; delete from visits;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from urls where last_visit_time <= (strftime('%s',(select max(last_visit_time)/10000000 from urls),'unixepoch','-1 days')*10000000);"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from keyword_search_terms;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from sqlite_sequence;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from segments;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from segment_usage;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from downloads;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from downloads_slices;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from downloads_url_chains;"
							# 	sqlite3 $yol/.config/chromium/Default/History "delete from context_annotations;"
							# 	sqlite3 $yol/.config/chromium/Default/Cookies "select datetime(creation_utc/1000000 + (strftime('%s', '1601-01-01')),'unixepoch'),host_key from cookies; delete from cookies;"
							# 	sqlite3 $yol/.config/chromium/Default/Cookies "delete from cookies;"

							# 	if [[ -d $yol/.cache/chromium/Default/Cache ]]; then
							# 	NUM=$( ls -1 $yol/.cache/chromium/Default/Cache | wc -l )
							# 	SIZ=$( du -sbh $yol/.cache/chromium/Default/Cache )
							# 	SIZ=$( echo $SIZ | cut -d" " -f1 )
							# 	rm -r $yol/.cache/chromium/Default/Cache
							# 	fi
							# 	if [[ -d $yol/.cache/chromium/Default/Code\ Cache ]]; then
							# 	rm -r $yol/.cache/chromium/Default/Code\ Cache
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Visited\ Links ]]; then
							# 	rm $yol/.config/chromium/Default/Visited\ Links
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Top\ Sites ]]; then
							# 	rm $yol/.config/chromium/Default/Top\ Sites
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Top\ Sites-journal ]]; then
							# 	rm $yol/.config/chromium/Default/Top\ Sites-journal
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Login\ Data ]]; then
							# 	rm $yol/.config/chromium/Default/Login\ Data
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Login\ Data-journal ]]; then
							# 	rm $yol/.config/chromium/Default/Login\ Data-journal
							# 	fi
							# 	if [[ -f $yol/.config/chromium/Default/Web\ Data ]]; then
							# 	rm $yol/.config/chromium/Default/Web\ Data
							# 	fi
							# ENDSSH

							zenity --info --title "İşlem başarılı" --text="Chrome geçmiş ve cache temizlendi." --width=250
							else
							PCanaMenu & disown
							exit
							fi
					fi
					}
			sqliteKontrol
			;;


				# PDF Varsayılan Yap
				# #!/bin/bash
				# ilksatir=0
				# #satirsayisi=0
				# user_name=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk '{print $3}')
				# girdi=(/home/$user_name@ziraatkatilim.local/.config/mimeapps.list)
				# kacsatir=$(wc -l < /home/$user_name@ziraatkatilim.local/.config/mimeapps.list)

				# while read -r satir
				# do
				#   let "satirsayisi++" 
				#   if [[ "$satir" == "" ]]; then
				#     echo "application/pdf=chromium.desktop" >> /home/mimeapp_new.list
				#     ilksatir=1
				#     #elif [[ $satirsayisi == $kacsatir ]] && [[ $ilksatir == 1 ]] ; then
				#     #sed -i 'application/pdf=chromium.desktop' test.list
				#   fi
				#   echo "$satir" >> /home/mimeapp_new.list
				# done < "$girdi"
				# echo "application/pdf=chromium.desktop" >> /home/mimeapp_new.list
				# mv /home/$user_name@ziraatkatilim.local/.config/mimeapps.list /home/$user_name@ziraatkatilim.local/.config/mimeapps_old.list
				# mv /home/mimeapp_new.list /home/$user_name@ziraatkatilim.local/.config/mimeapps.list
				# # rm /home/mimeapp_new.list
			"${items[18]}") 
				PCanaMenu & disown
				gnome-terminal --title=pdfDefChrom-$ENTRY -- scp $pdfDefChrom $kAdi@$ENTRY:/home/pdfVarsayilanChrome.sh
				function pdfDefChrom(){
					xprop -name "pdfDefChrom-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=pdfDefChromSet-$ENTRY -- ssh $kAdi@$ENTRY -t "bash /home/pdfVarsayilanChrome.sh; rm /home/pdfVarsayilanChrome.sh"
						function pdfDefChromSet() {
						xprop -name "pdfDefChromSet-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						zenity --info --title "İşlem başarılı" --text="PDF Görüntüleyici Varsayılan Olarak Chromium Yapıldı" --width=250
						else
						sleep 3
						pdfDefChromSet
						fi
						}
						sleep 1
						pdfDefChromSet
					else
					sleep 3
					pdfDefChrom
					fi
				}
				sleep 1
			    pdfDefChrom
				exit
			;;


			"${items[19]}") 
				PCanaMenu & disown
				ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					export zkbsuser=$(loginctl | grep `cat /sys/class/tty/tty0/active` | awk -F " " '{ print $3 }') && sudo -u $zkbsuser XDG_RUNTIME_DIR="/run/user/$(id -u $zkbsuser)" dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"
				ENDSSH
				zenity --info --title "İşlem başarılı" --text="Alt+Tab Tuşları Ayarlandı" --width=250
				exit
			;;

			"${items[20]}") 
				PCanaMenu & disown
				function alsaUtilsControl() {
				durum=$(ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new 'dpkg -l | grep alsa-utils' 2>&1);
				if [[ $durum == *"no packages"* ]] || [[ $durum == "" ]]; then
						varYuzde=`echo $varYuzde | sed -e 's/^[[:space:]]*//'`
						if [[ $varYuzde == *"100"* ]];then
						zenity --info --title "Hata" --text="Var alanı dolu olduğundan alsa-utils uygulaması yüklenemedi, var alanını temizleyin." --width=300
						exit
						else
						ssh $kAdi@$ENTRY 'dpkg --configure -a'
						gnome-terminal --title=alsaInstall-$ENTRY -- ssh $kAdi@$ENTRY 'apt-get install alsa-utils -y'
						fi
					function alsaInstall(){
						xprop -name "alsaInstall-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						#zenity --info --title "İşlem başarılı" --text="Htop uygulaması yüklendi" --width=250
						alsaUtilsControl
						else
						sleep 5
						alsaInstall
						fi
						}
					sleep 1	
					alsaInstall
				elif [[ $durum == *"Unable to locate package"* ]]; then
					zenity --info --title "Hata" --text="Alsa-utils uygulaması yüklenemedi" --width=250
				elif [[ $durum == *"dpkg --configure"* ]]; then
				    ssh $kAdi@$ENTRY 'dpkg --configure -a'
				    alsaUtilsControl
				else

cat <<'EOF' | ssh $kAdi@$ENTRY 'cat - > /tmp/alsaIslem.sh'
#!/bin/sh

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

amixer -M | grep 'Simple mixer' | cut -d "'" -f2 | while read -r satir ; do
VOLUMEALSA="$(amixer -M get "'$satir'" | grep -m 1 -o '...%' | head -1)"
if [[ ! -z "$VOLUMEALSA" ]]; then
	VOLUMECHANNEL=$satir
	VOLUMEALSA=${VOLUMEALSA//[^[:digit:].]/}
	echo -e "${YELLOW}"
	echo $VOLUMECHANNEL - Varolan Ses Seviyesi : $VOLUMEALSA
	echo -e "${NC}"
	SESSEVIYESI=100
	DURUM='unmute'
	FADEVOLUME=$VOLUMEALSA
	amixer -q -M set "$VOLUMECHANNEL" "$SESSEVIYESI%" $DURUM
	# if [[ $VOLUMEALSA -gt $FADETO ]]; then
	#     # Fading Out
	#     until [[ $FADEVOLUME -le $FADETO || $FADEVOLUME -le 0 ]]; do
	#         FADEVOLUME=$(($FADEVOLUME-$VOLUMESTEP))
	#         amixer -q -M set "$VOLUMECHANNEL" "${FADEVOLUME}%"
	#         sleep $SPEED
	#     done
	# else 
	#     # Fading in
	#     until [[ $FADEVOLUME -ge $FADETO || $FADEVOLUME -ge 100 ]]; do
	#         FADEVOLUME=$(($FADEVOLUME+$VOLUMESTEP))
	#         amixer -q -M set "$VOLUMECHANNEL" "${FADEVOLUME}%"
	#         sleep $SPEED
	#     done
	# fi
	VOLUMEALSA="$(amixer -M get "'$VOLUMECHANNEL'" | grep -m 1 -o '...%' | head -1)"
	VOLUMEALSA=${VOLUMEALSA//[^[:digit:].]/}
	echo -e "${GREEN}"
	echo $VOLUMECHANNEL - Son Ses Seviyesi : $VOLUMEALSA
	echo -e "${NC}"
fi 
done
EOF
				gnome-terminal --title=AlsaMixer-$ENTRY -- bash -c "ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new -t "'bash /tmp/alsaIslem.sh'"; exec bash -i"
				function alsaISlemYap() {
					xprop -name "AlsaMixer-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
					# ssh $kAdi@$ENTRY -o StrictHostKeyChecking=accept-new <<-'ENDSSH'
					# 	rm /tmp/alsaIslem.sh
					# ENDSSH
					zenity --info --title "İşlem başarılı" --text="Alsa Mixer Ayarları Yapıldı" --width=250
					else
					sleep 3
					alsaISlemYap
					fi
					}
				sleep 1
				alsaISlemYap

				fi
			}
				sleep 1
			    alsaUtilsControl
				exit
			;;

			"${items[21]}") 
				PCanaMenu & disown
				gnome-terminal --title=geyveRestart-$ENTRY -- scp $geyveRestartYolu $kAdi@$ENTRY:/tmp/geyveRestartOlustur.sh
				function geyveRestart(){
					xprop -name "geyveRestart-$ENTRY" _NET_WM_PID
					if [ $? != 0 ];then
						gnome-terminal --title=geyveRestartSet-$ENTRY -- ssh $kAdi@$ENTRY -t "bash /tmp/geyveRestartOlustur.sh; rm /tmp/geyveRestartOlustur.sh"
						function geyveRestartSet() {
						xprop -name "geyveRestartSet-$ENTRY" _NET_WM_PID
						if [ $? != 0 ];then
						zenity --info --title "İşlem başarılı" --text="Geyve Restart Kısayolu Oluşturuldu" --width=250
						else
						sleep 3
						geyveRestartSet
						fi
						}
						sleep 1
						geyveRestartSet
					else
					sleep 3
					geyveRestart
					fi
				}
				sleep 1
			    geyveRestart
				exit
			;;
			

			"${items[22]}") 
				ilkBas=0
				basla
			;;
			
			"${items[23]}")
				ilkBas=1
				ENTRY=""
				basla
			;;
			
			1) exit ;;
			*) exit ;;
		    esac
		    #break
		done
	
	}


    if [[ $hostName == *"SIRA"* ]] || [[ $hostName == *"sira"* ]] ; then
		{
          SIRAanaMenu
         } else {
          PCanaMenu
        }
    fi
elif [[ $baglanti == *"Host key verification failed"*  ]]; then
	(zenity --error \
       --title "Baglantı Hatası" \
       --width 300 \
       --height 50 \
       --text "Eski host key dosyası silindi tekrar bağlanmayı deneyin.")
	   rm $HOME/.ssh/known_hosts
       ilkBas=1
       basla
elif [[ $baglanti == *"Permission denied"*  ]]; then
	(zenity --error \
       --title "Baglantı Hatası" \
       --width 300 \
       --height 50 \
       --text "Bilgisayar policy almadığından bağlanılamıyor")
       ilkBas=1
       basla
elif [[ $baglanti == *"Connection refused"*  ]]; then
	(zenity --error \
       --title "Baglantı Hatası" \
       --width 300 \
       --height 50 \
       --text "Bağlanılan bilgisayar Windows olduğu için Remote Control Viewer ile bağlanın")
       ilkBas=1
       basla
	#    elif [[ $baglanti == *"Connection refused"*  ]]; then
	# (zenity --error \
    #    --title "Baglantı Hatası" \
    #    --width 300 \
    #    --height 50 \
    #    --text "Bağlanılan bilgisayar Windows olduğu için Remote Control Viewer ile bağlanın - Durum : $baglanti")
    #    ilkBas=1
    #    basla
else
	(zenity --error \
       --title "Baglantı Hatası" \
       --width 300 \
       --height 50 \
       --text "Bilgisayar kapalı veya erisilemiyor")
       ilkBas=1
       basla
       fi
else	
	(zenity --error \
       --title "Hata" \
       --width 300 \
       --height 50 \
       --text "$uhataText")
	ilkBas=1
	basla

fi
esac
}

function upKontrol() {
sunucuVersion=$(cat /media/Birimlerarasi/Pardus_Betik/ZKB_Support/updater.sh | grep 'ZKUpVersion' | cut -d ':' -f2);
localVersion=$(cat /usr/local/share/zkb-support/updater.sh | grep 'ZKUpVersion' | cut -d ':' -f2);

SCRIPTSRC=`readlink -f "$0" || echo "$0"`
RUN_PATH=`dirname "${SCRIPTSRC}" || echo .`

if [ $sunucuVersion == $localVersion ]; then
		basla
elif [[ -z $sunucuVersion ]]; then
		basla
else
		echo -e "Version Güncel Değil. Güncelleniyor..."
		if pgrep -f updater.sh && pgrep -f zenity &>/dev/null; then
		pkill -f updater.sh
		pkill -f zenity
		cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/updater.sh ${RUN_PATH}/updater.sh
		#zenity --info --title "İşlem başarılı" --text="Güncelleme yapıldı." --width=300
		upKontrol
		else
		echo -e "Çalışan işlem yok!"
		cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/updater.sh ${RUN_PATH}/updater.sh
		#zenity --info --title "İşlem başarılı" --text="Güncelleme yapıldı." --width=300
		upKontrol
		fi
fi
}
upKontrol
