package com.ericsson.eniqm.operators.cases;



import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingMountPointInterface;

public class CheckingMountPoint implements CheckingMountPointInterface { 

	Logger log = Logger.getLogger(CheckingMountPoint.class.getName());

	//This TC Checks for MountPoints in eniq.env & eniqevents.env files
	@Override
	public boolean MountPoint(){
		
		CLICommandHelper helper = CLICommandLine.cliCommandRC();

		try{
			String isEniq = helper.simpleExec("ls -ltr /ericsson/eniq/etc/eniq.env");
			String isEniqEvents = helper.simpleExec("ls -ltr /ericsson/eniq/etc/eniqevents.env");

			if(isEniq.contains("No such file")){	
				log.error("/ericsson/eniq/etc/eniq.env file does not exists ");
				return false;
			}
			if(isEniqEvents.contains("No such file")){	
				log.error("/ericsson/eniq/etc/eniqevents.env file does not exists ");
				return false;
			}

			String status = helper.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
			String values[] = status.split("=");
			if(!(values[0].equals("ENIQ_VOLUME_MT_POINT")&&values[1]!=null)){
				log.error("ENIQ_VOLUME_MT_POINT is not found..");
				return false;
			}

			String command = "ls -ltr "+values[1].trim();			

			String eniqVolumeMTpt = helper.simpleExec(command);	

			if(eniqVolumeMTpt.contains("No such file")){
				log.error("eniqVolumeMTpt "+values[1]+" is not found..");
				return false;
			}

			status = helper.simpleExec("cat /ericsson/eniq/etc/eniqevents.env | grep  ENIQ_ENIQM_LOC_PATH=");
			values = status.split("=");
			if(!(values[0].equals("ENIQ_ENIQM_LOC_PATH")&&values[1]!=null)){
				log.error("ENIQ_VOLUME_LOC_PATH is not found..");
				return false;
			}

			String eniqmLocPath = helper.simpleExec("ls -ltr "+values[1].trim());	

			if(eniqmLocPath.contains("No such file")){
				log.error("eniqLocPath "+values[1]+" is not found..");
				return false;
			}			

			return true;
		}
		catch(Exception e){
			log.error("CheckingMountPoint::checkMountPoint() Exception occured..", e);
			return false;
		}

	}
}



