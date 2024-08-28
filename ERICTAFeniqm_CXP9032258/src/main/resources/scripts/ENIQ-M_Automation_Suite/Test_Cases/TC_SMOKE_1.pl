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
my $TCID="TC_SMOKE_2";
my $TC_Name="Check for eniqm MC cold restart";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
my $Time;
my $SLEEP_TIME=600;
my $Sleep_time_temp=1;
my $ENIQM_COLDRESTART_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart eniqm -reason=other -reasontext=..';
my $ENIQM_PROCESS_STATUS="ps -eaf | grep -i eniqm | tr -s ' ' | grep  Ds=ENIQM";
my $MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l eniqm";
my $SM_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagement';
my $SMC_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagementCore';
my $SMSS_STATUS_CHECK = '/opt/ericsson/nms_cif_sm/bin/smtool -l SelfManagementStartStop';
my $SM_ONLINE= '/opt/ericsson/nms_cif_sm/bin/smtool -online SelfManagement';
my $SMC_COLDRESTART= '/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart SelfManagementCore -reason=other -reasontext=..';
my $SMSS_COLDRESTART = '/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart SelfManagementStartStop -reason=other -reasontext=..';

#output record separator
$\="\n";
##################################################################################
# TestcaseID  : TC_ENIQM_05_RestartCold
#
# Objective      : To verify a restart cold on the ENIQ-M MC (Managed Component).
#
# Prerequisites  : SM application should be up and running. CIF services should be up and running.
#                  ENIQ-M application is installed successfully ENIQ-M is
#                  online .
#
# Test Steps  : 1.coldrestarting the Eniqm MC.
#
#               2.Run the command, ps -eaf | grep -i ENIQM, once ENIQ-M MC is coldrestarted
#                 to check whether the process id.        
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
		print FT Date(),"Checking Pretest Setup";
		&_setup();
		
	################################ Testcase Execution #########################################
	my $eniqm_status=`$MC_STATUS_CMD`;
	if($eniqm_status=~/started/)
		{
			print FT Date(),"coldrestarting  the Eniqm MC";
			
				`$ENIQM_COLDRESTART_CMD`;
				$eniqm_status=`$MC_STATUS_CMD`;
				if($eniqm_status=~/started/)
				{
					print FT ">>> coldrestarted Successfully\n";
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
							print FT ">>>> coldrestarted\n";
							last;
						}
					}
				}
				$eniqm_status=`$MC_STATUS_CMD`;
				if($eniqm_status!~/started/)
				{  
					$EXIT_CODE=12;
					die " Could not coldrestart EniqM application:$!";
				}
				
			print FT Date(),">>> Waiting for 5 minutes,ENIQ-M is updating topology file";
			print FT ".............     ";
			sleep 300;
			print FT "5 mins got over, Continuing suite execution";
	}else{
			$EXIT_CODE=12;
			die " Could not coldrestart EniqM application\n eniqm MC status is:\n'$eniqm_status'\n:$!";
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


#Subroutine _setup
sub _setup
{
	my ($sm_status,$smc_status,$smss_status);
	print FT "To check SM application should be up and running. CIF services should be up and running";
	$sm_status= `$SM_STATUS_CHECK`;
	$smc_status=`$SMC_STATUS_CHECK`;
	$smss_status=`$SMSS_STATUS_CHECK `;
	if(($sm_status=~ /started/) && ($smc_status=~ /started/) && ($smss_status=~ /started/))
	{
		print FT "SM application is up and running ";
	}
	else
	{
		print FT "Onlinining SM application ";
		if($sm_status!~/started/)
		{   
			print FT "Onlinining SelfManagement ";
			`$SM_ONLINE`;
		}
		elsif($smc_status!~/started/)
		{ 
			print FT "Onlinining SelfManagementCore ";
			`$SMC_COLDRESTART`;
		}
		elsif($smss_status!~/started/)
		{ 
			print FT "Onlinining SelfManagementStartStop ";
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