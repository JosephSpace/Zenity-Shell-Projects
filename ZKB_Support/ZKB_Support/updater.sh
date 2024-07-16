#!/bin/bash
ZKUpVersion:1.0.13
function vKontrol() {
sunucuVersion=$(cat /media/Birimlerarasi/Pardus_Betik/ZKB_Support/prod.sh | grep 'ZKVersion' | cut -d ':' -f2);
localVersion=$(cat /usr/local/share/zkb-support/prod.sh | grep 'ZKVersion' | cut -d ':' -f2);
echo -e "Sunucu:$sunucuVersion"
echo -e "Local:$localVersion"

SCRIPTSRC=`readlink -f "$0" || echo "$0"`
RUN_PATH=`dirname "${SCRIPTSRC}" || echo .`

if [ $sunucuVersion == $localVersion ]; then
echo -e "version güncel"
bash ${RUN_PATH}/prod.sh
exit
else

if [[ -z $sunucuVersion ]] ; then
zenity --info --title "Bilgi" --text="Ortak alana erişilemiyor\nGPUpdate işlemi yapılıyor\nLütfen bekleyin.." --width=300 & disown
gpupdate
if [ $? != 0 ];then
   zenity --error --title "Hata" --text="GPUpdate işlemi yapılamadı, tayfa servisi ile ilgili bir problem mevcut. \nEski sürüm başlatılıyor." --width=250
   bash ${RUN_PATH}/prod.sh
   exit
else
  sunucuVersion=$(cat /media/Birimlerarasi/Pardus_Betik/ZKB_Support/prod.sh | grep 'ZKVersion' | cut -d ':' -f2);
  if [[ -z $sunucuVersion ]] ; then
  zenity --error --title "Hata" --text="GPUpdate işlemi yapıldı, fakat ortak alan erişiminde sorun mevcut. \nEski sürüm başlatılıyor." --width=250
  bash ${RUN_PATH}/prod.sh
  exit
  else
  zenity --info --title "İşlem başarılı" --text="Güncelleme yapıldı." --width=300
  fi
fi

vKontrol
else



if zenity --question --title "Yeni Versiyon Bulundu" --text="Sunucu Versiyonu : $sunucuVersion\nLocal Versiyon : $localVersion\n\nTüm IT Support pencereleri kapanacak\nGüncelleme yapmak ister misiniz?" --width=300 
then
echo -e "Version Güncel Değil. Güncelleniyor..."
if pgrep -f prod.sh && pgrep -f zenity &>/dev/null; then
   pkill -f prod.sh
   pkill -f zenity
   cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/prod.sh ${RUN_PATH}/prod.sh
   zenity --info --title "İşlem başarılı" --text="Güncelleme yapıldı." --width=300
   vKontrol
else
   echo -e "Çalışan işlem yok!"
   cp /media/Birimlerarasi/Pardus_Betik/ZKB_Support/prod.sh ${RUN_PATH}/prod.sh
   zenity --info --title "İşlem başarılı" --text="Güncelleme yapıldı." --width=300
   vKontrol
fi
else
bash ${RUN_PATH}/prod.sh
exit
#zenity --error --title "Hata" --text="Güncelleme işlemini iptal ettiniz." --width=300
fi
fi
fi
}
vKontrol
