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
my $TCID="TC_SMOKE_6";
my $TC_Name="Check for CXC.env file";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
my $CXC_env='/etc/opt/ericsson/eniqm/cxc.env';

#output record separator
$\="\n";

##################################################################################
# TestcaseID  : TC_ENIQM_11_check_CXC_env_file
#
# Objective   : This test case verifies the CXC.env file.
#
# Test Steps  : 1.Checks the CXC.env file in path /etc/opt/ericsson/eniqm/
#
#               2.Checks the file permission of CXC.env file
#
#				3.Checks the parameters in CXC.env file
# Status:Initial checkin
# 
# Author:XSHEKAR (shekar.r55@wipro.com)
# 
# Date of Creation:May 14th 2013
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
		print FT Date(),"checking $CXC_env file permission";
		my $permission=`ls -ltr $CXC_env | tr -s ' ' | cut -d' ' -f1`;
		chomp $permission;
		my $nmsadm=`ls -ltr $CXC_env | tr -s ' ' | cut -d' ' -f3`;
		chomp $nmsadm;
		my $nms=`ls -ltr $CXC_env | tr -s ' ' | cut -d' ' -f4`;
		chomp $nms;
		
		if($permission eq "-rwxr-x---")
		{
			print FT ">>>$CXC_env file permission is ok";
		}else
		{
		$EXIT_CODE=12;
			die "$CXC_env file permission is not 750:\n$permission\n";
		}
		print FT Date(),"checking $CXC_env file owner";
		if ( ($nmsadm eq "nmsadm") || ($nms eq "nms") )
		{
		print FT ">>>$CXC_env file user is ok";
		}
		else
		{
		$EXIT_CODE=12;
		die "$CXC_env file owner is not nmsadm:\n$nmsadm\t$nms\tcxc.env\n";
		}
		
		################################ Checking cxc.env parameters #########################################
		
		print FT Date(),"Checking cxc.env parameters\n";
		open(FH,"<$CXC_env") or die "File can not be opened:$!";
		$/=undef;
		my $parameters=<FH>;
		$/="\n";
		close FH;
		
		if ($parameters!~m/ENIQM_MC_ADMNODE=Ericsson/)
		{
			$EXIT_CODE=12;
			die "Parameter 'ENIQM_MC_ADMNODE' is not found in cxc.env";
		}else{
		print FT ">>>Parameter 'ENIQM_MC_ADMNODE' present";
		}
		
		if(($parameters=~m/RBS_RAX_LIC_FILE_REQ=true/) || ($parameters=~m/RBS_RAX_LIC_FILE_REQ=false/))
		{
			print FT ">>>Parameter 'RBS_RAX_LIC_FILE_REQ' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'RBS_RAX_LIC_FILE_REQ' is not found in cxc.env";
		}
		
		if(($parameters=~m/createSymbolicLinks_ENIQ=true/) || ($parameters=~m/createSymbolicLinks_ENIQ=false/) )
		{
			print FT ">>>Parameter 'createSymbolicLinks_ENIQ' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'createSymbolicLinks_ENIQ' is not found in cxc.env";
		}
		
		if(($parameters=~m/createSymbolicLinks_ENIQ_Events=true/) || ($parameters=~m/createSymbolicLinks_ENIQ_Events=false/) )
		{
			print FT ">>>Parameter 'createSymbolicLinks_ENIQ_Events' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'createSymbolicLinks_ENIQ_Events' is not found in cxc.env";
		}
		
		if(($parameters=~m/ENIQ_SON_VIS_Data=true/) || ($parameters=~m/ENIQ_SON_VIS_Data=false/))
		{
			print FT ">>>Parameter 'ENIQ_SON_VIS_Data' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'ENIQ_SON_VIS_Data' is not found in cxc.env";
		}
		
		if(($parameters=~m/LTE_GIS_Data=true/) || ($parameters=~m/LTE_GIS_Data=false/))
		{
			print FT ">>>Parameter 'LTE_GIS_Data' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'LTE_GIS_Data' is not found in cxc.env";
		}
		
		if(($parameters=~m/ENIQ_IPRAN_Data=true/) || ($parameters=~m/ENIQ_IPRAN_Data=false/))
		{
			print FT ">>>Parameter 'ENIQ_IPRAN_Data' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'ENIQ_IPRAN_Data' is not found in cxc.env";
		}
		
		if(($parameters=~m/UTRAN_GIS_Data=true/) || ($parameters=~m/UTRAN_GIS_Data=false/))
		{
			print FT ">>>Parameter 'UTRAN_GIS_Data' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'UTRAN_GIS_Data' is not found in cxc.env";
		}
		
		if(($parameters=~m/generateSubscriberData=true/) || ($parameters=~m/generateSubscriberData=false/))
		{
			print FT ">>>Parameter 'generateSubscriberData' present";
		}else{
			$EXIT_CODE=12;
			die "Parameter 'generateSubscriberData' is not found in cxc.env";
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
		

		
		
		
		
		
		