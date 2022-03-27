#!/bin/bash

update() {

lg='\033[1;32m'
lr='\033[1;31m'
nc='\033[0m'

#------ Chaves ------#

update="${lg}OK${nc}"
upgrade="${lg}OK${nc}"
auto="${lg}OK${nc}"
compare=0

#--------------------#

clear
echo -e "\r/***************************************/
	\r/*                                     */
	\r/*  Atualizando o sistema... aguarde!  */
	\r/*                                     */
	\r/***************************************/\n"
sudo apt update > /dev/null 2>&1
exit_code1=$?
if [ $exit_code1 -ne $compare ]; then update="${lr}FALHA${nc}"; fi
echo -e "Update............................ [ $update ]"
sudo apt upgrade -y > /dev/null 2>&1
exit_code2=$?
if [ $exit_code2 -ne $compare ]; then upgrade="${lr}FALHA${nc}"; fi
echo -e "Upgrade........................... [ $upgrade ]"
sudo apt autoremove -y > /dev/null 2>&1
exit_code3=$?
if [ $exit_code3 -ne $compare ]; then auto="${lr}FALHA${nc}"; fi
echo -e "Autoremove........................ [ $auto ]"
sleep 3
}

vnc () {
clear
echo -e "\r/*****************************/
	\r/*                           */
	\r/* Instalado VNC... aguarde! */
	\r/*                           */
	\r/*****************************/"


sudo apt install x11vnc -y > /dev/null 2>&1

sudo ufw allow 5900/tcp > /dev/null 2>&1

sudo touch /etc/systemd/system/x11vnc.service

sudo echo "# Description: Custom Service Unit file
# File: /etc/systemd/system/x11vnc.service
[Unit]
Description="x11vnc"
Requires=display-manager.service
After=display-manager.service

[Service]
ExecStart=/usr/bin/x11vnc -loop -nopw -xkb -repeat -noxrecord -noxfixes -noxdamage -forever -rfbport 5900 -display :0 -auth guess -rfbauth /root/.vnc/passwd
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/x11vnc.service

sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
sudo systemctl status x11vnc.service > /dev/null 2>&1
ec=$?
if [ "$ec" -eq 0 ]; then

	clear
	echo -e "\r/***********************************************/
		 \r/*                                             */
		 \r/* Daemon x11vnc.service rodando corretamente! */
	  	 \r/*                                             */
		 \r/***********************************************/"

else
	clear
	echo -e "\r/************************************************************/
		\r/*                                                          */
	  	\r/* Daemon x11vnc.service com problemas ao rodar! verificar! */
	        \r/*                                                          */
		\r/************************************************************/"
		exit 99
fi

sleep 4
clear
echo -e "\r/*********************************/
	\r/*                               */
	\r/* Informe uma senha para o VNC: */
	\r/*                               */
	\r/*********************************/"

x11vnc -storepasswd

}

lightdm () {
clear

echo -e "\r/**********************************/
	\r/*                                */
	\r/* Instalando LightDM... aguarde! */
	\r/*                                */
	\r/**********************************/"
echo -e "\n\n"
sudo apt install lightdm -y
clear
echo -e "\r/**********************************************************************/
	\r/*                                                                    */
	\r/*  O sistema precisa ser reinicializado para concluir a instalação!  */
	\r/*                                                                    */
	\r/*                   Reiniciar agora?         [S/n]                   */
	\r/*                                                                    */
	\r/**********************************************************************/"

read Sn

if [ "$Sn" == "S" ] || [ "$Sn" == "s" ]; then sudo reboot now
else

     clear
     echo -e "\r/****************************/
	      \r/*                          */
   	      \r/*  Instalação concluída!   */
	      \r/*                          */
	      \r/****************************/"
	      exit 1
fi

}

update
vnc
lightdm
