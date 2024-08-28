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
my $TCID="TC_SMOKE_13";
my $TC_Name="Check for ENIQ-M Directories";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
my @Result;

my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;

#output record separator
$\="\n";
$"="\n";
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

	#Topology directories
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/snmp");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/subscriberData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/AXE");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/EMRSAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/MSCClusterAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/MiOMFAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/Pool");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/HlrBSAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/IMSGWMFAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/HADDRESS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/CELLO");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/CoreNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/HLRBladeCluster");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/MSCCluster");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/core/topologyData/AXE/SymLink");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/CELL");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/GranNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/MCTR");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/TG");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/SCGR");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/LBG");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/GranAssociations");
    &Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran/topologyData");      
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/gran/topologyData/GranNetwork/Redback");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran/topologyData/Associations");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran/topologyData/IpRanNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran/topologyData/STN");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/ipran/topologyData/IpRanNetwork/Connection");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/fmData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/fmData/FullExport");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/fmData/alarms");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/fmData/events");	
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/gisData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/gisData/Cell");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/gisData/deltaCell");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData/ERBS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData/deltaERBS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/lte/topologyData/deltacmchanges");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/snmp/topologyData"); 
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/snmp/topologyData/Nodes");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/snmp/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/AXD301");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/AXE");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/IS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/tss/topologyData/TSSISAssoc");
    &Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/GIS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/GIS/RNC");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/GIS/UtranCell");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/RBS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/RBS_info");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/RNC");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/RXI");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/outputfiles/utran/topologyData/Site");
	#Directories for ENIQ stats
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/ipran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/lte");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/snmp");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/subscriberData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/AXE");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/EMRSAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/MSCClusterAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/MiOMFAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/Pool");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/HlrBSAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/IMSGWMFAssoc");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/HADDRESS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/CELLO");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/CoreNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/HLRBladeCluster");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/core/topologyData/MSCCluster");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/CELL");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/GranNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/GranNetwork/Redback");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/MCTR");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/TG");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/SCGR");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/LBG");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/gran/topologyData/GranAssociations");	
    &Check_directory("$ENIQ_VOLUME_MT_POINT/ipran/topologyData");     
	&Check_directory("$ENIQ_VOLUME_MT_POINT/ipran/topologyData/Associations");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/ipran/topologyData/IpRanNetwork");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/ipran/topologyData/STN");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/ipran/topologyData/IpRanNetwork/Connection");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/lte/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/lte/topologyData/ERBS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/lte/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/snmp/topologyData"); 
	&Check_directory("$ENIQ_VOLUME_MT_POINT/snmp/topologyData/Nodes");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/snmp/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData/AXD301");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData/AXE");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData/IS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData/Site");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/tss/topologyData/TSSISAssoc");
    &Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/RNC");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/RBS");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/RBS_info");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/RNC");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/RXI");
	&Check_directory("$ENIQ_VOLUME_MT_POINT/utran/topologyData/Site");
	#Directories for ENIQ EVENTS
	&Check_directory("$ENIQ_ENIQM_LOC_PATH");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/lte");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/snmp");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/subscriberData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/AXE");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/Site");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/MSCClusterAssoc");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/Pool");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/HlrBSAssoc");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/IMSGWMFAssoc");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/HADDRESS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/CELLO");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/CoreNetwork");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/HLRBladeCluster");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/core/topologyData/MSCCluster");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/CELL");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/GranNetwork");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/MCTR");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/Site");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/TG");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/SCGR");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/LBG");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/GranAssociations");     
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/gran/topologyData/GranNetwork/Redback");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/fmData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/fmData/FullExport");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/fmData/alarms");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/fmData/events");	
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/gisData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/gisData/Cell");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/gisData/deltaCell");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/topologyData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/topologyData/ERBS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/topologyData/deltaERBS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/son/topologyData/deltacmchanges");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/snmp/topologyData"); 
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/snmp/topologyData/Nodes");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/snmp/topologyData/Site");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData/AXD301");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData/AXE");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData/IS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData/Site");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/tss/topologyData/TSSISAssoc");
    &Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/GIS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/GIS/RNC");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/GIS/UtranCell");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/RBS");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/RBS_info");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/RNC");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/RXI");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/utran/topologyData/Site");
	&Check_directory("$ENIQ_ENIQM_LOC_PATH/lteTopologyData");
	my $i=1;
		for($i,$i<=50,$i++)
		{
		&Check_directory("$ENIQ_ENIQM_LOC_PATH/lteTopologyData/dir$i");
		}
	
		if(@Result)
		{
		$EXIT_CODE=12;
		die "@Result";
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

#subroutines

sub Check_directory{

my $DIR_PATH=shift;
print FT Date(),">>> checking Directory '$DIR_PATH'";

	if( -e $DIR_PATH)
		{
				print FT "Directory exist";
			
		}else{
				push(@Result,"Directoy not found,'$DIR_PATH'");
			 }

}