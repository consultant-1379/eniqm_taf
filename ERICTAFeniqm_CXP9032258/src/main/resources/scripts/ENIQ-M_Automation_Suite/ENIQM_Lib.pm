package ENIQM_Lib;
use strict;
use warnings;
use XML::Parser;
use Switch;
use Term::ANSIColor qw(:constants);
use POSIX       qw( strftime );
use Time::Local qw( timegm );
use Time::HiRes qw( gettimeofday );
use base 'Exporter';
our @EXPORT=qw(Date PrintLINE Check_root_user CURRENT_TIME);


#*************************************************#
# Subroutine to print the colored line having "*" #
#*************************************************#
sub PrintLINE_STAR {
print DARK BLUE "____________________________________________________________________________\n****************************************************************************\n", RESET;
return DARK BLUE "____________________________________________________________________________\n****************************************************************************\n", RESET;
}

#*************************************************#
# Subroutine to print the colored line having "*" #
#*************************************************#
sub PrintLINE {
print "=================================================================================\n";
return "=================================================================================\n";

}

#*****************************************************************************#
#  #
#*****************************************************************************#
sub Date{
my $cmd='date +%Y-%m-%d\ %H:%M:%S\ -\>\ ';
return `$cmd`;
}



#*****************************************************************************#
# Subroutine to print the output to log file also on terminal line having "*" #
#*****************************************************************************#
sub PrintOutput{
my $tmp=$_[0];
print $tmp;
return $tmp;
}





#*************************************************#
# Subroutine to check the file format of XML file #
#*************************************************#

sub XMLFormat_Check {
	
	my $xmlfile =$_[0];		# the file to parse
		# initialize parser object and parse the string
	my $parser = XML::Parser->new( ErrorContext => 2 );
	eval { $parser->parsefile( $xmlfile ); };
		# report any error that stopped parsing, or announce success
	if( $@ ) {
		$@ =~ s/at \/.*?$//s;               # remove module line number
		die "\nERROR in '$xmlfile':\n$@\n";
		} else {
		return ">>> '$xmlfile' is well-formed\n";
		}
	}
	
	
	
#************************************************************************#
# Subroutine to get the ENIQ_VOLUME_MT_POINT from eniq.env file 		 #
#************************************************************************#

sub GET_ENIQ_VOLUME_MT_POINT{
$/="\n";
my $MT_POINT;
open(FH,"</ericsson/eniq/etc/eniq.env") or die "Could not found eniq.env file:$!";
my @eniq_env=<FH>;
close FH;
foreach(@eniq_env)
{
	if($_=~m/ENIQ_VOLUME_MT_POINT=(.*)/)
	{
	$MT_POINT=$1;
	chomp $MT_POINT;
	}
}
return $MT_POINT;
}



#************************************************************************#
# Subroutine to get the ENIQ_ENIQM_LOC_PATH from eniqevents.env file 		 #
#************************************************************************#

sub GET_ENIQ_ENIQM_LOC_PATH{
$/="\n";
my $MT_POINT;
open(FH,"</ericsson/eniq/etc/eniqevents.env") or die "Could not found eniqevents.env:$!";
my @eniq_env=<FH>;
close FH;
foreach(@eniq_env)
{
	if($_=~m/ENIQ_ENIQM_LOC_PATH=(.*)/)
	{
	$MT_POINT=$1;
	chomp $MT_POINT;
	}
}
return $MT_POINT;
}


#************************************************************************#
# Subroutine to get the ENIQ_PMDATA_PATH from eniq.env file 		 #
#************************************************************************#

sub GET_ENIQ_PMDATA_PATH{
$/="\n";
my $PMDATA_PATH;
open(FH,"</ericsson/eniq/etc/eniq.env") or die "Could not found eniq.env:$!";
my @eniq_env=<FH>;
close FH;
foreach(@eniq_env)
{
	if($_=~m/ENIQ_PMDATA_PATH=(.*)/)
	{
	$PMDATA_PATH=$1;
	chomp $PMDATA_PATH;
	}
}
return $PMDATA_PATH;
}


#************************************************************************#
# Subroutine to get the ENIQ_EVENTS_PMDATA_PATH from eniqevents.env file 		 #
#************************************************************************#

