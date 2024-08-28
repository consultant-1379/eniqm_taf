
package com.ericsson.eniqm.operators.node.cases;

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
import com.ericsson.eniqm.operators.cases.CheckingCXCFiles;
import com.ericsson.eniqm.operators.cases.CheckingMountPoint;
import com.ericsson.eniqm.test.TestClass;
import com.ericsson.oss.taf.cshandler.CSDatabase;
import com.ericsson.oss.taf.cshandler.CSTestHandler;
import com.ericsson.oss.taf.cshandler.model.Attribute;
import com.ericsson.oss.taf.cshandler.model.Fdn;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

public class CheckingLTENodeInformation {
	
	
	
	public HashMap<String, HashMap<String, String>> nodeDetails = new HashMap<String,HashMap<String, String>>();
	public HashMap<String, ArrayList<String>> nodesForMeType = new HashMap<String, ArrayList<String>>();
	
	
	
	
	//static CheckingLTENodeInformation classInstanceNodeInfo = null;
	
	List<Fdn> nodeFdns = new ArrayList<Fdn>();
	List<String> neTypes=new ArrayList<String>();
	//List<Attribute> lteType = new ArrayList<Attribute>();

	
	//Map<String,ArrayList<Fdn>> ltenodeMap = new HashMap<String,ArrayList<Fdn>>();
	
	//static 	boolean CheckMountPoint= TestClass.isEniqMounted;
	static boolean CheckCXCFiles = new CheckingCXCFiles().CXCFiles();
	Logger log = Logger.getLogger(CheckingLTENodeInformation.class.getName());
	
	CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(), CSDatabase.Onrm);
	Host host = DataHandler.getHostByType(HostType.RC);
	CLICommandHelper helper = new CLICommandHelper(host, host.getUsers(UserType.ADMIN).get(0));
	

//	public static CheckingLTENodeInformation getInstance() {
//		
////		if(classInstanceNodeInfo==null)
////		{
////			classInstanceNodeInfo = new CheckingLTENodeInformation();
////		}
////		return classInstanceNodeInfo;
////	}

	public   CheckingLTENodeInformation() {		

		neTypes.add("SAPC");
		neTypes.add("EME");
		neTypes.add("CEE");	

		nodeFdns = OnrmHandler.getByType("ManagedElement");	
		List<String> attributeNames = new ArrayList<String>() ;
		attributeNames.add("userLabel");
		attributeNames.add("managedElementType");
		attributeNames.add("nodeVersion");
		attributeNames.add("sourceType");
		attributeNames.add("emUrl");
		
		for (Fdn fdn : nodeFdns){
			log.info("1 node fdn : " + fdn.toString());
				
			List<Attribute> csDataForNode = OnrmHandler.getAttributes(fdn,attributeNames);
			
			
			String managedElementType= csDataForNode.get(1).toString().substring(csDataForNode.get(1).toString().indexOf("=")+1, csDataForNode.get(1).toString().length()-1);
		     log.info("2 Managed Element Type: "+managedElementType);
			if(neTypes.contains(managedElementType)){
				//List<Attribute> csDataForNode = OnrmHandler.getAttributes(fdn,attributeNames);
				HashMap<String, String> nodeAttributes = new HashMap<String, String>();
				String nodeName = csDataForNode.get(0).toString().substring(csDataForNode.get(0).toString().indexOf("=")+1, csDataForNode.get(0).toString().length()-1);
		     	log.info("3 nodeName:"+nodeName);
				nodeAttributes.put("fdn", fdn.toString());
				
				for(int i=1; i<=attributeNames.size(); i++){
					
					nodeAttributes.put(attributeNames.get(i), csDataForNode.get(i).toString().substring(csDataForNode.get(i).toString().indexOf("=")+1, csDataForNode.get(i).toString().length()-1));
					
					log.info("4 attributes key : " +attributeNames.get(i).toString() + " value" +csDataForNode.get(i).toString().substring(csDataForNode.get(i).toString().indexOf("=")+1, csDataForNode.get(i).toString().length()-1));
				}
				
				
					
				for (Map.Entry entry : nodeAttributes.entrySet()) {
				    log.info("5 key : " +entry.getKey() + " value : " + entry.getValue());
				}

				
				nodeDetails.put(nodeName, nodeAttributes );
				
				//String managedElementType= nodeDetails.get(nodeName).get("managedElementType");
				
				//if(neTypes.contains(managedElementType)){
					log.info("6 CheckingNodeInformation : ManagedElementType for Node :" +nodeName + " is " +managedElementType);
					if(nodesForMeType.containsKey(managedElementType))
					{
						nodesForMeType.get(managedElementType).add(nodeName);
						log.info("7 nodesForMeType : " +nodeName  +" managedEmlentype" +managedElementType);
					}
					else
					{
						nodesForMeType.put(managedElementType, new ArrayList<String>());
						log.info("8 nodesForMeType managedElemntTupe " +managedElementType );
						nodesForMeType.get(managedElementType).add(nodeName);
						log.info("9 nodesForMeType nodename " +nodeName);
					}			
				}	
				
		}	
				
}

