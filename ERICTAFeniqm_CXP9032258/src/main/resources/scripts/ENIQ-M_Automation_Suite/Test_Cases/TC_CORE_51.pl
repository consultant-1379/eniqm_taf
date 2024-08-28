#!usr/bin/perl

#Module Import
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use lib "/ENIQ-M_Automation_Suite/";
use lib "/home/nmsadm/ENIQ-M_Automation_Suite/";
use ENIQM_Lib;
use ONMR_CS_query_Lib;
use logfile;

#Declaration
#===============================================
my $LOG_DIRECTORY_MAIN='Automation_Test_Logs';
my $TCID="TC_CORE_51";
my $TC_Name="Check for site topology file";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
#===============================================

my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;

my @SITE_XML_PATH=(
"$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/outputfiles/snmp/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/Site/Site"
);

my @SITE_S_SYM_LINK=(
"$ENIQ_ENIQM_LOC_PATH/lte/topologyData/Site/sites.xml",
"$ENIQ_ENIQM_LOC_PATH/utran/topologyData/Site/sites.xml",
"$ENIQ_ENIQM_LOC_PATH/core/topologyData/Site/sites.xml",
"$ENIQ_ENIQM_LOC_PATH/snmp/topologyData/Site/sites.xml",
"$ENIQ_ENIQM_LOC_PATH/tss/topologyData/Site/sites.xml",
"$ENIQ_ENIQM_LOC_PATH/gran/topologyData/Site/Site",
"$ENIQ_VOLUME_MT_POINT/utran/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/core/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/lte/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/snmp/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/tss/topologyData/Site/sites.xml",
"$ENIQ_VOLUME_MT_POINT/gran/topologyData/Site/Site"
);

#output record separator
$\="\n";

##################################################################################
# TestcaseID  : TC_ENIQM_20_Check_AlarmData
#
# Objective   :
#
# Test Steps  : 
#				
#				
#				 
# Status:Initial checkin
# 
# Author:XSHEKAR (shekar.r55@wipro.com)
# 
# Date of Creation:
# 
# Date of Modification:
# 
# Reason for Modification:    
#           
####################################################################################

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
	print FT Date(),">>> Checking site topology files\n";
	print FT "========================================";
	
	foreach(@SITE_XML_PATH)
	{
		print FT ENIQM_Lib::Check_Topology_file($_);
	}

	print FT Date(),">>> Checking symbolic link of site topology files\n";
	print FT "==========================================================";
		
		
	foreach(@SITE_S_SYM_LINK)
	{
		
		print FT ENIQM_Lib::Check_Symbolic_Link($_);
		
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

##################################------Subroutine------##################################

