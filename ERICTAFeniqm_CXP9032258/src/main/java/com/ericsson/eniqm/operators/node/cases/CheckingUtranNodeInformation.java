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
import com.ericsson.oss.taf.cshandler.CSDatabase;
import com.ericsson.oss.taf.cshandler.CSTestHandler;
import com.ericsson.oss.taf.cshandler.model.Attribute;
import com.ericsson.oss.taf.cshandler.model.Fdn;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

public class CheckingUtranNodeInformation {
	
	static CheckingUtranNodeInformation classInstanceNodeInfo = null;
	
	List<Fdn> utranNodes = new ArrayList<Fdn>();
	List<String> utranTypes=new ArrayList<String>();
	List<Attribute> utranType = new ArrayList<Attribute>();

	
	Map<String,ArrayList<Fdn>> utrannodeMap = new HashMap<String,ArrayList<Fdn>>();
	
	static 	boolean CheckMountPoint= new CheckingMountPoint().MountPoint();
	static boolean CheckCXCFiles = new CheckingCXCFiles().CXCFiles();
	Logger log = Logger.getLogger(CheckingUtranNodeInformation.class.getName());
	
	CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(), CSDatabase.Onrm);
	Host host = DataHandler.getHostByType(HostType.RC);
	CLICommandHelper helper = new CLICommandHelper(host, host.getUsers(UserType.ADMIN).get(0));
	

	public static CheckingUtranNodeInformation getInstance() {
		
		if(classInstanceNodeInfo==null)
		{
			classInstanceNodeInfo = new CheckingUtranNodeInformation();
		}
		return classInstanceNodeInfo;
	}

	private CheckingUtranNodeInformation() {		

		utranTypes.add("MSRBS_V1");
		utranTypes.add("RadioNode");
		

		utranNodes = OnrmHandler.getByType("ManagedElement");	
		

		for (Fdn node : utranNodes){
			try{
				utranType=OnrmHandler.getAttributes(node, "managedElementType");

				int beginIndex= utranType.toString().indexOf("=")+1;
				int endIndex= utranType.toString().indexOf(34);				
				String managedElementType= utranType.toString().substring(beginIndex, endIndex);

				if(utranTypes.contains(managedElementType)){

					log.info("FDN :  " +node);
					if(utrannodeMap.containsKey(managedElementType)){
						utrannodeMap.get(managedElementType).add(node);
					}
					else
					{
						utrannodeMap.put(managedElementType, new ArrayList<Fdn>());
						utrannodeMap.get(managedElementType).add(node);
					}			
				}	
			}catch(Exception e){
				log.info("CheckingNodeInformation :: Exception in retrieving ManagedElement Types !!!"+e);
			}
		} 
	}

	public String Eniq_Volume_Mt_Point(){
		try{
			if(CheckMountPoint == true)
			{
				String volumePoint = helper.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
				int index = volumePoint.indexOf("=")+1;
				return volumePoint.substring(index,volumePoint.length()); 
			}
		}
		catch (Exception e) {
			log.error("NodeInformationGetter:: Eniq_Volume_Mt_Point() Mount Point isn't synchronized", e);
		}
		return null;
	}

	public String Eniq_Eniqm_Loc_Path(){
		try {	
			if(CheckMountPoint == true){
				String locationPath = helper.simpleExec("cat /ericsson/eniq/etc/eniqevents.env | grep  ENIQ_ENIQM_LOC_PATH=");
				int index = locationPath.indexOf("=")+1;
				return locationPath.substring(index,locationPath.length());
			}
		}
		catch(Exception e){
			log.error("NodeInformationGetter:: Eniq_Eniqm_Loc_Path() Location Path isn't synchronized...", e);
		}
		return null;
	}

	public ArrayList<String> ReturnME(ArrayList<Fdn> NodeFDn){
		ArrayList<String> utrannodes = new ArrayList<String>();
		try {

			for(Fdn count : NodeFDn){
			
				int grepManagedElementType = count.toString().indexOf("ManagedElement=")+10;
				utrannodes.add(count.toString().substring(grepManagedElementType+5, count.toString().length()));
		}
		}catch(Exception e)
		{
			log.error("ReturnME():: Error in returning ManagedElement for NodeFDn = " +NodeFDn, e);
		}
		return utrannodes;
	}

	public boolean utrannodeFdnsTopology(String utranType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =utrannodeMap.get(utranType);
		int isZero=utranTypes.size();
			boolean noNodes = !(isZero!=0) || !(utranTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedutranTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/utran/topologyData/RBS/ |grep -i " +specifiedutranTypeNode.trim(); 
					String topologyData =helper.simpleExec(executeCommand);
				log.info("Topology File :  " +topologyData);
					if(topologyData!= null && topologyData.length()>0){
						result=true;
					}
					else
						return false;
				}
			}
		}catch(Exception e){
			log.error("Error occured in utranNodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	public boolean utranfdnSymboliclink(String utranType){
		boolean result = false;
		ArrayList<Fdn> fdns =utrannodeMap.get(utranType);
		int isZero=utranTypes.size();
		boolean noNodes = !(isZero!=0) || !(utranTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String utranfdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/utran/topologyData/RBS/ |grep -i " +utranfdnSymLink.trim(); 
					String symbolicLink=helper.simpleExec(executeCommand);
					log.info("Symbolic Link : " +symbolicLink);
					if(symbolicLink!= null && symbolicLink.length()>0){
						result = true;
					}else{
						return false;
					}
				}
			}
		}catch (Exception e){
			log.error("fdnSymboliclinks :: Error in fetching Utran Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	


	public boolean utranfdnEventSymboliclink(String utranType){
		boolean result = false;
		ArrayList<Fdn> fdns =utrannodeMap.get(utranType);
		int isZero=utranTypes.size();
		boolean noNodes = !(isZero!=0) || !(utranTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				for(String utranfdnEventSymLink : nodes){
					String executeCommand = "ls -ltr " +eventMountPoint +"/utran/topologyData/RBS/ |grep -i " +utranfdnEventSymLink.trim(); 
					String eventSymbolicLink=helper.simpleExec(executeCommand);
					log.info("EventSymbolic Link : " +eventSymbolicLink);
					if(eventSymbolicLink!= null && eventSymbolicLink.length()>0){
						result = true;
					}else{
						return false;
					}
				}
			}

		}catch (Exception e){
			log.error("fdnEventSymboliclink :: Error in fetching  Utran Symbolic Link !! ", e);
			return false;
		}
		return result;
	}
	
}

