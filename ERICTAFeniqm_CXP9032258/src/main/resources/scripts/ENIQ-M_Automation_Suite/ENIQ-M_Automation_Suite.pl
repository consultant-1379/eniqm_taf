#!/usr/bin/perl

#################################################################################
#
#							ENIQ-M Automation Test Suite
#							============================
#	Revision: PA2
#
#	Author:XSHEKAR(shekar.r55@wipro.com)
#
#	Date of Creation: 24th OCT 2013
#
#   							MODIFICATION SUMMARY
#   ==============================================================================
#
#	Date of Modification: Nov 13th 2013
#
#	Reason for Modification:   Code change for Test suite process display on terminal console    
#
#   ==============================================================================
#
#
#
#
#
#
#
#
#
#
#
###################################################################################

#Module Import
use strict;
use warnings;
use lib "/home/nmsadm/ENIQ-M_Automation_Suite/";
use Result;
use logfile;
use Test_Report;
use ENIQM_Lib;


		
#Declaration
	my @Test_Cases;
	my $passed=0;
	my $Failed=0;
	my $Executed=0;
	my $Total_Time=0;
	my @SMOKE_TC_Details=();
	my @CORE_TC_Details=();
	my @SNMP_TC_Details=();
	my @UTRAN_TC_Details=();
	my @LTE_TC_Details=();
	my @TSS_TC_Details=();
	my @GRAN_TC_Details=();
	my $SMOKE_ref=\@SMOKE_TC_Details;
	my $SNMP_ref=\@SNMP_TC_Details;
	my $UTRAN_ref=\@UTRAN_TC_Details;
	my $LTE_ref=\@LTE_TC_Details;
	my $TSS_ref=\@TSS_TC_Details;
	my $CORE_ref=\@CORE_TC_Details;
	my $GRAN_ref=\@GRAN_TC_Details;
	my $Start_time=CURRENT_TIME();
	my $OSS_Installed;
	my $System_Revision;
	my $REV;
	my $Rstate;
	my $flag=0;
	
#Executing 	ENIQ-M Automation Test Suite
print "\t\t======================================\n";
print "\t\tExecuting ENIQ-M Automation Test Suite\n";
print "\t\t======================================\n";

print Date(),"Checking current user\n";
print "=====================\n";
my $pwd=`pwd`;
chomp $pwd;
my $EXIT_CODE;
$\="\n";


		my $current_user_id='/usr/bin/id';
		my $curr_user=`$current_user_id`;
		chomp($curr_user);
		if($curr_user!~/root/)
		{
			$EXIT_CODE=10;
			die "The current user is $curr_user:Login as root to continue execution\n";
		}else{
			print ">>> The current user is $curr_user\n";
		}
	
#ENIQ-M Pkg and server image details


	my @pkg_info=`pkginfo -l ERICeniqm`;
		foreach my $li(@pkg_info)
 		{
			if($li=~/\s+VERSION:\s+(.*)/)
			{	
				$Rstate=$1;
				$flag=1;
			}
				
		}
		if ($flag==0)
		{
			$Rstate="Not Found";
		}

	my $cist_output=`/opt/ericsson/nms_cif_ist/bin/cist -status | grep Ericsson_masterservice`;
	if($cist_output)
	{
		if($cist_output=~m/Ericsson_masterservice \.+ (OSSRC.*Shipment.*) \.+ (.*) \.+ INSTALLED \/(.*)/)
		{
			$OSS_Installed=$1;
			$System_Revision=$2;
			$REV=$3;
		}else{
			$OSS_Installed="Not Found";
			$System_Revision="Not Found";
			$REV="Not Found";
		}
	}else{
			$OSS_Installed="Not Found";
			$System_Revision="Not Found";
			$REV="Not Found";
		}
	
print "TEST ENVIRONMENT";
print "================";
print "OSS Installed : $OSS_Installed REV: $REV";
print "System Revision : $System_Revision";
print "ENIQ-M package R-state : $Rstate\n";

#Test Result file creation
	print Date(),"Executing Clean Up script ";
	print "=========================";
	logfile::Clean_UP_Log_Files();
	Result::Clean_UP_Report_Files();
	my $RESULT_FILE=Result::create_Restult_file();
	my $LOG_PATH="$pwd/Automation_Test_Logs";

