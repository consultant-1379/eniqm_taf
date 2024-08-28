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
my $TCID="TC_SMOKE_3";
my $TC_Name="Check for eniqm MC online and offline";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
my $Time;
my $SLEEP_TIME=600;
my $Sleep_time_temp=1;
my $ENIQM_ONLINE_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -online eniqm';
my $ENIQM_OFFLINE_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -offline eniqm -reason=other -reasontext=..';
my $ENIQM_PROCESS_STATUS="ps -eaf | grep -i eniqm | tr -s ' ' | grep  Ds=ENIQM";
my $MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l | grep -i eniqm";
my $SM_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagement';
my $SMC_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagementCore';
my $SMSS_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagementStartStop';
my $SM_ONLINE= '/opt/ericsson/nms_cif_sm/bin/smtool -online SelfManagement';
my $SMC_COLDRESTART= '/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart SelfManagementCore -reason=other -reasontext=..';
my $SMSS_COLDRESTART = '/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart SelfManagementStartStop -reason=other -reasontext=..';
my $Rstate;
#output record separator
$\="\n";
##################################################################################
# TestcaseID  : TC_ENIQM_07_Check_online_and_offline
#
# Objective      : To verify ENIQ-M MC(Managed Component) online and offline.
#
# Prerequisites  : SM application should be up and running. CIF services should be up and running.
#                  ENIQ-M application is installed successfully ENIQ-M is
#                  online .
#
# Test Steps  : 1.Offline and Online the Eniqm MC.
#
#               2.Run the command, ps -eaf | grep -i ENIQM, once ENIQ-M MC is onlined
#         
# Status:Initial checkin
#
# Author:XSHEKAR (shekar.r55@wipro.com)
#
# Date of Creation:May 10th 2013
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
		print Date();
		print FT "Pretest Setup";
		&_setup();
		
	################################ Testcase Execution #########################################
	my @pkg_info=`pkginfo -l ERICeniqm`;
		foreach my $li(@pkg_info)
 		{
			if($li=~/\s+VERSION:\s+(.*)/)
			{	
				$Rstate=$1;
				print FT ">>>The Eniqm Package of R-state:$Rstate is installed presently";
			}
		}
		if ($Rstate eq "")
		{
			$EXIT_CODE=12;
			die "The ENIQM package is not installed";
		}
	
	
	
	
	my $eniqm_status=`$MC_STATUS_CMD`;
	if($eniqm_status=~/started/)
	{	
		&Offline();
		&Online();	
	}else
	{
	&Online();
	&Offline();
	&Online();
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


#Subroutine Offline

sub Offline{
		print FT Date(),"Doing Eniqm MC Offline\n";
	
		`$ENIQM_OFFLINE_CMD`;
		my $eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status=~/offline/)
		{
			print FT "ENIQM MC Offline Successfull\n";
		}
		else
		{
			for($Time=$SLEEP_TIME;$Time>0;$Time--)
			{
				sleep $Sleep_time_temp;
				$eniqm_status="";
				$eniqm_status=`$MC_STATUS_CMD`;
				if($eniqm_status=~/offline/)
				{
					print FT "ENIQM MC Offline Successfull\n";
					last;
				}
			}
		}
		$eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status!~/offline/)
		{  
			$EXIT_CODE=12;
			die " Could not offline EniqM MC:$!";
		}
}


#Subroutine Online

sub Online{
		print FT Date(),"Doing Eniqm MC Online\n";
	
		`$ENIQM_ONLINE_CMD`;
		my $eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status=~/started/)
		{
			print FT "ENIQM MC Online Successfull\n";
		}
		else
		{
			for($Time=$SLEEP_TIME;$Time>0;$Time--)
			{
				sleep $Sleep_time_temp;
				$eniqm_status="";
				$eniqm_status=`$MC_STATUS_CMD`;
				if($eniqm_status=~/started/)
				{
					print FT "ENIQM MC Online Successfull\n";
					last;
				}
			}
		}
		$eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status!~/started/)
		{  
			$EXIT_CODE=12;
			die " Could not online EniqM MC:$!";
		}
}

#Subroutine _setup
sub _setup
{
	my ($sm_status,$smc_status,$smss_status);
	print FT Date(),"To check SM application should be up and running. CIF services should be up and running";
	$sm_status= `$SM_STATUS_CHECK`;
	$smc_status=`$SMC_STATUS_CHECK`;
	$smss_status=`$SMSS_STATUS_CHECK `;
	if(($sm_status=~ /started/) && ($smc_status=~ /started/) && ($smss_status=~ /started/))
	{
		print FT "SM application is up and running ";
	}
	else
	{
		print FT Date(),"Onlinining SM application ";
		if($sm_status!~/started/)
		{   
			print FT "Onlinining SelfManagement ";
			`$SM_ONLINE`;
		}
		elsif($smc_status!~/started/)
		{ 
			print FT Date(),"Onlinining SelfManagementCore ";
			`$SMC_COLDRESTART`;
		}
		elsif($smss_status!~/started/)
		{ 
			print FT Date(),"Onlinining SelfManagementStartStop ";
			`$SMSS_COLDRESTART`;
		}

		for($Time=$SLEEP_TIME;$Time>0;$Time--)
		{
			sleep $Sleep_time_temp;
			$sm_status= `$SM_STATUS_CHECK`;
			$smc_status=`$SMC_STATUS_CHECK`;
			$smss_status=`$SMSS_STATUS_CHECK `;

			if (($sm_status=~ /started/) && ($smc_status=~ /started/) &&($smss_status=~ /started/))
			{
				print FT "SM application successfully onlined ";
				last; 
			}
		}
		
		if($sm_status!~/started/)
		{   
			$EXIT_CODE=12;
			die "SelfManagement could not be onlined:$!";
		}
		elsif($smc_status!~/started/)
		{ 
			$EXIT_CODE=12;
			die "SelfManagementCore Could not be online :$!";
		}
		elsif($smss_status!~/started/)
		{ 
			$EXIT_CODE=12;
			die "SelfManagementStartStop could not be onlined:$!";
		}
	}
}