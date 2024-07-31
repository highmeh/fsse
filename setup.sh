#!/bin/env bash 

if [ "$USER" != "kali" ]
  then echo "This script must be run as the 'kali' user. Do not run with sudo, we will ask permission when we need. You will need to enter your password when prompted."
  exit 1
fi

echo "[!] This script will install tools needed for FSSE 2024"
echo "[!] Please make sure you have a user called 'kali' on this system before proceeding."
echo "[!] Note: If you've already installed these tools, this may cause issues."
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
sudo apt-get update 
sudo apt-get install -y gpg gpg-agent gpgconf gnupg
sudo apt-get upgrade -y && sudo apt dist-upgrade -y && sudo apt full-upgrade -y && sudo apt auto-remove -y

echo "[+] Installing tools from apt..."
sudo apt-get install -qq -y tmux apache2 php libapache2-mod-php vim golang python3-dev git python3 python3-pip metasploit-framework python3-virtualenv

echo "[+] Setting up GoReport"
virtualenv /home/kali/.Goreport_virtualenv
source /home/kali/.Goreport_virtualenv/bin/activate
cd /home/kali
git clone https://github.com/chrismaddalena/Goreport.git
cd /home/kali/Goreport
pip3 install -r requirements.txt
echo 'Goreport() { source /home/kali/.Goreport_virtualenv/bin/activate ; cd /home/kali/Goreport; ./GoReport.py "$@" ; deactivate ; cd /home/kali ; }' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
echo "alias goreport='Goreport'" | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
echo "alias GoReport='Goreport'" | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
deactivate

echo "[+] Setting up DomainHunter"
virtualenv /home/kali/.DomainHunter_virtualenv
source /home/kali/.DomainHunter_virtualenv/bin/activate
cd /home/kali
git clone https://github.com/threatexpress/domainhunter.git
cd /home/kali/domainhunter
pip3 install -r requirements.txt
echo 'domainhunter() { source /home/kali/.DomainHunter_virtualenv/bin/activate ; cd /home/kali/domainhunter; ./domainhunter.py "$@" ; deactivate ; cd /home/kali ; }' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
echo "alias Domainhunter='domainhunter'" | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
echo "alias DomainHunter='domainhunter'" | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
deactivate
chmod u+x /home/kali/domainhunter/domainhunter.py


echo "[+] Setting up Lure"
virtualenv /home/kali/.lure_virtualenv
source /home/kali/.lure_virtualenv/bin/activate
cd /home/kali
git clone https://github.com/highmeh/lure.git /home/kali/lure
cd /home/kali/lure
pip3 install -r /home/kali/lure/requirements.txt
cp /home/kali/lure/resources/config.sample.py /home/kali/lure/resources/config.py
echo 'lure() { source /home/kali/.lure_virtualenv/bin/activate ; cd /home/kali/lure; ./lure.py "$@" ; deactivate ; cd /home/kali ; }' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc

echo "[+] Setting up SublimeText" 
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - 
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee -a /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update -y 
sudo apt-get install -y -qq sublime-text 
#ln -s /opt/sublime_text/sublime_text /usr/local/bin/sublimetext
echo "alias sublimetext='/opt/sublime_text/sublime_text --detached'" | tee -a ~/.bashrc >> ~/.zshrc

echo "[+] Setting up Eyewitness"
sudo apt-get install -y -qq eyewitness 

echo "[+] Setting up Inkscape"
sudo apt-get install -y -qq inkscape 

echo "[+] Setting up Sublist3r"
sudo apt-get install -y -qq sublist3r 

echo "[+] Setting up Sherlock"
sudo apt-get install -y -qq sherlock

echo "[+] Installing Proxmark tools"
sudo apt-get install -y -qq --no-install-recommends git ca-certificates build-essential pkg-config libcanberra-gtk3-module libreadline-dev gcc-arm-none-eabi libnewlib-dev qtbase5-dev libbz2-dev libbluetooth-dev 
mkdir /home/kali/proxmark3
wget https://github.com/RfidResearchGroup/proxmark3/archive/refs/tags/v4.13441.zip
unzip -qq v4.13441.zip -d /home/kali/proxmark3
cd /home/kali/proxmark3/proxmark3-4.13441/
make clean
make -j
sudo make install
cd /home/kali/

echo "[+] Installing urlcrazy"
sudo apt-get install -y urlcrazy

echo "[+] Installing Mindomo Mind Mapper"
sudo mkdir /opt/mindomo
#wget https://www.mindomo.com/download/9.5/Mindomo_v.9.5.8_x64.AppImage -O /opt/mindomo/mindomo.AppImage > /dev/null 2>&1
sudo wget https://www.mindomo.com/download/10.9/Mindomo_v.10.9.3_x64.AppImage -O /opt/mindomo/mindomo.AppImage
sudo chmod +x /opt/mindomo/mindomo.AppImage
sudo ln -s /opt/mindomo/mindomo.AppImage /usr/local/bin/mindomo

echo "[+] Installing Joplin"
sudo apt-get install joplin -qq -y

echo "[+] Installing catphish"
git clone https://github.com/ring0lab/catphish /home/kali/catphish
cd /home/kali/catphish
sudo apt install -qq -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker kali
newgrp docker <<EONG
   cd /home/kali/catphish   
   docker build -t catphish:latest .
EONG
echo 'catphish() { cd /home/kali/catphish; sudo docker run --rm -it catphish:latest "$@" ; cd /home/kali ; }' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
cd /home/kali

echo "[+] Setting up ct-exposer"
virtualenv /home/kali/.ct-exposer_virtualenv
source /home/kali/.ct-exposer_virtualenv/bin/activate
cd /home/kali
git clone https://github.com/highmeh/ct-exposer /home/kali/ct-exposer
chmod +x /home/kali/ct-exposer/ct-exposer.py
cd /home/kali/ct-exposer
pip3 install -r /home/kali/ct-exposer/requirements.txt
ln -s /usr/share/ct-exposer/ct-exposer.py /usr/local/bin/ct-exposer
echo 'ct-exposer() { source /home/kali/.ct-exposer_virtualenv/bin/activate ; cd /home/kali/ct-exposer; ./ct-exposer.py "$@" ; deactivate ; cd /home/kali ; }' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc

echo "[+] Setting up Bad-PDF"
cd /home/kali
git clone https://github.com/deepzec/Bad-Pdf /home/kali/badpdf/ 
wget https://github.com/highmeh/fsse/raw/main/layoffs.pdf 
#wget https://raw.githubusercontent.com/highmeh/fsse/main/layoffs.pdf -O /home/kali/layoffs.pdf 
echo 'badpdf () { cd /home/kali/badpdf ; python2 badpdf.py "$@" ; cd /home/kali ; } ' | tee -a /home/kali/.bashrc >> /home/kali/.zshrc
#!/bin/bash

echo "[+] Downloading bookmarks"
cd /home/kali/Desktop/
wget https://raw.githubusercontent.com/highmeh/fsse/main/fsse_bookmarks.html

echo "[+] Applying fixes"
sudo msfdb init 

echo "[+] Downloading HTML Resources"
sudo rm /var/www/html/*
sudo wget https://raw.githubusercontent.com/highmeh/fsse/main/index.html -O /var/www/html/index.html 
sudo wget https://raw.githubusercontent.com/highmeh/fsse/main/post.php -O /var/www/html/post.php 
sudo systemctl start apache2 

echo "[+] Your system has been set up! Don't forget to import your bookmarks (on your Desktop) into Firefox!"