//	public String Eniq_Volume_Mt_Point(){
//		try{
//			if(CheckMountPoint == true)
//			{
//				String volumePoint = helper.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
//				int index = volumePoint.indexOf("=")+1;
//				return volumePoint.substring(index,volumePoint.length()); 
//			}
//		}
//		catch (Exception e) {
//			log.error("NodeInformationGetter:: Eniq_Volume_Mt_Point() Mount Point isn't synchronized", e);
//		}
//		return null;
//	}
//
//	public String Eniq_Eniqm_Loc_Path(){
//		try {	
//			if(CheckMountPoint == true){
//				String locationPath = helper.simpleExec("cat /ericsson/eniq/etc/eniqevents.env | grep  ENIQ_ENIQM_LOC_PATH=");
//				int index = locationPath.indexOf("=")+1;
//				return locationPath.substring(index,locationPath.length());
//			}
//		}
//		catch(Exception e){
//			log.error("NodeInformationGetter:: Eniq_Eniqm_Loc_Path() Location Path isn't synchronized...", e);
//		}
//		return null;
//	}
//
//	public ArrayList<String> ReturnME(ArrayList<Fdn> NodeFDn){
//		ArrayList<String> ltenodes = new ArrayList<String>();
//		try {
//		for(Fdn count : NodeFDn){
//			
//				int grepManagedElementType = count.toString().indexOf("ManagedElement=")+10;
//				ltenodes.add(count.toString().substring(grepManagedElementType+5, count.toString().length()));
//			}
//		}catch(Exception e)
//		{
//			log.error("ReturnME():: Error in returning ManagedElement for NodeFDn = " +NodeFDn, e);
//		}
//		return ltenodes;
//	}
//
//	public boolean ltenodeFdnsTopology(String lteType ){
//		boolean result = false;
//		try{
//			ArrayList<Fdn> fdns =ltenodeMap.get(lteType);
//		int isZero=lteTypes.size();
//			boolean noNodes = !(isZero!=0) || !(lteTypes!=null);
//			if(noNodes){
//				log.info("no nodes " +noNodes);
//				return true;
//			}
//			if (CheckMountPoint == true && !noNodes){
//				ArrayList<String> nodes = ReturnME(fdns);
//				for(String specifiedlteTypeNode : nodes){
//					String volumePoint=Eniq_Volume_Mt_Point().trim();			
//					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/lte/topologyData/ERBS/ |grep -i " +specifiedlteTypeNode.trim(); 
//					String topologyData =helper.simpleExec(executeCommand);
//				log.info("Topology File :  " +topologyData);
//					if(topologyData!= null && topologyData.length()>0){
//						result=true;
//					}
//					else
//						return false;
//				}
//			}
//		}catch(Exception e){
//			log.error("Error occured in lteNodeFdnsTopology", e);
//			return false;
//		}
//
//		return result;
//	}	
//	
//	public boolean ltefdnSymboliclink(String lteType){
//		boolean result = false;
//		ArrayList<Fdn> fdns =ltenodeMap.get(lteType);
//		int isZero=lteTypes.size();
//		boolean noNodes = !(isZero!=0) || !(lteTypes!=null);
//		if(noNodes){
//			log.info("no nodes " +noNodes);
//			return true;
//		}
//		try{
//			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
//				ArrayList<String> nodes = ReturnME(fdns);
//				String mountPoint=Eniq_Volume_Mt_Point().trim();
//				for(String ltefdnSymLink : nodes){
//					String executeCommand = "ls -ltr " +mountPoint +"/lte/topologyData/ERBS/ |grep -i " +ltefdnSymLink.trim(); 
//					String symbolicLink=helper.simpleExec(executeCommand);
//					log.info("Symbolic Link : " +symbolicLink);
//					if(symbolicLink!= null && symbolicLink.length()>0){
//						result = true;
//					}else{
//						return false;
//					}
//				}
//			}
//		}catch (Exception e){
//			log.error("fdnSymboliclinks :: Error in fetching LTE Symbolic Link !! ", e);
//			return false;
//		}
//		return result;
//	}	
//
//
//	public boolean ltefdnEventSymboliclink(String lteType){
//		boolean result = false;
//		ArrayList<Fdn> fdns =ltenodeMap.get(lteType);
//		int isZero=lteTypes.size();
//		boolean noNodes = !(isZero!=0) || !(lteTypes!=null);
//		if(noNodes){
//			log.info("no nodes " +noNodes);
//			return true;
//		}
//		try{
//			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
//				ArrayList<String> nodes = ReturnME(fdns);
//				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
//				for(String ltefdnEventSymLink : nodes){
//					String executeCommand = "ls -ltr " +eventMountPoint +"/lte/topologyData/ERBS/ |grep -i " +ltefdnEventSymLink.trim(); 
//					String eventSymbolicLink=helper.simpleExec(executeCommand);
//					log.info("EventSymbolic Link : " +eventSymbolicLink);
//					if(eventSymbolicLink!= null && eventSymbolicLink.length()>0){
//						result = true;
//					}else{
//						return false;
//					}
//				}
//			}
//
//		}catch (Exception e){
//			log.error("fdnEventSymboliclink :: Error in fetching  LTE Symbolic Link !! ", e);
//			return false;
//		}
//		return result;
//	}
//	
//	
//	public boolean lteNodeVersion(String lteType)
//	{
//		boolean result= false;
//		
//		try{
//			ArrayList<Fdn> fdns =ltenodeMap.get(lteType);
//			
//			int isZero=lteTypes.size();
//			boolean noNodes = !(isZero!=0) || !(lteTypes!=null);
//			if(noNodes){
//				log.info("no nodes " +noNodes);
//				return true;
//			}
//			if (CheckMountPoint == true && !noNodes){
//				ArrayList<String> nodes = ReturnME(fdns);
//			
//			for(Fdn node: fdns){
//				List<Attribute> NodeVersion = new ArrayList<Attribute>();
//				NodeVersion =OnrmHandler.getAttributes(node, "nodeVersion");
//				String csnv=NodeVersion.toString().replace("[nodeVersion=","").replace("\" ]","");
//				log.info(csnv);
//				for(String specifiedlteTypeNode : nodes){
//					String volumePoint=Eniq_Volume_Mt_Point().trim();			
//					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/lte/topologyData/ERBS/ |grep -i " +specifiedlteTypeNode.trim(); 
//					String topologyData =helper.simpleExec(executeCommand);
//					String executeCommand1="cat"+topologyData+"grep -i nodeVersion";
//				    String tonv=helper.simpleExec(executeCommand1);
//				    String NV=tonv.substring(tonv.indexOf("i")+4,tonv.indexOf("/")-1);
//				    if(csnv.equals(NV))
//				    {
//				     result = true;
//				    }else{
//				    	return false;
//				    }	
//				  }
//				}
//			    }
//	
//			}catch (Exception e){
//				log.error("Node Version of Lte Nodes :: Error in Lte Node Version !! ", e);
//				return false;
//			}
//
//		return result;
//}
}
	
	
	
	


