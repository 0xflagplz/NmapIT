#!/bin/bash

 function usage {
	echo "#     usage						"
	echo "#     > ./name <path_to_targets.txt> -L			"
	echo "#     							"	
	echo "#         						"		
	echo "#     	 -L   	: Large Scan				"	
	echo "#         						"	
	echo "#     		targets.txt 				"	        
	echo "#      	        : should be formatted as followed	"  		
	echo "#     	        : SINGLE IP PER LINE			"	
	echo "#     	     						"
	echo "#     	Line 1>		192.168.1.3			"
	echo "#     	Line 2>		lagplz.htb			"
	echo "#         						"	
	echo "#         						"		
	echo "#		Created by @aChocolateChippPancake 		"
}
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

if [ `whoami` != root ]; then
    echo "Please run this script as root or using sudo"
    exit
fi


#checkk if target.txt was provided
if [ -z "$1" ]
  then
	usage
	exit;
fi
# check for help
if [ $1 = "help" ] || [ $1 = "h" ] || [ $1 = "-h" ] || [ $1 = "-help" ]; then
	usage
	exit;
fi
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


# Taking file input
FILE=$1
tag=""
tag+=$2

needSomeSpace


echo -e "Start Scan"
needSomeSpace
while read LINE; do
	if [[ $LINE = *" "* ]]; then
		echo "ERROR: Line in targets.txt included a space"
		needSomeSpace
		echo "Exiting"
		needSomeSpace
		rm -r scanning_output
		exit	
	else
		mkdir scanning_output/$LINE

		#
	 	# You should comment out scans that do not need be included
	 	#
	 	# This is meant to be altered on the fly while also being able to scan a variety of targets
	 	#
		echo "Scanning For FTP result"
		mkdir scanning_output/$LINE/FTP
		nmap -T4 -p 21 $LINE -oA scanning_output/$LINE/FTP/FTP_out
		needSomeSpace

		echo "Scanning for RDP Ciphers and connection details"
		mkdir scanning_output/$LINE/RDPEnum
		nmap -T4 -p 3389 --script rdp-enum-encryption $LINE -oA scanning_output/$LINE/RDPEnum/RDPEnum_out
		needSomeSpace;
		echo "Scanning for SMB signing"
		mkdir scanning_output/$LINE/SMBShares
		nmap --script=smb-enum-shares.nse,smb-enum-users.nse,smb-os-discovery.nse -p445 $LINE -oA scanning_output/$LINE/SMBShares/SMBShares_out
		needSomeSpace;
		echo "Generic Scan"
		mkdir scanning_output/$LINE/GenericScan
		nmap -T5 --top-ports 100 -O -sC -sV $LINE -oA scanning_output/$LINE/GenericScan/GenericScan_out
		
		if [ $tag = "-L" ]; 
		then
		
			echo "Scanning all the ports..."
			mkdir scanning_output/$LINE/FullPortScan
			nmap -v -T5 -Pn -sV -p- $LINE -oA scanning_output/$LINE/FullPortScan/FullPortScan_out
			needSomeSpace
			echo "Scanning the Top 100 Ports with ScriptScan"
			mkdir scanning_output/$LINE/Top100ScriptScan
			nmap -v -T5 -Pn -sV --script vuln --top-ports 100 $LINE -oA scanning_output/$LINE/Top100ScriptScan/Top100ScriptScan_out
			needSomeSpace
			echo "Scan UDP"
			mkdir scanning_output/$LINE/UDPScan
			nmap -v -T5 -Pn -sU --top-ports 100 $LINE -oA scanning_output/$LINE/UDPScan/UDPScan_out
			needSomeSpace
		else
			echo "Skipping Large Scans"
		fi

	fi
	 
done < $FILE
exit
