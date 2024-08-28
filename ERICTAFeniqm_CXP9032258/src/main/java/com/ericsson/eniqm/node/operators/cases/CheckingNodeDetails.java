package com.ericsson.eniqm.node.operators.cases;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.node.operators.CheckingNodeDetailsInterface;
import com.ericsson.eniqm.operators.cases.CLICommandLine;
import com.sun.jna.platform.win32.WinUser.LASTINPUTINFO;



//TC checks for the Verification of topology file, ENIQ stats symbolic_link & ENIQ events symbolic_link is getting created or not..
public class CheckingNodeDetails implements CheckingNodeDetailsInterface {

	Logger log = Logger.getLogger(CheckingNodeDetails.class.getName());
	String managedElementType[]={"EME", "MRS" , "Router_6672" , "UPG", };
	Map<String,ArrayList<String>> nodeMap = new HashMap<String,ArrayList<String>>(); 

	@Override
	public ArrayList<String> CheckNodeDetails() {
		ArrayList<String> listOfFdn = new ArrayList<String>();
		try {
			CLICommandHelper helper =  CLICommandLine.cliCommandRC();

			String managed_element = helper.simpleExec("/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement");		

			managed_element.trim();

			while((managed_element.length() != 0)){

				if(managed_element.startsWith("SubNetwork=ONRM_ROOT_MO")){
					log.info("managed element is " +managed_element);
					int endIndex=managed_element.indexOf("SubNetwork=ONRM_ROOT_MO",1);

					if(endIndex > 0){
						String subnetworkElement=managed_element.substring(0, endIndex);
						log.info("subnetwork element" +subnetworkElement);
						listOfFdn.add(subnetworkElement);

						managed_element=managed_element.substring(subnetworkElement.length());					

					}
					else{
						String subnetworkElement=managed_element;
						log.info("subnetwork element" +subnetworkElement);
						listOfFdn.add(subnetworkElement);
						break;
					}
				}
				else	
					break;
			}
		}
		catch(Exception e){
			log.error("CheckingNodeDetails::CheckNodeDetails()", e);
			return null;
		}
		return listOfFdn;
	}

	public ArrayList<String> getNodesForType(String managedElementType){	

		if(nodeMap.containsKey(managedElementType)){
			log.info(nodeMap.containsKey(managedElementType));
			return nodeMap.get(managedElementType);
		}else{
			log.info(managedElementType + " Node is not configured on Server, CheckingNodeDetails()::getNodesForType");
			return null;
		}
	}	

	public String checkSupportedFdnForNode(String requiredFdnNode){
		try {
			CLICommandHelper helper =  CLICommandLine.cliCommandRC();
		
			String fetchManagedElements = "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS la " +requiredFdnNode + " |grep -i managedElementType";
			log.info(fetchManagedElements);
			log.info("me types" +managedElementType + "length" +managedElementType.length);
			for(int i=0;i<managedElementType.length;i++){

				if(helper.simpleExec(fetchManagedElements).contains(managedElementType[i])){
					return managedElementType[i].toString();

				}
			}
		}catch(Exception e){
			log.error("CheckingNodeDetails():: checkSupportedFdnForNode() error in fetching FDN nodes...",e);
		}
		return null;
	}

	public void updateNodesForType(){
		try {

			ArrayList<String> fetchedEntireNodes = CheckNodeDetails();
			log.info("fdns configurd on server" +fetchedEntireNodes.size());
			for(String requiredFdnNode : fetchedEntireNodes){
				log.info("fdn" +requiredFdnNode);
				String managedElementType = checkSupportedFdnForNode(requiredFdnNode);
				if(managedElementType!= null){
					if(nodeMap.containsKey(managedElementType)){
						nodeMap.get(managedElementType).add(requiredFdnNode);
					}
					else
					{
						nodeMap.put(managedElementType, new ArrayList<String>());
						nodeMap.get(managedElementType).add(requiredFdnNode);
					}
				}
			}
		}
		catch(Exception e){
			log.error("CheckingNodeDetails():: updateNodesForType() error in updating required Node Type...", e);
		}
	}
}