sub GET_ENIQ_EVENTS_PMDATA_PATH{
$/="\n";
my $MT_POINT;
open(FH,"</ericsson/eniq/etc/eniqevents.env") or die "Could not found eniqevents.env:$!";
my @eniq_env=<FH>;
close FH;
foreach(@eniq_env)
{
	if($_=~m/ENIQ_PMDATA_PATH=(.*)/)
	{
	$MT_POINT=$1;
	chomp $MT_POINT;
	}
}
return $MT_POINT;
}


#********************************************************************************#
# Subroutine to get the file info (type,permissions,size,user,group)    		 #
#********************************************************************************#
#Example to call this function my ($ftype,$permissions,$size,$user,$group)=ENIQM_Lib::GET_File_info("<file_path>");
sub GET_File_info{
	use Fcntl ':mode';
my ($filename,$dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks,$user,$group,$permissions,$filetype,$ftype,@ftypes);
	#
	if ($_[0] ne "") {
			$filename = $_[0];
	} else {
			die "File $filename does not exist:$!\n";
	}
	#
	if (($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = lstat($filename)) {
			$user = getpwuid($uid);
			$group = getgrgid($gid);
	#
			$ftypes[S_IFDIR] = "d";
			$ftypes[S_IFCHR] = "c";
			$ftypes[S_IFBLK] = "b";
			$ftypes[S_IFREG] = "-";
			$ftypes[S_IFIFO] = "p";
			$ftypes[S_IFLNK] = "l";
			$ftypes[S_IFSOCK] = "s";
	#
			$permissions = sprintf "%o", S_IMODE($mode);
			$filetype = S_IFMT($mode);
	#
			$ftype = $ftypes[$filetype];
	#
			return ($ftype,$permissions,$size,$user,$group);
	} else {
			die "File $filename does not exist:$!\n";
	}

}

#*****************************************************************************************#
# Subroutine to get the Topology file INFO($permissions,$user,$group,$date,$time)   #
#*****************************************************************************************#
#Example to call this function my ($permissions,$user,$group,$date,$time)=ENIQM_Lib::GET_Topology_File_INFO("<file_path>");
sub GET_Topology_File_INFO{

	my $path=$_[0];
	if (-e $path)
	{
		my $ls_l_cmd="ls -E $path | tr -s ' ' | cut -f1,3,4,6,7 -d' '";
		my $ls_l_cmd_output=`$ls_l_cmd`;
		my ($permissions,$user,$group,$date,$time)=split(' ', $ls_l_cmd_output);
		$time=~m/(\d\d:\d\d:\d\d)/;
		$time=$1;
		return ($permissions,$user,$group,$date,$time);
	}else
		{
			die "File $path does not exist:$!\n";
		}
}


#*********************************************************************************************************#
# Subroutine to get the Symboic link INFO($permissions,$user,$group,$month,$day,$time,$sym_link)   #
#*********************************************************************************************************#
#Example to call this function my ($permissions,$user,$group,$month,$day,$time,$sym_link)=ENIQM_Lib::GET_Symboic_Link_INFO("<file_path>");
sub GET_Symboic_Link_INFO{
	my $path=$_[0];
	if (-l $path)
	{
		my $ls_l_cmd="ls -E $path | tr -s ' ' | cut -f1,3,4,6,7,11 -d' '";
		my $ls_l_cmd_output=`$ls_l_cmd`;
		my ($permissions,$user,$group,$date,$time,$link)=split(' ', $ls_l_cmd_output);
		$time=~m/(\d\d:\d\d:\d\d)/;
		$time=$1;
		return ($permissions,$user,$group,$date,$time,$link);
	}else
		{
			die "File $path does not exist:$!\n";
		}
}


#*********************************************************************************************************#
# Subroutine to incremate the time with certain interval of seconds   #
#*********************************************************************************************************#
#Example to call this function ENIQM_Lib::Increment_Time_By("<time in the format of hh:mm:ss>,<NO_of_seconds>");
sub Increment_Time_By{
my $current_time=$_[0];
my $Increment_by_sec=$_[1];
					my @stime = split(/:/, $current_time);
					my $current_time_more = 3600*$stime[0] + 60*$stime[1] + $stime[2];
					$current_time_more=$current_time_more+$Increment_by_sec;
					my $hours=($current_time_more/(60*60))%24;if($hours<10){$hours="0$hours";}
					my $mins=($current_time_more/60)%60;if($mins<10){$mins="0$mins";}
					my $secs=$current_time_more%60;if($secs<10){$secs="0$secs";}
					$current_time="$hours:$mins:$secs";
return $current_time;
}



#*********************************************************************************************************#
# Subroutine to decrement the time with certain interval of seconds   #
#*********************************************************************************************************#
#Example to call this function ENIQM_Lib::Decrement_Time_By("<time in the format of hh:mm:ss>,<NO_of_seconds>");
sub Decrement_Time_By{
my $current_time=$_[0];
my $Decrement_by_sec=$_[1];
					my @stime = split(/:/, $current_time);
					my $current_time_more = 3600*$stime[0] + 60*$stime[1] + $stime[2];
					$current_time_more=$current_time_more+$Decrement_by_sec;
					my $hours=($current_time_more/(60*60))%24;if($hours<10){$hours="0$hours";}
					my $mins=($current_time_more/60)%60;if($mins<10){$mins="0$mins";}
					my $secs=$current_time_more%60;if($secs<10){$secs="0$secs";}
					$current_time="$hours:$mins:$secs";
return $current_time;
}

#*********************************************************************************************************#
# Subroutine to convert the time in to seconds   #
#*********************************************************************************************************#
#Example to call this function ENIQM_Lib::Convert_Time_To_sec("<time in the format of hh:mm:ss>");

sub Convert_Time_To_sec{
my $current_time=$_[0];
my @stime = split(/:/, $current_time);
my $current_time_in_secs = 3600*$stime[0] + 60*$stime[1] + $stime[2];
return $current_time_in_secs;
}


#*********************************************************************************************************#
# Subroutine to convert the time in seconds to the format hh:mm:ss   #
#*********************************************************************************************************#
#Example to call this function ENIQM_Lib::Convert_Sec_To_Time("<time in seconds>");

sub Convert_Sec_To_Time{
my $current_time_more=$_[0];
my $hours=($current_time_more/(60*60))%24;if($hours<10){$hours="0$hours";}
					my $mins=($current_time_more/60)%60;if($mins<10){$mins="0$mins";}
					my $secs=$current_time_more%60;if($secs<10){$secs="0$secs";}
					my $current_time="$hours:$mins:$secs";
return $current_time;
}


#****************************************#
# Subroutine to do coldrestart eniqm MC  #
#****************************************#
#Example to call this function ENIQM_Lib::eniqm_ColdRestart;
sub eniqm_ColdRestart{


my $Time;
my $SLEEP_TIME=600;
my $Sleep_time_temp=1;
my $ENIQM_COLDRESTART_CMD='/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart eniqm -reason=other -reasontext=..';
my $MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l eniqm";
my $Cold_Restart_Time;
		`$ENIQM_COLDRESTART_CMD`;
		my $eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status=~/started/)
		{
			$Cold_Restart_Time=`date +%H:%M:%S`;
			chomp $Cold_Restart_Time;
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
					$Cold_Restart_Time=`date +%H:%M:%S`;
					chomp $Cold_Restart_Time;
					last;
				}
			}
		}
		$eniqm_status=`$MC_STATUS_CMD`;
		if($eniqm_status!~/started/)
		{ 
			die " Could not coldrestart EniqM application:\neniqm MC ------>$eniqm_status\n";
		}

