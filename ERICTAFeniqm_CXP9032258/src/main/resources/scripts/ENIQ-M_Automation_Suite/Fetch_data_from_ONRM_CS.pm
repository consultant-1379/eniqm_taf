package Fetch_data_from_ONRM_CS;

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
my $csConnection="/home/nmsadm/ENIQ-M_Automation_Suite/ONRM_CS_Connection.jar";
my $startcsConnection="/home/nmsadm/ENIQ-M_Automation_Suite/start_onrm_csConnection.sh";
if ( -d $UseCsLibThroughCLI )
{
	if (( -e $csConnection) || (-e $startcsConnection))
	{

		my $chmod_cmd_1="chmod 777 $csConnection";
		my $chmod_cmd_2="chmod 777 $startcsConnection";
		my $cmd='/home/nmsadm/ENIQ-M_Automation_Suite/./start_onrm_csConnection.sh';
		system($chmod_cmd_1);
		system($chmod_cmd_2);
		system($cmd);
	}else{
	$EXIT_CODE=12;
	die "Either '$csConnection' or '$startcsConnection' not found\n";
	}
}else{
	$EXIT_CODE=12;
	die "'$UseCsLibThroughCLI' directory not found\n";
}

}



sub Split_Nodes{
my (@ONRM_NODES,@ML_PPPRouter_NODES,@STN_NODES,@MSCServer_NODES,@LANSwitch_NODES,@H2S_NODES,@AXE_NODES,@AXD301_NODES,@HP_MRFP_NODES,@I_CSCF_NODES,@SLF_NODES,@HSS_SM_NODES,@E_CSCF_NODES,@IMS_CO_ICS_NODES,@MRFC_NODES,@SBG_NODES,@EPG_NODES,@MiO_NODES,@HLR_BS_NODES,@BCS_M_NODES,@BCS_VC_NODES,@PGM_MWI_NODES,@PGM_AP_WUIGM_NODES,@PGM_PXD_NODES,@PGM_AP_NODES,@PGM_WUIGM_NODES,@SmartMetro_NODES,@EdgeRouter_NODES,@VLR_NODES,@HLR_NODES,@Isite_NODES,@IPWorks_NODES,@CSCF_NODES,@S_CSCF_NODES,@SCF_NODES,@SASN_NODES,@PGM_NODES,@P_CSCF_NODES,@IMS_M_NODES,@HSS_FE_NODES,@CUDB_NODES,@XC_NODES,@AUC_NODES,@FNR_NODES,@CPG_NODES,@SGSN_NODES,@ACME_NODES,@CGSN_NODES,@CS_AS_NODES,@CS_DS_NODES,@CS_MS_NODES,@CS_CDS_NODES,@DHCPServer_NODES,@DNSServer_NODES,@Firewall_NODES,@GGSN_NODES,@HSS_NODES,@HOTSIP_NODES,@IPRouter_NODES,@MGC_NODES,@MRF_PTT_NODES,@MTAS_NODES,@NTP_NODES,@PTT_AS_NODES,@ProtocolServer_NODES,@SAPC_NODES,@SCP_T_NODES,@SMPC_NODES,@SSF_NODES,@STP_NODES,@TRC_NODES,@TSC_NODES,@TSCServer_NODES,@MSC_NODES,@MGW_NODES,@BSC_NODES);
my $csFdns="/home/nmsadm/ENIQ-M_Automation_Suite/ONRM_CS_Nodes_INFO.txt";
my @Node_List=("ML-PPPRouter","MSCServer","STN","LANSwitch","H2S","AXE","AXD301","I-CSCF","SLF","HSS-SM","E-CSCF","IMS-CO-ICS","MRFC","SBG","EPG","MiO","HLR-BS","BCS-M","BCS-VC","PGM-MWI","PGM-AP-WUIGM","PGM-PXD","PGM-AP","PGM-WUIGM","SmartMetro","EdgeRouter","VLR","HLR","Isite","IPWorks","CSCF","S-CSCF","SCF","SASN","PGM","P-CSCF","IMS-M","HSS-FE","CUDB","XC","AUC","FNR","CPG","SGSN","ACME","CGSN","CS-AS","CS-DS","CS-MS","CS-CDS","DHCPServer","DNSServer","Firewall","GGSN","HP-MRFP","HSS","HOTSIP","IPRouter","MGC","MRF-PTT","MTAS","NTP","PTT-AS","ProtocolServer","SAPC","SCP-T","SMPC","SSF","STP","TRC","TSC","TSCServer","MSC","MGW","BSC");
	open(A,"$csFdns") or die"file not found,$!";
	@ONRM_NODES=<A>;
	close A;
	if(@ONRM_NODES)
	{
		foreach(@ONRM_NODES)
		{
			my $tmp_line=$_;
			chomp $tmp_line;
			if ($tmp_line=~m/(.*)\|(.*):/)
			{	
				
				my $Node_FDN=$1;
				my $Node_Type=$2;

				if( $Node_Type=~m/:/)
				{
					my @tmp_array=split(':',$Node_Type);
					$Node_Type=$tmp_array[0];
				}
				
				if($Node_FDN=~m/SubNetwork=ONRM_ROOT_MO,(SubNetwork=.*,ManagedElement=.*)/)
				{
					$Node_FDN=$1;
				}
				if($Node_FDN=~m/(SubNetwork=.*,ManagedElement=.*)/)
				{
					$Node_FDN=$1;
				}
				switch ($Node_Type)
				{	
					case "ML-PPPRouter"
					{
							push(@ML_PPPRouter_NODES,$Node_FDN);
					}
					case "STN"
					{
							push(@STN_NODES,$Node_FDN);
					}
					case "PGM-MWI"
					{
							push(@PGM_MWI_NODES,$Node_FDN);
					}
					case "EdgeRouter"
					{
							push(@EdgeRouter_NODES,$Node_FDN);
					}
					case "MSCServer"
					{
							push(@MSCServer_NODES,$Node_FDN);
					}
					
					case "LANSwitch"
					{
							push(@LANSwitch_NODES,$Node_FDN);
					}
					case "H2S"
					{
							push(@H2S_NODES,$Node_FDN);
					}
					case "AXE"
					{
							push(@AXE_NODES,$Node_FDN);
					}
					case "AXD301"
					{		
							push(@AXD301_NODES,$Node_FDN);
					}
					case "I-CSCF"
					{
							push(@I_CSCF_NODES,$Node_FDN);
					}
					case "SLF"
					{
							push(@SLF_NODES,$Node_FDN);
					}
					case "HSS-SM"
					{
							push(@HSS_SM_NODES,$Node_FDN);
					}
					case "E-CSCF"
					{
							push(@E_CSCF_NODES,$Node_FDN);
					}
					case "IMS-CO-ICS"
					{
							push(@IMS_CO_ICS_NODES,$Node_FDN);
					}
					case "MRFC"
					{
							push(@MRFC_NODES,$Node_FDN);
					}
					case "SBG"
					{
							push(@SBG_NODES,$Node_FDN);
					}
					case "EPG"
					{
							push(@EPG_NODES,$Node_FDN);
					}
					case "MiO"
					{
							push(@MiO_NODES,$Node_FDN);
					}
					case "HLR-BS"
					{
							push(@HLR_BS_NODES,$Node_FDN);
					}
					case "BCS-M"
					{
							push(@BCS_M_NODES,$Node_FDN);
					}
					case "BCS-VC"
					{
							push(@BCS_VC_NODES,$Node_FDN);
					}
					case "PGM-AP-WUIGM"
					{
							push(@PGM_AP_WUIGM_NODES,$Node_FDN);
					}
					case "PGM-PXD"
					{
							push(@PGM_PXD_NODES,$Node_FDN);
					}
					case "PGM-AP"
					{
							push(@PGM_AP_NODES,$Node_FDN);
					}
					case "PGM-WUIGM"
					{
							push(@PGM_WUIGM_NODES,$Node_FDN);
					}
				
					case "SmartMetro"
					{
							push(@SmartMetro_NODES,$Node_FDN);
					}
					
					case "HLR"
					{
							push(@HLR_NODES,$Node_FDN);
					}
					
					case "Isite"
					{
							push(@Isite_NODES,$Node_FDN);
					}
					
					case "IPWorks"
					{
							push(@IPWorks_NODES,$Node_FDN);
					}
					
					case "CSCF"
					{
							push(@CSCF_NODES,$Node_FDN);
					}
					case "S-CSCF"
					{
							push(@S_CSCF_NODES,$Node_FDN);
					}
					
					case "SCF"
					{
							push(@SCF_NODES,$Node_FDN);
					}
				
					case "SASN"
					{
							push(@SASN_NODES,$Node_FDN);
					}
					
					case "PGM"
					{
							push(@PGM_NODES,$Node_FDN);
					}
					
					case "P-CSCF"
					{
							push(@P_CSCF_NODES,$Node_FDN);
					}
					
					case "IMS-M"
					{
							push(@IMS_M_NODES,$Node_FDN);
					}
					
					case "HSS-FE"
					{
							push(@HSS_FE_NODES,$Node_FDN);
					}
					
					case "CUDB"
					{
							push(@CUDB_NODES,$Node_FDN);
					}
				
				
					case "AUC"
					{
							push(@AUC_NODES,$Node_FDN);
					}
					
					case "FNR"
					{
							push(@FNR_NODES,$Node_FDN);
					}
					
					case "CPG"
					{	
							push(@CPG_NODES,$Node_FDN);
					}
					
					case "SGSN"
					{
							push(@SGSN_NODES,$Node_FDN);
					}
					
					case "ACME"
					{
							push(@ACME_NODES,$Node_FDN);
					}
					
					case "CGSN"
					{
							push(@CGSN_NODES,$Node_FDN);
					}
					
					case "CS-AS"
					{
							push(@CS_AS_NODES,$Node_FDN);
					}
					
					case "CS-DS"
					{
							push(@CS_DS_NODES,$Node_FDN);
					}
					case "CS-MS"
					{
							push(@CS_MS_NODES,$Node_FDN);
					}
					
					case "CS-CDS"
					{
							push(@CS_CDS_NODES,$Node_FDN);
					}
					
					case "DHCPServer"
					{
							push(@DHCPServer_NODES,$Node_FDN);
					}
					
					case "DNSServer"
					{
							push(@DNSServer_NODES,$Node_FDN);
					}
					
					case "Firewall"
					{
							push(@Firewall_NODES,$Node_FDN);
					}
					
					case "GGSN"
					{
							push(@GGSN_NODES,$Node_FDN);
					}
					
					case "HP-MRFP"
					{
							push(@HP_MRFP_NODES,$Node_FDN);
					}
					
					case "HSS"
					{
							push(@HSS_NODES,$Node_FDN);
					}
					
					case "HOTSIP"
					{
							push(@HOTSIP_NODES,$Node_FDN);
					}
					
					case "IPRouter"
					{
							push(@IPRouter_NODES,$Node_FDN);
					}
					
					case "MGC"
					{
							push(@MGC_NODES,$Node_FDN);
					}
					
					case "MRF-PTT"
					{
							push(@MRF_PTT_NODES,$Node_FDN);
					}
					
					case "MTAS"
					{
							push(@MTAS_NODES,$Node_FDN);
					}
					
					case "NTP"
					{
							push(@NTP_NODES,$Node_FDN);
					}
					
					case "PTT-AS"
					{
							push(@PTT_AS_NODES,$Node_FDN);
					}
					
					case "ProtocolServer"
					{
							push(@ProtocolServer_NODES,$Node_FDN);
					}
					
					case "SAPC"
					{
							push(@SAPC_NODES,$Node_FDN);
					}
					
					case "SCP-T"
					{
							push(@SCP_T_NODES,$Node_FDN);
					}
					
					case "SMPC"
					{
							push(@SMPC_NODES,$Node_FDN);
					}
					
					case "SSF"
					{
							push(@SSF_NODES,$Node_FDN);
					}
					
					case "STP"
					{
							push(@STP_NODES,$Node_FDN);
					}
					
					case "TRC"
					{
							push(@TRC_NODES,$Node_FDN);
					}
					
					case "TSC"
					{
							push(@TSC_NODES,$Node_FDN);
					}
					
					case "TSCServer"
					{
							push(@TSCServer_NODES,$Node_FDN);
					}
					
					case "MSC"
					{		
							push(@MSC_NODES,$Node_FDN);
							if ($tmp_line=~m/.*\|(.*):/)
							{	
								my $tmp_Node_type=$1;
								if( $tmp_Node_type=~m/:/)
								{
									my @temp_array=split(':',$tmp_Node_type);
									$tmp_Node_type=$temp_array[1];
									if( $tmp_Node_type eq "VLR")
									{
									push(@VLR_NODES,$Node_FDN);
									}
								}									
							}
							
					}
					
					case "MGW"
					{
							push(@MGW_NODES,$Node_FDN);
					}
					
					case "BSC"
					{
							push(@BSC_NODES,$Node_FDN);
					}
					
					case "XC"
					{
							push(@XC_NODES,$Node_FDN);
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
					case "ML-PPPRouter"
					{
							my $ref=\@ML_PPPRouter_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "STN"
					{
							my $ref=\@STN_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "MSCServer"
					{
							my $ref=\@MSCServer_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "LANSwitch"
					{
							my $ref=\@LANSwitch_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "H2S"
					{
							my $ref=\@H2S_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "EPG"
					{
							my $ref=\@EPG_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "AXE"
					{
							my $ref=\@AXE_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "AXD301"
					{	
							my $ref=\@AXD301_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "I-CSCF"
					{
							my $ref=\@I_CSCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "SLF"
					{
							my $ref=\@SLF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "HSS-SM"
					{
							my $ref=\@HSS_SM_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "E-CSCF"
					{
							my $ref=\@E_CSCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "IMS-CO-ICS"
					{
							my $ref=\@IMS_CO_ICS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "MRFC"
					{
							my $ref=\@MRFC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "SBG"
					{
							my $ref=\@SBG_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "MiO"
					{
							my $ref=\@MiO_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "HLR-BS"
					{
							my $ref=\@HLR_BS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "BCS-M"
					{
							my $ref=\@BCS_M_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "BCS-VC"
					{
							my $ref=\@BCS_VC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "PGM-MWI"
					{
							my $ref=\@PGM_MWI_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "PGM-AP-WUIGM"
					{
							my $ref=\@PGM_AP_WUIGM_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "PGM-PXD"
					{
							my $ref=\@PGM_PXD_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					case "PGM-AP"
					{
							my $ref=\@PGM_AP_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "PGM-WUIGM"
					{
							my $ref=\@PGM_WUIGM_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SmartMetro"
					{
							my $ref=\@SmartMetro_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				
					case "EdgeRouter"
					{
							my $ref=\@EdgeRouter_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "HLR"
					{
							my $ref=\@HLR_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				
					case "Isite"
					{
							my $ref=\@Isite_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "IPWorks"
					{
							my $ref=\@IPWorks_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CSCF"
					{
							my $ref=\@CSCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
	
					case "S-CSCF"
					{
							my $ref=\@S_CSCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				
					case "SCF"
					{
							my $ref=\@SCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SASN"
					{
							my $ref=\@SASN_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "PGM"
					{
							my $ref=\@PGM_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "P-CSCF"
					{
							my $ref=\@P_CSCF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}

					case "IMS-M"
					{
							my $ref=\@IMS_M_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				
					case "HSS-FE"
					{
							my $ref=\@HSS_FE_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CUDB"
					{
							my $ref=\@CUDB_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
				
					case "XC"
					{
							my $ref=\@XC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "AUC"
					{
							my $ref=\@AUC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "FNR"
					{
							my $ref=\@FNR_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CPG"
					{
							my $ref=\@CPG_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SGSN"
					{
							my $ref=\@SGSN_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "ACME"
					{
							my $ref=\@ACME_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CGSN"
					{
							my $ref=\@CGSN_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CS-AS"
					{
							my $ref=\@CS_AS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CS-DS"
					{
							my $ref=\@CS_DS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CS-MS"
					{
							my $ref=\@CS_MS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "CS-CDS"
					{
							my $ref=\@CS_CDS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "DHCPServer"
					{
							my $ref=\@DHCPServer_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "DNSServer"
					{
							my $ref=\@DNSServer_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "Firewall"
					{
														my $ref=\@Firewall_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "GGSN"
					{
														my $ref=\@GGSN_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "HP-MRFP"
					{
														my $ref=\@HP_MRFP_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "HSS"
					{
														my $ref=\@HSS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "HOTSIP"
					{
														my $ref=\@HOTSIP_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "IPRouter"
					{
														my $ref=\@IPRouter_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "MGC"
					{
														my $ref=\@MGC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "MRF-PTT"
					{
														my $ref=\@MRF_PTT_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "MTAS"
					{
														my $ref=\@MTAS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "NTP"
					{
														my $ref=\@NTP_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "PTT-AS"
					{
														my $ref=\@PTT_AS_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "ProtocolServer"
					{
														my $ref=\@ProtocolServer_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SAPC"
					{
														my $ref=\@SAPC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SCP-T"
					{
														my $ref=\@SCP_T_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SMPC"
					{
														my $ref=\@SMPC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "SSF"
					{
														my $ref=\@SSF_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "STP"
					{
														my $ref=\@STP_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "TRC"
					{
														my $ref=\@TRC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "TSC"
					{
														my $ref=\@TSC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "TSCServer"
					{
														my $ref=\@TSCServer_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "MSC"
					{
							my $ref=\@MSC_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
							my $ref1=\@VLR_NODES;
							PUT_DATA_TO_FILE("VLR",$ref1);
					}
					
					case "MGW"
					{
														my $ref=\@MGW_NODES;
							PUT_DATA_TO_FILE($node_name,$ref);
					}
					
					case "BSC"
					{
														my $ref=\@BSC_NODES;
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