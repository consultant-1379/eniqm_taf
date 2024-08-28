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
my $TCID="TC_SMOKE_7";
my $TC_Name="Check for ENIQ mount paths";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


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
	open (FT ,">$LOG_FILE") or $EXIT_CODE=10,die "$!";

	eval
	{
		
	################################ Testcase Execution #########################################

	
	#checking for eniq.env file
	print FT Date(),">>> Checking for eniq.env file";
	if( -e $ENIQ)
	{
	print FT "eniq.env file exist"
	}else{
	$EXIT_CODE=12;
		die "'$ENIQ' file does not exist\n";	
	}
	
	#checking for eniqevents.env file
	print FT Date(),">>> Checking for eniqevents.env file";
	if ( -e $EVENT)
	{
	print FT "eniqevents.env file exist"
	}else{
		$EXIT_CODE=12;
		die "'$EVENT' file does not exist\n";
	}
	
my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;
	
	#checking for ENIQ_VOLUME_MT_POINT
	print FT Date(),">>> Checking for ENIQ_VOLUME_MT_POINT";
	if ( -d $ENIQ_VOLUME_MT_POINT)
	{
	print FT "$ENIQ_VOLUME_MT_POINT  exist"
	}else{
		$EXIT_CODE=12;
		die "'$ENIQ_VOLUME_MT_POINT' does not exist\n";
	}
	
	#checking for ENIQ_ENIQM_LOC_PATH	
	print FT Date(),">>> Checking for ENIQ_ENIQM_LOC_PATH";
	
	if ( -d $ENIQ_ENIQM_LOC_PATH)
	{
	print FT "$ENIQ_ENIQM_LOC_PATH  exist"
	}else{
		$EXIT_CODE=12;
		die "'$ENIQ_ENIQM_LOC_PATH' does not exist\n";
	}
	
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
