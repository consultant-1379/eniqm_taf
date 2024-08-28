package com.ericsson.eniqm.operators.cases;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingConfigFilesInterface;

public class CheckingConfigFiles implements CheckingConfigFilesInterface{
	
	Logger log = Logger.getLogger(CheckingConfigFiles.class.getName());

	//This TC Checks for ConfigFiles in the directory..
	@Override
	public boolean checkConfig() {
		CLICommandHelper helper =  CLICommandLine.cliCommandRC();
		try{
			String status = helper.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
			String values[] = status.split("=");			
			String ENIQ_VOLUME_MT_POINT = values[1].trim(); 
			String Config_Path=ENIQ_VOLUME_MT_POINT+"/config";
			
			String pms_xml = helper.simpleExec("ls -ltr "+Config_Path.trim()+"/pms.xml");
			log.error(pms_xml);
			
			String pdm_xml = helper.simpleExec("ls -ltr "+Config_Path.trim()+"/pdm.xml");
			
			String sgw_xml = helper.simpleExec("ls -ltr "+Config_Path.trim()+"/sgw.xml");
			
			String eniqm_xml = helper.simpleExec("ls -ltr "+Config_Path.trim()+"/eniqm.xml");
			
			String eniqmifconfig_dtd = helper.simpleExec("ls -ltr "+Config_Path.trim()+"/eniqmifconfig.dtd");
			 

			if(pms_xml.contains("No such file")){	
				log.error("pms_xml not present..");
				log.error(pms_xml);
				log.error(Config_Path);
				return false;
			}
			if(pdm_xml.contains("No such file")){
				log.error("pdm_xml not present..");
				return false;
			}
			if(sgw_xml.contains("No such file")){
				log.error("sgw_xml not present..");
				return false;
			}
			if(eniqm_xml.contains("No such file")){
				log.error("eniqm_xml not present..");
				return false;
			}
			if(eniqmifconfig_dtd.contains("No such file")){
				log.error("eniqmifconfig_dtd not present..");
				return false;
			}
			return true;		
		}
		catch(Exception e){
			log.error("CheckingConfigFiles::checkConfig() Exception occured..", e);
			return false;
		}			
	}
}
