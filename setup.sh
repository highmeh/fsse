#!/bin/env bash 

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "[!] This script will install tools needed for FSSE 2021"
echo "[!] If you've already installed these tools, this may cause issues."
read -p "[?] Continue? [Y/n]? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo "[!] Goodbye!"
    exit 1
fi

echo " "
echo " "
echo "[+] Updating OS..."
apt-get update -y > /dev/null 2>&1

echo "[+] Installing tools from apt..."
apt-get install -qq -y tmux apache2 php libapache2-mod-php vim golang python3-dev git python3 python3-pip > /dev/null 2>&1

echo "[+] Setting up GoReport"
git clone https://github.com/chrismaddalena/Goreport.git /usr/share/Goreport > /dev/null 2>&1
pip3 install -r /usr/share/Goreport/requirements.txt > /dev/null 2>&1
ln -s /usr/share/Goreport/GoReport.py /usr/local/bin/GoReport | tee -a /home/kali/.zshrc

echo "[+] Setting up DomainHunter"
git clone https://github.com/threatexpress/domainhunter.git /usr/share/domainhunter > /dev/null 2>&1
pip3 install -r /usr/share/domainhunter/requirements.txt > /dev/null 2>&1

echo "[+] Settting up Lure"
git clone https://github.com/highmeh/lure.git /usr/share/lure > /dev/null 2>&1
pip3 install -r /usr/share/lure/requirements.txt > /dev/null 2>&1
ln -s /usr/share/lure/lure.py /usr/local/bin/lure | tee -a /home/kali/.zshrc
cp /usr/share/lure/resources/config.sample.py /usr/share/lure/resources/config.py

echo "[+] Setting up SublimeText"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update -y > /dev/null 2>&1
apt-get install -y -qq sublime-text > /dev/null 2>&1
ln -s /opt/sublime_text/sublime_text /usr/local/bin/sublimetext | tee -a /home/kali/.zshrc

echo "[+] Setting up Eyewitness"
apt-get install -y -qq eyewitness > /dev/null 2>&1

echo "[+] Setting up Inkscape"
apt-get install -y -qq inkscape > /dev/null 2>&1

echo "[+] Setting up Sublist3r"
apt-get install -y -qq sublist3r > /dev/null 2>&1

echo "[+] Installing Proxmark tools"
apt-get install -y -qq --no-install-recommends git ca-certificates build-essential pkg-config libcanberra-gtk-module libreadline-dev gcc-arm-none-eabi libnewlib-dev qtbase5-dev libbz2-dev libbluetooth-dev > /dev/null

mkdir /usr/share/proxmark3
wget https://github.com/RfidResearchGroup/proxmark3/archive/refs/tags/v4.13441.zip > /dev/null 2>&1
unzip -qq v4.13441.zip -d /usr/share/proxmark3
cd /usr/share/proxmark3/proxmark3-4.13441/
make clean > /dev/null 2>&1
make -j > /dev/null 2>&1
make install > /dev/null 2>&1
cd /home/kali/

echo "[+] Installing urlcrazy"
apt-get install -y urlcrazy > /dev/null 2>&1

echo "[+] Installing Mindomo Mind Mapper"
mkdir /opt/mindomo
wget https://www.mindomo.com/download/9.5/Mindomo_v.9.5.8_x64.AppImage -O /opt/mindomo/mindomo.AppImage > /dev/null 2>&1
chmod +x /opt/mindomo/mindomo.AppImage
ln -s /opt/mindomo/mindomo.AppImage /usr/local/bin/mindomo

echo "[+] Installing Joplin"
mkdir /opt/joplin/
wget https://github.com/laurent22/joplin/releases/download/v2.1.9/Joplin-2.1.9.AppImage -O /opt/joplin/joplin.AppImage > /dev/null 2>&1
chmod +x /opt/joplin/joplin.AppImage
ln -s /opt/joplin/joplin.AppImage /usr/local/bin/joplin

echo "[+] Setting up ct-exposer"
git clone https://github.com/chris408/ct-exposer.git /usr/share/ct-exposer > /dev/null 2>&1
chmod +x /usr/share/ct-exposer/ct-exposer.py
ln -s /usr/share/ct-exposer/ct-exposer.py /usr/local/bin/ct-exposer | tee -a /home/kali/.zshrc

echo "[+] Downloading bookmarks"
wget https://raw.githubusercontent.com/highmeh/fsse/main/fsse_bookmarks.html > /dev/null 2>&1
mv fsse_bookmarks.html /home/kali/Desktop/

echo "[+] Downloading HTML Resources"
rm /var/www/html/*
wget https://raw.githubusercontent.com/highmeh/fsse/main/index.html -O /var/www/html/index.html > /dev/null 2>&1
wget https://raw.githubusercontent.com/highmeh/fsse/main/post.php -O /var/www/html/post.php > /dev/null 2>&1
service apache2 start

echo "[+] Your system has been set up! Don't forget to import your bookmarks (on your Desktop) into Firefox!"

