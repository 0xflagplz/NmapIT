#!/bin/bash

 function usage {
	echo "#   usage ./name <path_to_targets.txt>			"
	echo "#    							"
	echo "# 	    						"
	echo "# 	 -L   	: Large Scan				"
	echo "# 	    						"
	echo "#		targets.txt 				        "
	echo "# 	   : should be formatted as followed  		"
	echo "#		   : SINGLE IP PER LINE				"
	echo "#		     						"
	echo "#		Line 1>		192.168.1.3			"
	echo "#		Line 2>		lagplz.htb			"
	echo "#								"
	echo "#								"
	echo "# 	    						"
	echo "#								"		
	echo "#		@aChocolateChippPancake 			"
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
		echo "Scanning For anonymous FTP result"
		nmap -T5 -p 21 --script ftp-anon $LINE -oA scanning_output/$LINE/AnonFTP
		needSomeSpace

		echo "Scanning for RDP Ciphers and connection details"
		nmap -T5 -p 3389 --script rdp-enum-encryption $LINE -oA scanning_output/$LINE/RDPEnum
		needSomeSpace
		echo "Scanning for SMB signing"
		nmap -T5 -p 445 --script smb-security-mode $LINE -oA scanning_output/$LINE/SMBSigning
		needSomeSpace
		
		if [ $2 = "-L" ]; then
		
			echo "Scanning all the ports..."
			nmap -v -T5 -Pn -sV -p- $LINE -oA scanning_output/$LINE/FullPortScan
			needSomeSpace
			echo "Scanning the Top 100 Ports with ScriptScan"
			nmap -v -T5 -Pn -sV --script vuln --top-ports 1000 $LINE -oA scanning_output/$LINE/Top1000ScriptScan
			needSomeSpace
			echo "Scan UDP"
			nmap -v -T5 -Pn -sU --top-ports 100 $LINE -oA scanning_output/$LINE/UDPScan
			needSomeSpace
		else
			echo "Skipping Large Scans"
		fi

	fi
	 
done < $FILE
exit
