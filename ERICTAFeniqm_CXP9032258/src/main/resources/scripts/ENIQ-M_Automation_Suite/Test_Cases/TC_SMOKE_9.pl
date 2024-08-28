#!usr/bin/perl
#Module Import
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use lib "/ENIQ-M_Automation_Suite/";
use lib "/home/nmsadm/ENIQ-M_Automation_Suite/";
use Fetch_data_from_Seg_CS;
use Fetch_data_from_ONRM_CS;
use ENIQM_Lib;
use logfile;

#Declaration

my $LOG_DIRECTORY_MAIN='Automation_Test_Logs';
my $TCID="TC_SMOKE_12";
my $TC_Name="Export Node information form ONRM_CS";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


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
	print FT Date(),">>> Exporting Node Information from ONRM_CS";
	Fetch_data_from_ONRM_CS::Get_Node_info();
	my $csFdns_txt='/home/nmsadm/ENIQ-M_Automation_Suite/ONRM_CS_Nodes_INFO.txt';
	if(-e $csFdns_txt)
	{
		print FT "Node infromation successfully exported form ONRM_CS";
	}else{
		$EXIT_CODE=12;
		die "'$csFdns_txt' File not found, Node infromation not exported form ONRM_CS\n";
	}
	
	print FT Date(),">>> Separating node Infromation and moving it to different files on basis of ManagedElementType "; 
	Fetch_data_from_ONRM_CS::Split_Nodes();
	my $Nodes='/home/nmsadm/ENIQ-M_Automation_Suite/Nodes';
	if(-d $Nodes)
	{
	print FT "Successfully done";
	}else{
		$EXIT_CODE=12;
		die "'$Nodes' Directory not found\n";
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