return $Cold_Restart_Time;
}

#***************************************************************#
# Subroutine to do check the basic setup to start testin eniqm  #
#***************************************************************#
#Example to call this function ENIQM_Lib::setup();
sub setup{
my @output="";

	print @output;
	my $ENIQM_MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l eniqm";
	my $txf_ENIQ_MC_STATUS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l txf_ENIQ_adapt_1";
	my $Seg_masterservice_CS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l Seg_masterservice_CS";
	my $ONRM_CS_CMD="/opt/ericsson/nms_cif_sm/bin/smtool -l ONRM_CS";
	my $ENIQ="/ericsson/eniq/etc/eniq.env";
	my $EVENT="/ericsson/eniq/etc/eniqevents.env";
	my $CXC="/etc/opt/ericsson/eniqm/cxc.env";
	my @MC=($ENIQM_MC_STATUS_CMD,$txf_ENIQ_MC_STATUS_CMD,$Seg_masterservice_CS_CMD,$ONRM_CS_CMD);
	#checking for eniqm mc status
	foreach(@MC)
	{
		chomp $_;
		if( Check_MC($_) )
			{
			push @output,Check_MC($_);
			}
	}
	if($#output)
	{
		die "MC status\n@output\n";
	}
	
	#checking for eniq.env file
	unless ( -e $ENIQ)
	{
	die "'$ENIQ' file does not exist\n";
	}
	
	#checking for eniqevents.env file
	unless ( -e $EVENT)
	{
	die "'$EVENT' file does not exist\n";
	}

	#check for -DEniqMRunAtStart paramter's value.
	
	my $STARTUP="/opt/ericsson/eniqm/bin/starteniqm.sh";

	open(FILE,"<$STARTUP") or die "'$STARTUP' file does not exist\n";
	if (grep{/DEniqMRunAtStart=false/} <FILE>){
			push (@output,"Warning: 'DEniqMRunAtStart' parameter value is false in File '$STARTUP'\n");
			}
	close FILE;

	#change the configurable parameter's values in cxc.env

	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/RBS_RAX_LIC_FILE_REQ=false/} <FILE>){
	push (@output,"Warning: 'RBS_RAX_LIC_FILE_REQ' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/createSymbolicLinks_ENIQ=false/} <FILE>){
	die "'createSymbolicLinks_ENIQ' parameter value is false in File '$CXC'\n";
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/createSymbolicLinks_ENIQ_Events=false/} <FILE>){
	die "'createSymbolicLinks_ENIQ_Events' parameter value is false in File '$CXC'\n";
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/ENIQ_SON_VIS_Data=false/} <FILE>){
		push (@output,"Warning: 'ENIQ_SON_VIS_Data' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/LTE_GIS_Data=false/} <FILE>){
		push (@output,"Warning: 'LTE_GIS_Data' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/ENIQ_IPRAN_Data=false/} <FILE>){
		push (@output,"Warning: 'ENIQ_IPRAN_Data' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/UTRAN_GIS_Data=false/} <FILE>){
		push (@output,"Warning: 'UTRAN_GIS_Data' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	open(FILE,"<$CXC") or die "'$CXC' file does not exist\n";
	if (grep{/generateSubscriberData=false/} <FILE>){
		push (@output,"Warning: 'generateSubscriberData' parameter value is false in File '$CXC'\n");
	}
	close FILE;
	
	return @output;
}

#***************************************************************#
#     #
#***************************************************************#
#


sub Check_MC{

my $Tmp_MC_cmd=shift;
my $status=`$Tmp_MC_cmd`;
			if($status!~/started/)
			{
				return "$status";
			}else{
					return 0;
				}

}


#***************************************************************#
# Subroutine to increment date by certain number of days	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Increment_Date_By("<date in the format of yy-mm-dd>" ," <no of days>");
sub Increment_Date_By{
my $current_Date=$_[0];
my $No_of_days=$_[1];
my ($y,$m,$d)=split('-',$current_Date);
chomp ($d,$m,$y);
my $date1=timegm(0,0,0,$d,$m-1,$y);
$date1+=$No_of_days*24*60*60;
my $n_y=strftime('%Y', gmtime($date1));
my $n_m=strftime('%m',gmtime($date1));
my $n_d=strftime('%d',gmtime($date1));
return "$n_y-$n_m-$n_d";
}


#***************************************************************#
# Subroutine to Decrement date by certain number of days	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Decrement_Date_By("<date in the format of yy-mm-dd>" , <no of days>);
sub Decrement_Date_By{
my $current_Date=$_[0];
my $No_of_days=$_[1];
my ($y,$m,$d)=split('-',$current_Date);
chomp ($d,$m,$y);
my $date1=timegm(0,0,0,$d,$m-1,$y);
$date1-=$No_of_days*24*60*60;
my $n_y=strftime('%Y', gmtime($date1));
my $n_m=strftime('%m',gmtime($date1));
my $n_d=strftime('%d',gmtime($date1));
return "$n_y-$n_m-$n_d";
}

#***************************************************************#
# Subroutine to convert date in to number of days	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Convert_Date_To_Days("<date in the format of yy-mm-dd>");
sub Convert_Date_To_Days{
my $current_Date=$_[0];
my ($y,$m,$d)=split('-',$current_Date);
chomp ($d,$m,$y);
my $date1=timegm(0,0,0,$d,$m-1,$y);
return "$date1";
}

#***************************************************************#
# Subroutine to convert number of days  to date	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Convert_Days_To_Date("<number of days>");

sub Convert_Days_To_Date{
my $date1=$_[0];
my $n_y=strftime('%Y', gmtime($date1));
my $n_m=strftime('%m',gmtime($date1));
my $n_d=strftime('%d',gmtime($date1));
return "$n_y-$n_m-$n_d";
}

#***************************************************************#
# Subroutine to change the server date	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Change_Server_Date("<date in the format of yy-mm-dd>","<time in the format of hh:mm:ss>");

sub Change_Server_Date{
my $current_Date=$_[0];
my $current_time=$_[1];
my ($H,$M,$S) = split(/:/, $current_time);

my ($y,$m,$d)=split('-',$current_Date);
chomp ($d,$m,$y);
my $date1=timegm(0,0,0,$d,$m-1,$y);
my $n_y=strftime('%y', gmtime($date1));
my $n_m=strftime('%m',gmtime($date1));
my $n_d=strftime('%d',gmtime($date1));

my $new_date="$n_m$n_d$H$M$n_y.$S";
`date $n_m$n_d$H$M$n_y.$S`;
}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib:: 

sub Check_root_user{

		my $current_user_id="whoami";		
		my $curr_user=`$current_user_id`;
		chomp($curr_user);
		if($curr_user!~/root/)
		{
			die "The current user is $curr_user:Login as root to continue execution\n";
		}

}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::Time_difference(<start time in format hh:mm:ss>,<end time in format hh:mm:ss>)
sub Time_difference{
my $Start_time=shift;
my $End_time=shift;
chomp($Start_time,$End_time);
my $Start_time_in_sec=Convert_Time_To_Milli_Sec($Start_time);
my $End_time_in_sec=Convert_Time_To_Milli_Sec($End_time);
my $Time_dif=$End_time_in_sec-$Start_time_in_sec;
my $Total_Time=Convert_Milli_Sec_To_Time($Time_dif);
return $Total_Time;
}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::

sub Check_Topology_file{
my @output;
my $T=shift;


		################################ Checking for Topology file #########################################
		
		push(@output,Date(),">>> Checking Topology file '$T'\n");
		push(@output,"=================================================\n");
		my ($T_permissions,$T_user,$T_group,$T_date,$T_time)=("","","","","");
		($T_permissions,$T_user,$T_group,$T_date,$T_time)=GET_Topology_File_INFO($T);
		push(@output,"Topology file exist\n");
		push(@output,"Topology file information\n");
		push(@output,"===================================================\n");
		push(@output,"File permissions:\t$T_permissions\n");
		push(@output,"File owner:\t$T_user\n");
		push(@output,"File group user:\t$T_group\n");
		push(@output,"File updated Date:\t$T_date $T_time\n");
		push(@output,"===================================================\n");
return @output;

}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::

sub Check_Symbolic_Link{
my @output;
my $S_tmp=shift;


		################################ Checking for Topology file #########################################
		push(@output,Date(),">>> Checking Symbolic link '$S_tmp'\n");
		push(@output,"================================================\n");
		my ($S_permissions,$S_user,$S_group,$S_date,$S_time,$S_link)=("","","","","","");
		($S_permissions,$S_user,$S_group,$S_date,$S_time,$S_link) = GET_Symboic_Link_INFO($S_tmp);
		push(@output,"symbolic link exist\n");
		push(@output,"Symbolic link information\n");
		push(@output,"===================================================\n");
		push(@output,"File permissions:\t$S_permissions\n");
		push(@output,"File owner:\t$S_user\n");
		push(@output,"File group user:\t$S_group\n");
		push(@output,"File updated Date:\t$S_date $S_time\n");
		push(@output,"File Linked to:\t$S_link\n");
		push(@output,"===================================================\n");
return @output;
}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::

sub CURRENT_TIME{

	my ($s,$usec)=gettimeofday();
	my $tsec=int($usec/1000);
	my $time=`date +%T`;
	chomp $time;
	my $T="$time:$tsec";
	return $T;

}

#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::

sub Convert_Time_To_Milli_Sec{
my $Time=shift;
my( $hours, $minutes, $seconds, $millis) = split /:/, $Time;
$millis += 1000 * $seconds;
$millis += 1000 * 60 * $minutes;
$millis += 1000 * 60 * 60 * $hours;
return $millis;
	

}


#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::

sub Convert_Milli_Sec_To_Time{
my $millis=shift;
my $ms;
my $ss;
my $mm;
my $hh;

$ms=$millis%1000;if($ms<10){$ms="00$ms";}elsif($ms<100){$ms="0$ms";}
$ss=($millis/1000)%60;if($ss<10){$ss="0$ss";}
$mm=(($millis/(1000*60))%60);if($mm<10){$mm="0$mm";}
$hh=(($millis/(1000*60*60))%24);if($hh<10){$hh="0$hh";}
return "$hh:$mm:$ss:$ms";
	
}



####################-----------------END-----------------####################
1;

