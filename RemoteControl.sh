#!/bin/bash
#This script is suitable for Ubuntu/Debian only

while true
do
	read -p "[?]Are you root user to start[y/n]" ans
	case $ans in
		y)
			echo "[!]Welcome to Remote Control"
			break;;
		n)
			echo "[!]Please swtich to root user before running this script. Thank you."
			exit;;
		*)
			echo "[!]Invalid input. Please try again."
	esac
done

read -p "[*]Please enter username as installation path:" user
read -p "[*]Enter VPS IP:" ip
read -p "[*]Enter Port:" port
read -p "[*]Username:" suser
npath="/home/$user/nipe"
upath="/home/$user"

PS3="[*]Please enter[1-7]:"
while true
do
	select opt in "Installation - Git and Nmap" "Installation - Nipe and Dnsleaktest" "Be Anonymous" "Stop Anonymous" "VPS - Nmap and Whois" VPS Exit
	do
		case $opt in
		"Installation - Git and Nmap")
		#update package list and install them
		echo "[!]Progress is starting.."
		#update package list and install
		cd $upath
		apt-get update
		apt-get install git
		apt-get install nmap
		break;;
		
		"Installation - Nipe and Dnsleaktest")
		#install nipe from github
		#download the github script and give permission to run script as program
		cd $upath
		git clone https://github.com/htrgouvea/nipe && cd nipe
		cpan install Try::Tiny Config::Simple JSON
		perl nipe.pl install
		cd $upath
		curl -s https://raw.githubusercontent.com/macvk/dnsleaktest/master/dnsleaktest.sh -o dnsleaktest.sh
		chmod +x dnsleaktest.sh
		break;;
		
		"Be Anonymous")
		#nipe can mask your ip address and dns
		#check your current ip and country
		echo "[!]IP checking. You are in:"
		whois $(curl -s ifconfig.me)|grep -i 'country'|awk '{print $2}'|sort|uniq -d; echo

		#nipe commands execute in nipe directory only
		cd $npath
		perl nipe.pl start
		perl nipe.pl restart
		
		#check new ip, country, and dns leak test
		echo "[!]Your nipe:"
		perl nipe.pl status
		echo "[!]DNS leak testing.."
		cd $upath
		./dnsleaktest.sh; echo
		break;;
		
		"Stop Anonymous")
		cd $npath
		echo "[!]Your nipe:"
		perl nipe.pl stop
		perl nipe.pl status
		echo "[!]You are in:"
		whois $(curl -s ifconfig.me)|grep -n 'country'|awk '{print $2}'|sort|uniq -d; echo
		break;;
		
		"VPS - Nmap and Whois")
		#nmap output service version and os
		read -p "[*]Enter[ip/domain name]:" ip2
		read -p "[*]Enter Port[-p number/enter]:" port2
		ssh -t -l $suser $ip -p$port nmap -A $ip2 $port2
		whois $ip2
		break;;
		
		VPS) ssh -l $suser $ip -p$port; break;;
		
		Exit) echo "[!]Thank you. Please try again."; exit;;
		
		*) echo "[!]Invalid input. Please try again."
		
		esac
	done
done