#!usr/bin/perl
#Module Import
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use lib "/ENIQ-M_Automation_Suite/";
use lib "/home/nmsadm/ENIQ-M_Automation_Suite/";
use ENIQM_Lib;
use logfile;

my $LOG_DIRECTORY_MAIN='Automation_Test_Logs';
my $TCID="TC_SMOKE_8";
my $TC_Name="Check for MC state of Seg_masterservice_CS and ONRM_CS";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


my $SEG_STATUS_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -l Seg_masterservice_CS';
my $ONRM_STATUS_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -l ONRM_CS';


#output record separator
$\="\n";
##################################################################################
# TestcaseID  : 
#
# Objective      : 
#
# Prerequisites  : 
#                  
#                  
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
		print FT Date(),">>> Checking for Seg_masterservice_CS MC status";
		my $seg_status=`$SEG_STATUS_CMD`;
		
		if ( $seg_status=~m/started/)
		{
			print FT "Seg_masterservice_CS is online\n";
		}else{
			$EXIT_CODE=12;
			die "Seg_masterservice_CS MC status is: \n$seg_status\n";
		}
		
		print FT Date(),">>> Checking for ONRM_CS MC status";
		my $onrm_status=`$ONRM_STATUS_CMD`;
		if ( $onrm_status=~m/started/)
		{
			print FT "ONRM_CS is online\n";
		}else{
			$EXIT_CODE=12;
			die "ONRM_CS MC status is: \n$onrm_status\n";
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


