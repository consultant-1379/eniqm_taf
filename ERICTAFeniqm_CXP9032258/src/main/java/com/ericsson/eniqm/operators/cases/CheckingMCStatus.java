package com.ericsson.eniqm.operators.cases;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingMCStatusInterface;

public class CheckingMCStatus implements CheckingMCStatusInterface{
	
	Logger log = Logger.getLogger(CheckingMCStatus.class.getName());

	// This TC checks if the ENIQM MC is started or not.
	@Override
	public boolean checkMC() {
		try{
			CLICommandHelper helper =  CLICommandLine.cliCommandRC();		

			String status = helper.simpleExec("/opt/ericsson/nms_cif_sm/bin/smtool -l | grep -i eniqm");
			if(status.contains("eniqm")&&(status.contains("started")))
			{
				return true;
			}
			log.error("ENIQM MC is not in started state..");
			return false;

		}
		catch(Exception e){
			log.error("CheckingMCStatus::checkMC() Exception occured..", e);
			return false;
		}
	}
}