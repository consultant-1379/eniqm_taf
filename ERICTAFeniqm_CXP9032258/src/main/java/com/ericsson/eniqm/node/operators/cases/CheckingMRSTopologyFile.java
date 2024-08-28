package com.ericsson.eniqm.node.operators.cases;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.node.operators.CheckingMRSTopologyFileInterface;
import com.ericsson.eniqm.operators.cases.CLICommandLine;
import com.ericsson.cifwk.taf.data.DataHandler;

//TC checks for the Verification of topology file, ENIQ stats symlink & ENIQ events symlink is getting created or not..
public class CheckingMRSTopologyFile implements CheckingMRSTopologyFileInterface {

	Logger log = Logger.getLogger(CheckingMRSTopologyFile.class.getName());
	String meType[]={"EME" , "MRS", "SAPC"};
	Map<String,ArrayList<String>> nodeMap = new HashMap<String,ArrayList<String>>(); 

	@Override
	public ArrayList<String> CheckMRS() {
		ArrayList<String> b = new ArrayList<String>();
		try {
			
			CLICommandHelper helper =  CLICommandLine.cliCommandRC();
			String managed_element = helper.simpleExec("opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement");

			managed_element.trim();

			while(managed_element.length()!=0){

				if(managed_element.startsWith("SubNetwork=ONRM_ROOT_MO")){
					int endIndex=managed_element.indexOf("SubNetwork=ONRM_ROOT_MO",1);
					if(endIndex >1){
						String b1=managed_element.substring(0, endIndex);
						b.add(b1);
						managed_element=managed_element.substring(b1.length());
					}
					else
						break;
				}
				else
					break;
			}
		}
		catch(Exception e){
			log.error("CheckingMRSTopologyFile::CheckMRS()", e);
			return null;
		}

		return b;
	}



	public ArrayList<String> getNodesForType(String meType){
		if(nodeMap.containsKey(meType)){
			return nodeMap.get(meType);
		}else
			return null;
	}

	public String checkSupportedFdnForNode(String fdn){

		CLICommandHelper helper =  CLICommandLine.cliCommandRC();
		String cmnd = "opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la " +fdn + " |grep -i managedElementType";
		System.out.println(cmnd);
		for(int i=0 ;i<meType.length; i++){
			if(helper.simpleExec(cmnd).contains(meType[i])){
				return meType[i].toString();
			}
		}
		return null;
	}


	public void updateNodesForType(){
		ArrayList<String> fdns = CheckMRS();


		for(String fdn : fdns){
			String metype =checkSupportedFdnForNode(fdn);
			if(metype!=null){
				if(nodeMap.containsKey(metype)){

					nodeMap.get(metype).add(fdn);

				}
				else
				{

					nodeMap.put(metype, new ArrayList<String>());
					nodeMap.get(metype).add(fdn);

				}
			}
		}


	}

}
