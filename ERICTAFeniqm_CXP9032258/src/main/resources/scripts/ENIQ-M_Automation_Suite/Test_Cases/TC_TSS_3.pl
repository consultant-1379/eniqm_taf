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
my $TCID="TC_TSS_3";
my $TC_Name="Check Topology file for Isite node";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;


my @NODES;
my $NODE_TXT="/home/nmsadm/ENIQ-M_Automation_Suite/Nodes/Isite.txt";
my $Topology_File;
my $T_PATH;
my $S_PATH;
my $EV_S_PATH;
my $SON_S_PATH;

my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;

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

	print FT Date(),">>> Checking Topology file for Isite nodes";
	print FT "=============================================";
	
	print FT Date(),"Reading Isite node info from '$NODE_TXT'";
	
	open( FH,"$NODE_TXT") or die"could not open '$NODE_TXT'";
	@NODES=<FH>;
	close FH;
	if(@NODES)
	{
	foreach(@NODES)
	{
		my $tmp_FDN=$_;
		chomp $tmp_FDN;
		
		$tmp_FDN=~s/(=|,)/_/g;
		$Topology_File="$tmp_FDN.xml";
		$T_PATH="$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/IS/$Topology_File";
		
		if($T_PATH=~m/$ENIQ_VOLUME_MT_POINT\/outputfiles\/(.*)/)
		{
			$S_PATH="$ENIQ_VOLUME_MT_POINT/$1";
			$EV_S_PATH="$ENIQ_ENIQM_LOC_PATH/$1";
		}else{
			$EXIT_CODE=12;
			die "Topology file path '$T_PATH' path is wrong";
		}
	
		print FT ENIQM_Lib::Check_Topology_file($T_PATH);
		print FT ENIQM_Lib::Check_Symbolic_Link($S_PATH);
		print FT ENIQM_Lib::Check_Symbolic_Link($EV_S_PATH);
	}	
	}else{
		print FT "NO nodes of this nodetype are present in OSS server";
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






