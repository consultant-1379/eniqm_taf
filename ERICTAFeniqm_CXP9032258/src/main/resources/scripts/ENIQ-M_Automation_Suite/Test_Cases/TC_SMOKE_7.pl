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
my $TCID="TC_SMOKE_9";
my $TC_Name="Check for config files";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;

my $ENIQ_VOLUME_MT_POINT=ENIQM_Lib::GET_ENIQ_VOLUME_MT_POINT;
my $ENIQ_ENIQM_LOC_PATH=ENIQM_Lib::GET_ENIQ_ENIQM_LOC_PATH;
my $ENIQ_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_PMDATA_PATH;
my $ENIQ_EVENTS_PMDATA_PATH=ENIQM_Lib::GET_ENIQ_EVENTS_PMDATA_PATH;

my $Config_Path="$ENIQ_VOLUME_MT_POINT/config";
my $pms_xml="$ENIQ_VOLUME_MT_POINT/config/pms.xml";
my $pdm_xml="$ENIQ_VOLUME_MT_POINT/config/pdm.xml";
my $sgw_xml="$ENIQ_VOLUME_MT_POINT/config/sgw.xml";
my $eniqm_xml="$ENIQ_VOLUME_MT_POINT/config/eniqm.xml";
my $eniqmifconfig_dtd="$ENIQ_VOLUME_MT_POINT/config/eniqmifconfig.dtd";

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

	print FT ">>> Checking config files\n";
	
	print FT Date(),">>> Checking directory '$Config_Path'\n";
	if(-d $Config_Path)
	{
		print FT "Directory exist";
	}else{
	$EXIT_CODE=12;
	die "Directory '$Config_Path' does not exist";
	}
	
	print FT Date(),">>> Checking pms.xml config file\n";
	if(-e $pms_xml)
	{
		print FT "File exist";
		&check_user($pms_xml);
	}else{
	$EXIT_CODE=12;
	die "File '$pms_xml' does not exist";
	}
	
	print FT Date(),">>> Checking pdm.xml config file\n";
	if(-e $pdm_xml)
	{
		print FT "File exist";
		&check_user($pdm_xml);
	}else{
	$EXIT_CODE=12;
	die "File '$pdm_xml' does not exist";
	}	
	
	print FT Date(),">>> Checking sgw.xml config file\n";
	if(-e $sgw_xml)
	{
		print FT "File exist";
		&check_user($sgw_xml);
	}else{
	$EXIT_CODE=12;
	die "File '$sgw_xml' does not exist";
	}	
	
	print FT Date(),">>> Checking eniqm.xml config file\n";
	if(-e $eniqm_xml)
	{
		print FT "File exist";
		&check_user($eniqm_xml);
	}else{
	$EXIT_CODE=12;
	die "File '$eniqm_xml' does not exist";
	}

	print FT Date(),">>> Checking eniqmifconfig.dtd file\n";
	if(-e $eniqmifconfig_dtd)
	{
		print FT "File exist";
		&check_user($eniqmifconfig_dtd);
	}else{
	$EXIT_CODE=12;
	die "File '$eniqmifconfig_dtd' does not exist";
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



#subroutine

sub check_user{

my $path=shift;

my ($T_permissions,$T_user,$T_group,$T_date,$T_time)=ENIQM_Lib::GET_Topology_File_INFO($path);


		################################ Checking for Topology file owner #########################################
		print FT Date(),"Checking for FILE owner";
		if($T_user eq "nmsadm")
		{
			print FT "Owner `$T_user` is ok\n";
		}else
			{
			$EXIT_CODE=12;
			die "owner `$T_user` is not valid user\n"; 
			}	
		################################ Checking for Topology file owner #########################################
		print FT Date(),"Checking for group user";
		if($T_group eq "nms")
		{
			print FT "group user `$T_group` is ok\n";
		}else
			{
			$EXIT_CODE=12;
			die "group user `$T_group` is not valid user\n"; 
			}		


}