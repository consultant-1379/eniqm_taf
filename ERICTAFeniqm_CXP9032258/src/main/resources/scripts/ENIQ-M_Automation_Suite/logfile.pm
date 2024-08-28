#------------------------------------------------------------------------
#Description:Creates a log file to log the progress of testcase execution
#------------------------------------------------------------------------

#---------------------------------------------------------------
#Usage:If the logfile creation is for tcid RC5ENIQM_NWS_A:1.1.3 
#logfile::create_logfile(Test_Logs RC5ENIQM_NWS_A:1.1.3)
#---------------------------------------------------------------

package logfile;

use base 'Exporter';
our @EXPORT=qw($LOG_FILE create_logfile);
our $LOG_FILE;

sub create_logfile
{
  eval
  {
     #Logging execution progress to a log file
     my $log_directory_main=$_[0];
     my $logfile=$_[1];
     my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
     my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
     my $year = 1900 + $yearOffset;
     chomp(my $my_time="$dayOfMonth$months[$month]$year$hour$minute$second");
     my $create_dir="mkdir $log_directory_main";
     my $pwd=`pwd`;
     chomp($pwd);
     $LOG_FILE="$pwd/$log_directory_main/$my_time\:\:$logfile.log";
     if (-d "$log_directory_main")
     {
         open (FH,">$LOG_FILE") or die "$!";
         print FH "The directory $log_directory_main exists";
         close FH;
     }else
      {
         `$create_dir`;
         open (FH ,">$LOG_FILE") or die "$!";
         print FH "The directory $log_directory_main does not exist";
         print FH "Created directory $log_directory_main";
         close FH;
      }
  };
  if($@)
  {
     print "Error:Could not create log file:$@";
  } 
}


#***************************************************************#
# 	    #
#***************************************************************#
#Example to call this function ENIQM_Lib::


sub Clean_UP_Log_Files{

my $LOG_PATH='/home/nmsadm/ENIQ-M_Automation_Suite/Automation_Test_Logs';
my $CURRENT_DATE=`date +%Y-%m-%d`;
my $flag=0;

	print "Deleting three days Old Log files\n";
	
	if(-d $LOG_PATH)
	{
		my @LS_OUTPUT=`ls $LOG_PATH`;
		foreach my $tmp_File (@LS_OUTPUT)
		{
			chomp $tmp_File;
			$tmp_File="$LOG_PATH/$tmp_File";
			my $FILE_M_Date=`ls -E $tmp_File | tr -s ' ' | cut -f6 -d' '`;
			
			my $Choice=Check_dif($CURRENT_DATE,$FILE_M_Date);
			if($Choice==1)
			{
				$flag=1;
				print "Deleting File -> $tmp_File";
				`rm $tmp_File`;
				if(-e $tmp_File)
				{
					print ">>> File '$tmp_File' not deleted succesfully\n";
				}else{
					print ">>> File Deleted successfully\n";
				}
				
			}
		}
		
		if($flag==0)
		{
			print ">>> There is no 3 Days old Log files"; 
		}
		print " Execution completed";
		print "=========================\n";
	}else{
	print " No such directory found '$LOG_PATH' : $!\n";
	}
}

sub Check_dif{

my $C_date=shift;
my $F_date=shift;
my $C_Y;
my $C_M;
my $C_D;
my $F_Y;
my $F_M;
my $F_D;


if( $C_date=~m/(\d\d\d\d)-(\d\d)-(\d\d)/)
{
	$C_Y=$1;
	$C_M=$2;
	$C_D=$3;
}

if( $F_date=~m/(\d\d\d\d)-(\d\d)-(\d\d)/)
{
	$F_Y=$1;
	$F_M=$2;
	$F_D=$3;
}


if( $F_Y==$C_Y )
{	

	if($F_M<$C_M)
	{
		return 1;
		}elsif($F_M==$C_M){
		

				if($F_D<$C_D){
						my $diff=$C_D-$F_D;
						if($diff > 3){
							return 1;
							}else{
								return 0;
								}
					}elsif($F_D>$C_D){
						return 0;
						}elsif($F_D==$C_D){
							return 0;
							}
		}elsif($F_M>$C_M){
			return 0;
			}elsif($F_M<$C_M){
				return 1;
				}	
}elsif($F_Y<$C_Y){
	return 1;
	}elsif($F_Y>$C_Y){
		return 0;
		}

}



1;
