#!/bin/bash

#   usage ./name <path_to_targets.txt>
#    
#		: targets.txt should be formatted as followed     **  SINGLE IP PER LINE  **
#
#			192.168.1.3
#			192.168.1.16
#			flagplz.htb
#


function needSomeSpace {
echo -e " "
echo -e " "
echo -e " "
echo -e " "
echo -e " "
echo -e " "
echo -e " "
echo -e " "
}


# Checking if directory exists
if [ -d "scanning_output" ] 
then
	echo -e "The directory Scanning Output Exists!"
	echo -e "**************************************"
	echo -e "**************************************"
	echo -e "**************************************"
	echo -e "**************************************"
	echo -e "Moving old scanning_output to old_scanning_output"
		if [ -d "old_scanning_output" ] 
		then
			rm -r old_scanning_output
		fi
	mv scanning_output old_scanning_output
	echo -e "**************************************"
	echo -e "**************************************"
	echo -e "**************************************"
	echo -e "**************************************"
fi

# If it does not exist, create it
echo -e "Directory does not exist... making it"
mkdir scanning_output
needSomeSpace

needSomeSpace

# Taking file input
FILE=$1

needSomeSpace


echo -e "Start Scan"
needSomeSpace

while read LINE; do
	target = $LINE
	parentFolder = $LINE
	
	outputText= "_output"
	parentFolder+=$outputText

	if [[ $target = *" "* ]]; then
		echo "ERROR: Line in targets.txt included a space"
		needSomeSpace
		echo "Exiting"
		needSomeSpace
		exit
	else
		mkdir -p scanning_output/"$parentFolder"
		 
		echo "Scanning For anonymous FTP result"
		nmap -T5 -p 21 --script ftp-anon -oN scanning_output/"$parentFolder"/AnonFTP_"$target"
		needSomeSpace

		echo "Scanning for RDP Ciphers and connection details"
		nmap -T5 -p 3389 --script rdp-enum-encryption -oN scanning_output/"$parentFolder"/RDPEnum_"$target"
		needSomeSpace

		echo "Scanning for SMB signing"
		nmap -T5 -p 445 --script smb-security-mode -oN scanning_output/"$parentFolder"/SMBSigning_"$target"
		needSomeSpace



		echo "Scanning all the ports..."
		nmap -v -T5 -Pn -sV -p- -oN scanning_output/"$parentFolder"/FullPortScan_"$target"
		needSomeSpace

		echo "Scanning the Top 100 Ports with ScriptScan"
		nmap -v -T5 -Pn -sV --script vuln --top-ports 1000 -oN scanning_output/"$parentFolder"/Top1000ScriptScan_"$target"
		needSomeSpace

		echo "Scan UDP"
		nmap -v -T5 -Pn -sU --top-ports 100 -oN scanning_output/"$parentFolder"/UDPScan_"$target"
		needSomeSpace
	fi



	 
done < $FILE