#Executing SMOKE test cases
print "Executing SMOKE test cases";
print "============================";
my $i;
for($i=1;$i<=13;$i++)
{	
	print Date(),"Executing Test Case: TC_SMOKE_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_SMOKE_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{
		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@SMOKE_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@SMOKE_TC_Details,$HTML_TAG);
			my $ERROR_TAG='<tr><td colspan="4" align="center" bgcolor="#FF0000"><b>Test suite execution terminated due to Main test case fail</b></td></tr>';
			push(@SMOKE_TC_Details,$ERROR_TAG);
			print ">>> Result -> $Result\n";
			my $End_time=`date +%H:%M:%S`;
			$Total_Time=ENIQM_Lib::Time_difference($Start_time,$End_time);
			&Test_Report::Print_Result($Executed,$passed,$Failed,$Total_Time,$SMOKE_ref,$SNMP_ref,$UTRAN_ref,$LTE_ref,$TSS_ref,$CORE_ref,$GRAN_ref,$OSS_Installed,$System_Revision,$REV,$Rstate);
			print "==========================================================================";
			print "Test Suite Execution completed\n";
			print "Total Test Cases Executed: $Executed";
			print "Total Test Cases passed: $passed";
			print "Total Test Cases Failed: $Failed";
			print "Total Time Taken To Execute Test Cases:$Total_Time\n";
			print "Test Suite Report -> '$RESULT_FILE'\n";
			print "Test Suite Logs -> '$LOG_PATH'";
			print "==========================================================================";
			die "Test suite execution terminated due to Main test case fail\n";
			
		}
		
	}
		
}

#Executing SNMP test cases	
print "Executing SNMP test cases";
print "============================";	
for( $i=1;$i<=13;$i++)
{	
	print Date(),"Executing Test Case: TC_SNMP_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_SNMP_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@SNMP_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@SNMP_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}

#Executing UTRAN test cases	
print "Executing UTRAN test cases";
print "============================";	
for( $i=1;$i<=3;$i++)
{
	print Date(),"Executing Test Case: TC_UTRAN_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_UTRAN_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@UTRAN_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@UTRAN_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}

#Executing LTE test cases	
print "Executing LTE test cases";
print "============================";	
for( $i=1;$i<=1;$i++)
{	
	print Date(),"Executing Test Case: TC_LTE_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_LTE_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@LTE_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@LTE_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}

#Executing TSS test cases	
print "Executing TSS test cases";
print "============================";	
for( $i=1;$i<=3;$i++)
{	
	print Date(),"Executing Test Case: TC_TSS_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_TSS_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@TSS_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@TSS_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}
#Executing CORE test cases	
print "Executing CORE test cases";
print "============================";	
for( $i=1;$i<=52;$i++)
{
	print Date(),"Executing Test Case: TC_CORE_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_CORE_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@CORE_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@CORE_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}

#Executing GRAN test cases	
print "Executing GRAN test cases";
print "============================";	
for( $i=1;$i<=10;$i++)
{
	print Date(),"Executing Test Case: TC_GRAN_$i";
	print ".......";
	my $output=`perl $pwd/Test_Cases/TC_GRAN_$i.pl`;
	if( $output=~m/(.*)\|(.*)\|(.*)\|(.*)/)
	{

		my $TC_ID=$1;
		my $Test_Case_Name=$2;
		my $TC_Total_time=$3;
		my $Result=$4;
		my $HTML_TAG;
		
		if ( $Result eq "PASS" )
		{
			$passed++;
			$Executed++;
			my $Green_color="#008000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Green_color\">$Result</td></tr>";
			push(@GRAN_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}elsif($Result eq "FAIL")
		{
			$Failed++;
			$Executed++;
			my $Red_color="#FF0000";
			$HTML_TAG="<tr><td><b>$TC_ID</b></td><td>$Test_Case_Name</td><td>$TC_Total_time</td><td bgcolor=\"$Red_color\">$Result</td></tr>";
			push(@GRAN_TC_Details,$HTML_TAG);
			print ">>> Result -> $Result\n";
		}
			
	}	
}
#Generate Report

my $End_time=CURRENT_TIME();
$Total_Time=ENIQM_Lib::Time_difference($Start_time,$End_time);

&Test_Report::Print_Result($Executed,$passed,$Failed,$Total_Time,$SMOKE_ref,$SNMP_ref,$UTRAN_ref,$LTE_ref,$TSS_ref,$CORE_ref,$GRAN_ref,$OSS_Installed,$System_Revision,$REV,$Rstate);
print "==========================================================================";
print "Test Suite Execution completed\n";
print "Total Test Cases Executed: $Executed";
print "Total Test Cases passed: $passed";
print "Total Test Cases Failed: $Failed";
print "Total Time Taken To Execute Test Cases:$Total_Time\n";
print "Test Suite Report -> '$RESULT_FILE'\n";
print "Test Suite Logs -> '$LOG_PATH'";
print "==========================================================================";
