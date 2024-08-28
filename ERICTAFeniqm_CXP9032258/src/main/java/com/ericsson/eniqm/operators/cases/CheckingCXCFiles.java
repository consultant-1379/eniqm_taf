package com.ericsson.eniqm.operators.cases;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingCXCFilesInterface;
import com.ericsson.oss.taf.cshandler.CSDatabase;
import com.ericsson.oss.taf.cshandler.CSTestHandler;
import com.ericsson.oss.taf.cshandler.SimpleFilterBuilder;
import com.ericsson.oss.taf.cshandler.model.Attribute;
import com.ericsson.oss.taf.cshandler.model.Fdn;
import com.ericsson.oss.taf.cshandler.model.Filter;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

public class CheckingCXCFiles implements CheckingCXCFilesInterface{

	Logger log = Logger.getLogger(CheckingCXCFiles.class.getName());
	
	
	public HashMap<String, HashMap<String, String>> nodeDetails = new HashMap<String,HashMap<String, String>>();
	public HashMap<String, ArrayList<String>> nodesForMeType = new HashMap<String, ArrayList<String>>();
	
	
	List<Fdn> nodeFdns = new ArrayList<Fdn>();
	List<String> neTypes=new ArrayList<String>();

	//This TC Checks if the CXC Files are present or not..
	@Override
	public boolean CXCFiles() {
		try {
			
			String cxcEnv="/etc/opt/ericsson/eniqm/cxc.env";
			String RBS_RAX_LIC_FILE_REQ="RBS_RAX_LIC_FILE_REQ";
			String createSymbolicLinks_ENIQ="createSymbolicLinks_ENIQ";
			String createSymbolicLinks_ENIQ_Events="createSymbolicLinks_ENIQ_Events";
			String ENIQ_SON_VIS_Data="ENIQ_SON_VIS_Data";
			String LTE_GIS_Data="LTE_GIS_Data";
			String ENIQ_IPRAN_Data="ENIQ_IPRAN_Data";
			String UTRAN_GIS_Data="UTRAN_GIS_Data";
			String generateSubscriberData="generateSubscriberData";

			CLICommandHelper helper =  CLICommandLine.cliCommandRC();
					
			String permission = helper.simpleExec("ls -ltr " +cxcEnv+ " | tr -s ' ' | cut -d' ' -f1");
			String nmsadm = helper.simpleExec("ls -ltr "+cxcEnv+" | tr -s ' ' | cut -d' ' -f3");
			String nms= helper.simpleExec("ls -ltr "+cxcEnv+ " | tr -s ' ' | cut -d' ' -f4");


			if(!permission.trim().equals("-rwxr-x---")){

				log.error("CXC_env file permission is not 750: "+permission);
				return false;
			}		

			if ( !(nmsadm.trim().equals("nmsadm")&& nms.trim().equals("nms")) )
			{		
				log.error("CXC_env file owner is not nmsadm: "+nmsadm+"or not nms: "+nms); 
				return false;
			}
			
			
			String parameters = helper.simpleExec("cat "+cxcEnv+" | grep  RBS_RAX_LIC_FILE_REQ=");

			if(parameters.contains(RBS_RAX_LIC_FILE_REQ)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/RBS_RAX_LIC_FILE_REQ=false/RBS_RAX_LIC_FILE_REQ=true/' "+cxcEnv);
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  createSymbolicLinks_ENIQ=");

			if(parameters.contains(createSymbolicLinks_ENIQ)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/createSymbolicLinks_ENIQ=false/createSymbolicLinks_ENIQ=true/' "+cxcEnv);
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  createSymbolicLinks_ENIQ_Events=");

			if(parameters.contains(createSymbolicLinks_ENIQ_Events)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/createSymbolicLinks_ENIQ_Events=false/createSymbolicLinks_ENIQ_Events=true/' "+cxcEnv);
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  ENIQ_SON_VIS_Data=");

			if(parameters.contains(ENIQ_SON_VIS_Data)){
				if(parameters.contains("false")){					
					helper.simpleExec("perl -pi -e 's/ENIQ_SON_VIS_Data=false/ENIQ_SON_VIS_Data=true/' "+cxcEnv);	
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  LTE_GIS_Data=");

			if(parameters.contains(LTE_GIS_Data)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/LTE_GIS_Data=false/LTE_GIS_Data=true/' "+cxcEnv);	
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  ENIQ_IPRAN_Data=");

			if(parameters.contains(ENIQ_IPRAN_Data)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/ENIQ_IPRAN_Data=false/ENIQ_IPRAN_Data=true/' "+cxcEnv);	
				}
			}

			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  UTRAN_GIS_Data=");

			if(parameters.contains(UTRAN_GIS_Data)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/UTRAN_GIS_Data=false/UTRAN_GIS_Data=true/' "+cxcEnv);	
				}
			}
			parameters = helper.simpleExec("cat "+cxcEnv+" | grep  generateSubscriberData=");

			if(parameters.contains(generateSubscriberData)){
				if(parameters.contains("false")){
					helper.simpleExec("perl -pi -e 's/generateSubscriberData=false/generateSubscriberData=true/' "+cxcEnv);	
				}
			}

//			System.out.println(" permission:: "+permission+" nmsadm:: "+nmsadm+" nms:: "+nms);
			return true;
		}
		catch(Exception e){
			log.error("CheckingCXCFiles::CXCFiles() Exception occured..", e);
			return false;
		}
	}
	
	public void getFDNListOfNeType(){
		
		CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(), CSDatabase.Onrm);
		
		
		Filter nodesOfReleaseFilter = SimpleFilterBuilder.builder()					
				.attr("managedElementType").equalTo("\\'"+"SAPC"+"\\'").build();
	
		List<Fdn> nodesList = OnrmHandler.getByType("ManagedElement", "\""+nodesOfReleaseFilter.getFilter()+"\"");
		
		for (Fdn fdn1 : nodesList){
			System.out.println("sapc node list by filter" +fdn1 );
		}
	}
	
	
}
	
