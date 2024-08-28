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
my $TCID="TC_GRAN_4";
my $TC_Name="Check for SCGR topology file";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;

#Declaration related to TC

my $SCGR_T_FILE="$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/SCGR/SCGR";
my $SCGR_S_SymLink="$ENIQ_VOLUME_MT_POINT/gran/topologyData/SCGR/SCGR";
my $SCGR_EV_SymLink="$ENIQ_ENIQM_LOC_PATH/gran/topologyData/SCGR/SCGR";

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
	print FT Date(),">>> Checking SCGR topology file";
	print FT ENIQM_Lib::Check_Topology_file($SCGR_T_FILE);
	print FT Date(),">>> Checking the Headder part of SCGR Topology file";
	Check_Headder();
	print FT Date(),">>> Checking Stats symbolic link";
	print FT ENIQM_Lib::Check_Symbolic_Link($SCGR_S_SymLink);
	print FT Date(),">>> Checking Events symbolic link";
	print FT ENIQM_Lib::Check_Symbolic_Link($SCGR_EV_SymLink);
	
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
		print "$TCID|$TC_Name|$Total_time|$TC_Result";	}
	
print FT "Exit code is:$EXIT_CODE";
close FT;
}
1;
exit($EXIT_CODE);

#subroutine

sub Check_Headder{
my @FILE_Content;
open(FH,"$SCGR_T_FILE"),or $EXIT_CODE=12,die "'$SCGR_T_FILE' No such file found\n";
@FILE_Content=<FH>;
close FH;

	if(@FILE_Content)
	{
		if($FILE_Content[0]=~m/(.*)\|(.*)\|(.*)\|(.*)/)
		{
				if($1 ne "bscName")
				{	
				$EXIT_CODE=12;
				die "Headder attribute '$1' is wrong\n";
				}elsif($2 ne "superChannelGroup")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$2' is wrong\n";
				}elsif($3 ne "superChannel")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$3' is wrong\n";
				}elsif($4 ne "numberOfAbisDevices")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$4' is wrong\n";
				}else{
				print FT "Headder part is fine\n";
				}
				
		}else{
			$EXIT_CODE=12;
			die "Headder '$FILE_Content[0]' is wrong\n";
		}
	}else{
	$EXIT_CODE=12;
	die "'$SCGR_T_FILE' file is empty\n";
	}

}




