package Fetch_data_from_Seg_CS;

use strict;
use warnings;
use ENIQM_Lib;
use Switch;
use base 'Exporter';
our @EXPORT=qw();
my $EXIT_CODE=0;
$\="\n";
$"="\n";

sub Get_Node_info{
my $UseCsLibThroughCLI="/home/nmsadm/ENIQ-M_Automation_Suite";
my $csConnection="/home/nmsadm/ENIQ-M_Automation_Suite/Seg_CS_Connection.jar";
my $startcsConnection="/home/nmsadm/ENIQ-M_Automation_Suite/start_seg_csConnection.sh";
if ( -d $UseCsLibThroughCLI )
{
	if (( -e $csConnection) || (-e $startcsConnection))
	{

		my $chmod_cmd_1="chmod 777 $csConnection";
		my $chmod_cmd_2="chmod 777 $startcsConnection";
		my $cmd='/home/nmsadm/ENIQ-M_Automation_Suite/./start_seg_csConnection.sh';
		system($chmod_cmd_1);
		system($chmod_cmd_2);
		system($cmd);
	}else{
	$EXIT_CODE=12;
	die "either '$csConnection' or '$startcsConnection' not found\n";
	}
}else{
	$EXIT_CODE=12;
	die "'$UseCsLibThroughCLI' directory not found\n";
}

}



sub Split_Nodes{

my $csFdns="/home/nmsadm/ENIQ-M_Automation_Suite/csFdns.txt";
my @Node_List=("ERBS","RBS","RNC","RXI");
my (@Seg_Nodes,@ERBS_NODES,@RBS_NODES,@RNC_NODES,@RXI_NODES);
	open(A,"$csFdns") or die"file not found,$!";
	@Seg_Nodes=<A>;
	close A;
	if(@Seg_Nodes)
	{
		foreach(@Seg_Nodes)
		{
			my $tmp_line=$_;
			chomp $tmp_line;
			if ($tmp_line=~m/(.*)\|(.*)/)
			{
				my $Node_FDN=$1;
				my $Node_Type=$2;
				
				if($Node_FDN=~m/SubNetwork=ONRM_ROOT_MO_R,(SubNetwork=.*,MeContext=.*,ManagedElement=.*)/)
				{
					$Node_FDN=$1;
				}
				if($Node_FDN=~m/(SubNetwork=.*,MeContext=.*),ManagedElement=.*/)
				{
					$Node_FDN=$1;
				}
				switch ($Node_Type)
				{
					case "ERBS"
					{
							push(@ERBS_NODES,$Node_FDN);
					}
					
					case "RBS"
					{
							push(@RBS_NODES,$Node_FDN);
					}
					
					case "RNC"
					{
							push(@RNC_NODES,$Node_FDN);
					}
					
					case "RANAG"
					{
							push(@RXI_NODES,$Node_FDN);
					}
					
				}
				
			}
		}
	}else{
		die "Node infromation not found,'$csFdns' file is empty";
		}

		foreach(@Node_List)
		{
			my $node_name=$_;
			switch ($node_name)
				{
					case "ERBS"
					{
							my $ref=\@ERBS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "RBS"
					{
							my $ref=\@RBS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "RNC"
					{
							my $ref=\@RNC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}

					case "RXI"
					{
							my $ref=\@RXI_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				}
				
		}
		
		

}

sub create_new_file
{

  eval
  {
     #Logging execution progress to a log file
     my $log_directory_main=$_[0];
     my $logfile=$_[1];
     my $create_dir="mkdir $log_directory_main";
     my $pwd=`pwd`;
     chomp($pwd);
     my $LOG_FILE="$log_directory_main/$logfile.txt";
     if (-d "$log_directory_main")
     {
         open (FH,">$LOG_FILE") or die "$!";
         close FH;
     }else
      {
         `$create_dir`;
         open (FH ,">$LOG_FILE") or die "$!";
         close FH;
      }
  };
  if($@)
  {
     print "Error:Could not create log file:$@";
  } 


}



sub PUT_DATA_TO_FILE{

my $new_file=shift;
my $ref=shift;
my @content=@$ref;
my $Node_dir="/home/nmsadm/ENIQ-M_Automation_Suite/Nodes";
my $new_file_path="$Node_dir/$new_file.txt";
	if( -e $new_file_path)
	{	
		open(ZT,">$new_file_path"),or die "'$new_file_path' not found,$!";
		if(@content)
				{
				print ZT "@content";
				}
		close ZT;
	}else{
		create_new_file($Node_dir,$new_file);
		open(ZT,">$new_file_path"),or die "'$new_file_path' not found,$!";
		if(@content)
				{
				print ZT "@content";
				}
		close ZT;
	}
}





1;