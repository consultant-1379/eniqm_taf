package ONMR_CS_query_Lib;
use strict;
use warnings;
use base 'Exporter';
our @EXPORT=qw();


#****************************************************#
# Subroutine to get the attribute value from ONMR_CS #
#****************************************************#
# example how to call : ONMR_CS_query_Lib::Attribute_Value(<MO_name>,<attribute_name>)
sub Attribute_Value{

my $MO_name=$_[0];
chomp $MO_name;
my $Attribute_name=$_[1];
chomp $Attribute_name;
my $ONMR_CS_CMD="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la $MO_name -an $Attribute_name";
my $tmp=`$ONMR_CS_CMD`;
if($tmp=~m/.*: (.*)/)
 {
 $tmp=$1;
 chomp $tmp;
 $tmp=~s/\s//g;
 $tmp=~s/"//g;
 }
 return $tmp;
}


#****************************************************#
# Subroutine to get the FDN of MO from ONMR_CS 		 #
#****************************************************#
# example how to call : ONMR_CS_query_Lib::Attribute_Value(<MO_name>,<Node_name>)
sub FDN_Value{

my $MO_name=$_[0];
chomp $MO_name;
my $Node_name=$_[1];
chomp $Node_name;
my $ONMR_CS_CMD="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt $MO_name | grep $Node_name";
my $FDN= `$ONMR_CS_CMD`;
chomp $FDN;
return $FDN;
}


#****************************************************#
#  		 #
#****************************************************#
# example how to call : 

sub MO_exist{

my $MO=$_[0];
chomp $MO;
my $ONMR_CS_CMD="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS e $MO";
my $cs_output=`$ONMR_CS_CMD`;
if($cs_output)
{
	return 1;
}else{
	return 0;
	}

}


#****************************************************#
#  		 #
#****************************************************#
# example how to call : 

sub Seq_Attribute_Item_Count{

my $MO_fdn=shift;
my $Attribute_name=shift;
chomp ($Attribute_name,$MO_fdn);
my @Attr_item;
my $Attr_item_count;

my $ONMR_CS_CMD="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la $MO_fdn -an $Attribute_name";
my $Output=`$ONMR_CS_CMD`;
if($Output=~m/.*: (.*)/)
	{
					my $tmp=$1;
					chomp $tmp;
					$tmp=~s/"//g;
					@Attr_item=split('\s',$tmp);
					$Attr_item_count=$#Attr_item;
					
					if ($Attr_item_count ne "")
					{
						return $Attr_item_count+1;
					}else{
						return 0;
					}
								
					
	}

}


#****************************************************#
#  		 #
#****************************************************#
# example how to call : 

sub Seq_Attribute_Item_Value{

my $MO_fdn=shift;
my $Attribute_name=shift;
chomp ($Attribute_name,$MO_fdn);
my @Attr_item;


my $ONMR_CS_CMD="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la $MO_fdn -an $Attribute_name";
my $Output=`$ONMR_CS_CMD`;
if($Output=~m/.*: (.*)/)
	{
					my $tmp=$1;
					chomp $tmp;
					$tmp=~s/"//g;
					@Attr_item=split('\s',$tmp);
					if(@Attr_item)
					{
					return @Attr_item;
					}
												
	}

}

#****************************************************#
#  		 #
#****************************************************#
# example how to call : 

sub Get_Node()
{

	my @nodelist=`/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement`;
	foreach (@nodelist)
		{
			my $var=$_;
			chomp $var;
			my $cmd="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la $var managedElementType";
			my $type=`$cmd | cut -f2 -d ":" | cut -f2 -d " " | cut -f2 -d '"'`;
		}


}




1;

