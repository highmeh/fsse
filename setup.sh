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
apt-get install -qq -y tmux vim golang python3-dev git python3 python3-pip > /dev/null 2>&1

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
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/apt/stable/" | tee -a /etc/apt/sources.list.d/sublime-text.list
apt-get install -y -qq sublime-text > /dev/null 2>&1

echo "[+] Setting up Eyewitness"
apt-get install -y -qq eyewitness > /dev/null 2>&1

echo "[+] Setting up Sublist3r"
apt-get install -y -qq sublist3r > /dev/null 2>&1

echo "[+] Installing Proxmark tools"
apt-get install -y -qq --no-install-recommends git ca-certificates build-essential pkg-config libcanberra-gtk-module libreadline-dev gcc-arm-none-eabi libnewlib-dev qtbase5-dev libbz2-dev libbluetooth-dev > /dev/null

mkdir /usr/share/proxmark3
wget https://github.com/RfidResearchGroup/proxmark3/archive/refs/tags/v4.13441.zip
unzip v4.13441.zip -qq -d /usr/share/proxmark3
cd /usr/share/proxmark3/proxmark3-4.13441/
make clean
make -j
make install
cd /home/kali/

echo "[+] Installing urlcrazy"
apt-get install -y urlcrazy > /dev/null 2>&1

echo "[+] Setting up ct-exposer"
git clone https://github.com/chris408/ct-exposer.git /usr/share/ct-exposer > /dev/null 2>&1
chmod +x /usr/share/ct-exposer/ct-exposer.py
ln -s /usr/share/ct-exposer/ct-exposer.py /usr/local/bin/ct-exposer | tee -a /home/kali/.zshrc

echo "[+] Downloading bookmarks"
wget https://raw.githubusercontent.com/highmeh/fsse/main/fsse_bookmarks.html
mv fsse_bookmarks.html /home/kali/Desktop/

echo "[+] Your system has been set up!"

