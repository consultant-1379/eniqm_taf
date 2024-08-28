#!/bin/sh -f
#XSINHAR
##CLI to Access CSLib API

#make sure environment vars are exported

set -a                 
. /etc/opt/ericsson/system.env
. /etc/opt/ericsson/nms_cif_cs/cxc.env


# Set MasterHost
getHOST()
{
  if [ -z "$MasterHost" ]
  then
    MasterHost=`hostname`
  fi
}

## You can put a logic here like how many LTE CELLS are there
## and based on that deployment you can decide about connection status
getSegCSConnectionRequired()
{
			ConnToSegCSReq=true
}

### By default CSLib connection itself will take around 250MB , so i have given minimum 512.
## But you can customize it based on your need.
getHeapSizeRequired()
{
        HEAP_SIZE=512
}


DIR=`pwd` 
DIR="${DIR}/"

MAIN_CLASS=csconnection.CsConnectionMain
CLASSPATH=/opt/ericsson/nms_cif_cs/lib/nms_cif_cs.jar:/home/nmsadm/ENIQ-M_Automation_Suite/ONRM_CS_Connection.jar:${CLASSPATH}:${SM_CLASSPATH}:${NA_CLASSPATH}:${CIF_CSLIB_CLASSPATH}:/opt/ericsson/fm_core/classes/alarmirp.jar:/opt/ericsson/nms_umts_wranmom/lib/RanosMim.jar:/opt/versant/ODBMS/lib/vodjdo.jar:/opt/versant/ODBMS/lib/jdo2-api-2.1.jar


runMainClass()
{
  	
  # Read MasterHost name
  getHOST
  # A check to see if it is necessary to contact the Segment CS for topology information. 
  getSegCSConnectionRequired

  MINUS_D_SETTINGS="-Dsm.cs.services=$SelfMgmtDomainMIBCs                      \
     -Dsm.cs.host=$SelfMgmtHostMIBHost                          \
     -DIM_ROOT=$IM_ROOT \
     -DWranSubnetworkMirrorCS=$WranSubnetworkMirrorCS \
     -DUseCsLib=false \
     -Dhostname=$MasterHost \
     -DConnectionToTheSegCSRequired=$ConnToSegCSReq \
     -XX:MaxPermSize=256m \
    " 
  getHeapSizeRequired
  exec ${JAVA_HOME}/bin/java -Ds=ENIQM -server -Xmx${HEAP_SIZE}m $JAVAFLAGS $MINUS_D_SETTINGS -cp ${CLASSPATH} $MAIN_CLASS
  
} # end runMainClass()

##
## Main function
##

THIS=`basename $0`      # remember this script name

# Process arguments from command line
if [ $# -gt 1 ]
then
  echo "$THIS: Error, too many input arguments"
  printUsageMsg
  exit 1
fi

runMainClass true
exit
