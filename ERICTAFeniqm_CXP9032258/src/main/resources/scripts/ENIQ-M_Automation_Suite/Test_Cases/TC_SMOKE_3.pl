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
my $TCID="TC_SMOKE_4";
my $TC_Name="eniqm MC selftest";
my $TC_Result;
my $Total_time=0;
my $Start_time=CURRENT_TIME();
my $End_time=0;
my $EXIT_CODE=0;
my $Time;
my $SLEEP_TIME=600;
my $Sleep_time_temp=1;
my $ENIQM_ONLINE_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -online eniqm';
my $MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l | grep -i eniqm";
my $Rstate;
#output record separator
$\="\n";

##################################################################################
# TestcaseID  : TC_ENIQM_12_MC_selftest
#
# Objective   : This test case does eniqm MC selftest in smgui.
#
# Test Steps  : Checks eniqm selftest 0 to selftest 5.
#
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
	
		#print FT ENIQM_Lib::PrintLINE_STAR;
		#print FT ENIQM_Lib::PrintOutput(">>>>> Executing testcase:\t$TCID\n");
		
		################################ Testcase Execution #########################################
		########################### Check eniqm package ####################################
		print FT "Check eniqm package";
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
			die "The ENIQM package is not exist to uninstall";
		}
		
		########################### Check eniqm MC status ####################################
		print FT "checking for eniqm MC in SM";
		my $eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status=~/started/)
		{	
			print FT "eniqm MC is online";
			&SelfTest();
		}elsif($eniqm_status=~/offline/)
			{
			print FT "eniqm MC is offline";
			&Online();
			&SelfTest();
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

		
#Subroutine Online

sub Online{
		print FT "Doing Eniqm MC Online\n";
	
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

#Subroutine SelfTest		
	
	sub SelfTest{	
	
		print FT "checking  eniqm MC selftest";
		print FT "Selftest 0";
		my $Selftest_0=` /opt/ericsson/nms_cif_sm/bin/smtool -selftest eniqm 0`;
		if ($Selftest_0=~m/0;Success: Instrumentation file written: \/var\/opt\/ericsson\/eniqm\/instrumentation\/ENIQM_INSTRUMENTATION.txt/)
			{
			print FT ">>>Selftest 0  ok\n$Selftest_0";
			}else
			{
			die "Selftest 0  failed\n$Selftest_0";
			}
			
		print FT "Selftest 1";
		my $Selftest_1=` /opt/ericsson/nms_cif_sm/bin/smtool -selftest eniqm 1`;
		if ($Selftest_1=~m/0;The mount point \/ossrc\/data\/pmMediation\/pmData\/outputfiles exists and has write permissions/)
			{
			print FT ">>>Selftest 1  ok\n$Selftest_1";
			}else
			{
			die "Selftest 1  failed\n$Selftest_1";
			}	
		
		print FT "Selftest 2";
		my $Selftest_2=` /opt/ericsson/nms_cif_sm/bin/smtool -selftest eniqm 2`;
		if (($Selftest_2=~m/0;Subscription to Notification Agent is valid\./) && ($Selftest_2=~m/Test for connection to Seg_masterservice_CS was successful\./) && ($Selftest_2=~m/Test for connection to Seg_masterservice_CS was successful\./))
			{
			print FT ">>>Selftest 2  ok\n$Selftest_2";
			}else
			{
			die "Selftest 2  failed\n$Selftest_2";
			}
		
		print FT "Selftest 3";
		my $Selftest_3=` /opt/ericsson/nms_cif_sm/bin/smtool -selftest eniqm 3`;
		if ($Selftest_3=~m/0;All required parameters are present/)
			{
			print FT ">>>Selftest 3  ok\n$Selftest_3";
			}else
			{
			die "Selftest 3  failed\n$Selftest_3";
			}

		print FT "Selftest 4";
		my $Selftest_4=` /opt/ericsson/nms_cif_sm/bin/smtool -selftest eniqm 4`;
		if ($Selftest_4=~m/0;ServerTraceAgent, error and event sent successfully/)
			{
			print FT ">>>Selftest 4  ok\n$Selftest_4";
			}else
			{
			die "Selftest 4  failed\n$Selftest_4";
			}
			
	}


		
		
		