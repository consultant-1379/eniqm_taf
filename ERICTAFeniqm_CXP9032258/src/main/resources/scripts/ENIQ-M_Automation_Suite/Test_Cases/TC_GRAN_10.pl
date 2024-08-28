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
my $TCID="TC_GRAN_10";
my $TC_Name="Check for MLPPP topology file";
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
my $MLPPP_txt="/home/nmsadm/ENIQ-M_Automation_Suite/Nodes/ML-PPPRouter.txt";
my $MLPPP_T_FILE="$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/GranNetwork/Redback/MLPPP";
my $MLPPP_S_SymLink="$ENIQ_VOLUME_MT_POINT/gran/topologyData/GranNetwork/Redback/MLPPP";
my $MLPPP_EV_SymLink="$ENIQ_ENIQM_LOC_PATH/gran/topologyData/GranNetwork/Redback/MLPPP";

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
	if (-e $MLPPP_txt)
	{
		if(-z $MLPPP_txt)
		{
			print FT "No MLPPP nodes are present in OSS server";
		}else{
		print FT Date(),">>> Checking MLPPP topology file";
		print FT ENIQM_Lib::Check_Topology_file($MLPPP_T_FILE);
		print FT Date(),">>> Checking the Headder part of MLPPP Topology file";
		Check_Headder();
		print FT Date(),">>> Checking Stats symbolic link";
		print FT ENIQM_Lib::Check_Symbolic_Link($MLPPP_S_SymLink);
		print FT Date(),">>> Checking Events symbolic link";
		print FT ENIQM_Lib::Check_Symbolic_Link($MLPPP_EV_SymLink);
		}
	}else{
	$EXIT_CODE=12;
	die "No such file found '$MLPPP_txt'";
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
		print "$TCID|$TC_Name|$Total_time|$TC_Result";	}
	
print FT "Exit code is:$EXIT_CODE";
close FT;
}
1;
exit($EXIT_CODE);

#subroutine

sub Check_Headder{
my @FILE_Content;
open(FH,"$MLPPP_T_FILE"),or $EXIT_CODE=12,die "'$MLPPP_T_FILE' No such file found\n";
@FILE_Content=<FH>;
close FH;

	if(@FILE_Content)
	{
		if($FILE_Content[0]=~m/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/)
		{
				if($1 ne "nodeFDN")
				{	
				$EXIT_CODE=12;
				die "Headder attribute '$1' is wrong\n";
				}elsif($2 ne "userLabel")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$2' is wrong\n";
				}elsif($3 ne "nodeVersion")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$3' is wrong\n";
				}elsif($4 ne "nodeType")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$4' is wrong\n";
				}elsif($5 ne "sourceType")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$5' is wrong\n";
				}elsif($6 ne "siteFDN")
				{
				$EXIT_CODE=12;
				die "Headder attribute '$6' is wrong\n";
				}else{
				print FT "Headder part is fine\n";
				}
				
		}else{
			$EXIT_CODE=12;
			die "Headder '$FILE_Content[0]' is wrong\n";
		}
	}else{
	$EXIT_CODE=12;
	die "'$MLPPP_T_FILE' file is empty\n";
	}

}




