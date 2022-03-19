# nmapIT


	Scanning script which enables user to utilize host list / alter depth of scan
	===========================================================================================================================
   	usage ./name <path_to_targets.txt>			
    							
 	    						
 		 -L   	: Large Scan				
 	    						
			targets.txt 				        
 	 	        : should be formatted as followed  		
		        : SINGLE IP PER LINE				
		     						
		Line 1>		192.168.1.3			
		Line 2>		lagplz.htb			
								
 	   
	 ===========================================================================================================================
										
	Deafult Scans:
		> nmap -T5 -p 21 --script ftp-anon $LINE -oA scanning_output/$LINE/AnonFTP
		> nmap -T5 -p 3389 --script rdp-enum-encryption $LINE -oA scanning_output/$LINE/RDPEnum
		> nmap -T5 -p 445 --script smb-security-mode $LINE -oA scanning_output/$LINE/SMBSigning

	Large Scan Includes: 
		> nmap -v -T5 -Pn -sV -p- $LINE -oA scanning_output/$LINE/FullPortScan
		> nmap -v -T5 -Pn -sV --script vuln --top-ports 1000 $LINE -oA scanning_output/$LINE/Top1000ScriptScan
		> nmap -v -T5 -Pn -sU --top-ports 100 $LINE -oA scanning_output/$LINE/UDPScan

	===========================================================================================================================
