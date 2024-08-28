package com.ericsson.eniqm.operators.cases;
import org.apache.log4j.Logger;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingStarteniqmInterface;

public class CheckingStarteniqm implements CheckingStarteniqmInterface{

	Logger log = Logger.getLogger(CheckingStarteniqm.class.getName());

	//This TC Checks if DEniqMRunAtStart of /opt/ericsson/eniqm/bin/starteniqm.sh is true. If not modified to true .
	@Override
	public boolean starteniqm() {
		try{

			
			CLICommandHelper helper = CLICommandLine.cliCommandRC();
			
			String listFile = helper.simpleExec("ls -ltr /opt/ericsson/eniqm/bin/starteniqm.sh |tr -s ' '");
//			log.error("permi:: "+per.trim());
//
//			File STARTUP=new File("/opt/ericsson/eniqm/bin/starteniqm.sh");
//
//			log.error("canRead::  "+STARTUP.canRead());	
//			
//			if(!STARTUP.exists()){
//				log.error("/opt/ericsson/eniqm/bin/starteniqm.sh not exists");
//				return false;
//			}
			
			if(listFile.contains("No such file")){	
				log.error("/opt/ericsson/eniqm/bin/starteniqm.sh is not present..");
				return false;
			}
			

			String status = helper.simpleExec("cat /opt/ericsson/eniqm/bin/starteniqm.sh | grep  DEniqMRunAtStart=");

			if(status.contains("DEniqMRunAtStart") && status.contains("false")){
				helper.simpleExec("perl -pi -e 's/DEniqMRunAtStart=false/DEniqMRunAtStart=true/' /opt/ericsson/eniqm/bin/starteniqm.sh");					

				status = helper.simpleExec("cat /opt/ericsson/eniqm/bin/starteniqm.sh | grep  DEniqMRunAtStart=");

				if(!(status.contains("DEniqMRunAtStart") && status.contains("true"))){	
					log.error("/opt/ericsson/eniqm/bin/starteniqm.sh DEniqMRunAtStart is not true");
					return false;		
				}
			}	
			
			return true;	
		}
		catch(Exception e){
			log.error("CheckingStarteniqm::starteniqm() Exception occured..", e);
			return false;
		}
	}
}
