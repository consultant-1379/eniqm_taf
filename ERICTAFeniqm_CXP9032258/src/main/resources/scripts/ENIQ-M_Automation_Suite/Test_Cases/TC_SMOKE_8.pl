#!usr/bin/perl
#Module Import
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use lib "/ENIQ-M_Automation_Suite/";
use lib "/home/nmsadm/ENIQ-M_Automation_Suite/";
use ENIQM_Lib;
use logfile;

#Declaration

my $LOG_DIRECTORY_MAIN='Automation_Test_Logs';
my $TCID="TC_SMOKE_10";
my $TC_Name="Check basic setup for testing";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


my $STARTUP="/opt/ericsson/eniqm/bin/starteniqm.sh";
my $CXC="/etc/opt/ericsson/eniqm/cxc.env";
my $ENIQ="/ericsson/eniq/etc/eniq.env";
my $EVENT="/ericsson/eniq/etc/eniqevents.env";

#output record separator
$\="\n";
##################################################################################
# TestcaseID  : 
#
# Objective      : 
#
# Prerequisites  : 
#
# Test Steps  :     
#
# Status:Initial checkin
#
# Author:XSHEKAR (shekar.r55@wipro.com)
#
# Date of Creation:May 9th 2013
#
# Date of Modification:
#
# Reason for Modification:
#########################################################################################################################################################################


#Calling Subroutine
&testcase();

sub testcase()
{
	#Test log file creation
	logfile::create_logfile($LOG_DIRECTORY_MAIN,$TCID);

	#Opening testlog file
	open (FT ,">$LOG_FILE") or $EXIT_CODE=10,die "could not open $LOG_FILE,$!";

	eval
	{
		
	################################ Testcase Execution #########################################

	print FT Date(),">>> Checking the basic setup for testing";
	
	#check the existence of "starteniqm.sh","cxc.env" ,"eniq.env" & "eniqevents.env" files
	print FT Date(),"check the existence of starteniqm.sh file";
	
		if (-e $STARTUP )
		{
		print FT "starteniqm.sh script exists..\n";
		}
		else {
		$EXIT_CODE=12;
		die "starteniqm.sh file doesn't exist either eniqm pkg is not installed or someone have deleted this file...\n";
		}
		
		if (-e $CXC )
		{
		print FT  "cxc.env file exists..\n############################################################\n";
		}
		else {
			$EXIT_CODE=12;
			die "cxc.env file doesn't exist either eniqm pkg is not installed or someone have deleted this file...\n ############################################################\n";
		}
		
	#check for -DEniqMRunAtStart paramter's value.
		
	print FT Date(),">>> check for -DEniqMRunAtStart paramter's value";
	
		open(FILE,"<$STARTUP") or $EXIT_CODE=10,die "could not open $STARTUP,$!";
		if (grep{/DEniqMRunAtStart=false/} <FILE>){
			print FT "-DEniqMRunAtStart is false making it true \n";
				`perl -pi -e 's/DEniqMRunAtStart=false/DEniqMRunAtStart=true/' $STARTUP`;
				if(`cat $STARTUP | grep "DEniqMRunAtStart="`!~m/DEniqMRunAtStart=true/)
		{
		$EXIT_CODE=12;
		die "'DEniqMRunAtStart' parameter value is false in $STARTUP\n";
		}else{
		print FT "changes done successfully";
		}
		
		}
		close FILE;

	print FT "-DEniqMRunAtStart paramter's value is true";
	
	#change the configurable parameter's values in cxc.env
	
	print FT Date(),">>> change the configurable parameter's values in cxc.env";
	
	
	#change the "RBS_RAX_LIC_FILE_REQ" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/RBS_RAX_LIC_FILE_REQ=false/} <FILE>){
	print FT "RBS_RAX_LIC_FILE_REQ parameter is false making it true \n";
	 `perl -pi -e 's/RBS_RAX_LIC_FILE_REQ=false/RBS_RAX_LIC_FILE_REQ=true/' $CXC`;
		 if(`cat $CXC | grep "RBS_RAX_LIC_FILE_REQ"`!~m/RBS_RAX_LIC_FILE_REQ=true/) 
	 {	
	 $EXIT_CODE=12;
		die "'RBS_RAX_LIC_FILE_REQ' parameter is false in $CXC file\n";
	 }else{
		print FT "changes done successfully";
		}
	
	
	}
	close FILE;


	
	
	
	#change the "createSymbolicLinks_ENIQ" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/createSymbolicLinks_ENIQ=false/} <FILE>){
		print FT "createSymbolicLinks_ENIQ parameter is false making it true \n";
		 `perl -pi -e 's/createSymbolicLinks_ENIQ=false/createSymbolicLinks_ENIQ=true/' $CXC`;
				  if(`cat $CXC | grep "createSymbolicLinks_ENIQ"`!~m/createSymbolicLinks_ENIQ=true/) 
		 {
		 $EXIT_CODE=12;
			die "'createSymbolicLinks_ENIQ' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
		
		
		}
	close FILE;

		
	
	
	#change the "createSymbolicLinks_ENIQ_Events" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/createSymbolicLinks_ENIQ_Events=false/} <FILE>){
		print FT "createSymbolicLinks_ENIQ_Events parameter is false making it true \n";
		`perl -pi -e 's/createSymbolicLinks_ENIQ_Events=false/createSymbolicLinks_ENIQ_Events=true/' $CXC`;
			  if(`cat $CXC | grep "createSymbolicLinks_ENIQ_Events"`!~m/createSymbolicLinks_ENIQ_Events=true/)
		 {
			$EXIT_CODE=12;
			die "'createSymbolicLinks_ENIQ_Events' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
		
		
		}
	close FILE;

	
	
	
	#change the "ENIQ_SON_VIS_Data" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/ENIQ_SON_VIS_Data=false/} <FILE>){
		print FT "ENIQ_SON_VIS_Data parameter is false making it true \n";
			`perl -pi -e 's/ENIQ_SON_VIS_Data=false/ENIQ_SON_VIS_Data=true/' $CXC`;
					   if(`cat $CXC | grep "ENIQ_SON_VIS_Data"`!~m/ENIQ_SON_VIS_Data=true/)
		 {
		 $EXIT_CODE=12;
			die "'ENIQ_SON_VIS_Data' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
			
			}
	close FILE;

	
	
	
	#change the "LTE_GIS_Data" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/LTE_GIS_Data=false/} <FILE>){
		print FT "LTE_GIS_Data parameter is false making it true \n";
			`perl -pi -e 's/LTE_GIS_Data=false/LTE_GIS_Data=true/' $CXC`;
					   if(`cat $CXC | grep "LTE_GIS_Data"`!~m/LTE_GIS_Data=true/)
		 {
		 $EXIT_CODE=12;
			die "'LTE_GIS_Data' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
			
			}
	close FILE;

	
	
	
	#change the "ENIQ_IPRAN_Data" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	
	if (grep{/ENIQ_IPRAN_Data=false/} <FILE>){
		print FT "ENIQ_IPRAN_Data parameter is false making it true \n";
			`perl -pi -e 's/ENIQ_IPRAN_Data=false/ENIQ_IPRAN_Data=true/' $CXC`;
				   if (`cat $CXC | grep "ENIQ_IPRAN_Data"`!~m/ENIQ_IPRAN_Data=true/)
		 {
		 $EXIT_CODE=12;
			die "'ENIQ_IPRAN_Data' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
			
		}
	close FILE;	
	
	
	
	
	#change the "UTRAN_GIS_Data" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	
	if (grep{/UTRAN_GIS_Data=false/} <FILE>){
		print FT "ENIQ_IPRAN_Data parameter is false making it true \n";
			`perl -pi -e 's/UTRAN_GIS_Data=false/UTRAN_GIS_Data=true/' $CXC`;
		   if (`cat $CXC | grep "UTRAN_GIS_Data"`!~m/UTRAN_GIS_Data=true/)
		 {
		 $EXIT_CODE=12;
			die "'UTRAN_GIS_Data' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}				
			
		}
	close FILE;

	
	
	
	#change the "generateSubscriberData" parameter value in cxc.env
	open(FILE,"<$CXC") or $EXIT_CODE=10,die "could not open $CXC,$!";
	if (grep{/generateSubscriberData=false/} <FILE>){
	
		print FT "generateSubscriberData parameter is false making it true \n";
			`perl -pi -e 's/generateSubscriberData=false/generateSubscriberData=true/' $CXC`;
			
		if (`cat $CXC | grep "generateSubscriberData"`!~m/generateSubscriberData=true/)
		 {
			$EXIT_CODE=12;
			die "'generateSubscriberData' parameter is false in $CXC file\n";
		 }else{
			print FT "changes done successfully";
			}
		}
	close FILE;
	
	print FT "the configurable parameter's values in cxc.env are fine";
	
	print FT Date(),">>> Restarting ENIQ-M MC";
	{
		ENIQM_Lib::eniqm_ColdRestart();
	}
	print FT "Restarted successfully";
	
	print FT ">>> Waiting for 15 minutes,ENIQ-M is updating topology file";
	sleep 300;
	print FT "15 mins got over, Continuing suite execution";
	
	
	
	};
	
	if($@)
	{
		$End_time=CURRENT_TIME();
		$Total_time=ENIQM_Lib::Time_difference($Start_time,$End_time);
		print FT RED "FAIL:Testcase Failed:$@",RESET;
		$TC_Result="FAIL";
		chomp ($TCID,$TC_Name,$Total_time,$TC_Result);
		print "$TCID|$TC_Name|$Total_time|$TC_Result";
	}
	else
	{
		$End_time=CURRENT_TIME();
		$Total_time=ENIQM_Lib::Time_difference($Start_time,$End_time);
		print FT GREEN "\nPASS:Testcase Passed\n",RESET;
		$TC_Result="PASS";
		chomp ($TCID,$TC_Name,$Total_time,$TC_Result);
		print "$TCID|$TC_Name|$Total_time|$TC_Result";
	}
	
print FT "Exit code is:$EXIT_CODE";
close FT;
}
1;
exit($EXIT_CODE);
