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

public class CheckingCoreNodeInformation {
	static CheckingCoreNodeInformation classInstanceNodeInfo = null;
	List<Fdn> coreNodes = new ArrayList<Fdn>();
	List<String> coreTypes=new ArrayList<String>();
	List<Attribute> coreType = new ArrayList<Attribute>();

	Map<String,ArrayList<Fdn>> corenodeMap = new HashMap<String,ArrayList<Fdn>>();

	static 	boolean CheckMountPoint= new CheckingMountPoint().MountPoint();
	static boolean CheckCXCFiles = new CheckingCXCFiles().CXCFiles();
	Logger log = Logger.getLogger(CheckingCoreNodeInformation.class.getName());

	CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(), CSDatabase.Onrm);
	Host host = DataHandler.getHostByType(HostType.RC);
	CLICommandHelper helper = new CLICommandHelper(host, host.getUsers(UserType.ADMIN).get(0));
	
public static CheckingCoreNodeInformation getInstance() {
		
		if(classInstanceNodeInfo==null)
		{
			classInstanceNodeInfo = new CheckingCoreNodeInformation();
		}
		return classInstanceNodeInfo;
	}

	private CheckingCoreNodeInformation() {		

		coreTypes.add("DSC");
		coreTypes.add("HLRServer");
		coreTypes.add("SDNC-P");
		coreTypes.add("BBSC");
		coreTypes.add("MGW");
		coreTypes.add("BGF");
		coreTypes.add("EIR");
		coreTypes.add("GMPC");
		coreTypes.add("SPP");
		coreTypes.add("SDC");
		coreTypes.add("HP-MRFP");
		coreTypes.add("RBS");
		coreTypes.add("MSCServer");

		
		
		coreNodes = OnrmHandler.getByType("ManagedElement");	


		for (Fdn node : coreNodes){
			try{
				coreType=OnrmHandler.getAttributes(node, "managedElementType");
				int beginIndex= coreType.toString().indexOf("=")+1;
				int endIndex= coreType.toString().indexOf(34);				
				String managedElementType= coreType.toString().substring(beginIndex, endIndex);
				if(coreTypes.contains(managedElementType)){
					log.info("FDN :  " +node);
					if(corenodeMap.containsKey(managedElementType)){
						corenodeMap.get(managedElementType).add(node);
					}
					else
					{
						corenodeMap.put(managedElementType, new ArrayList<Fdn>());
						corenodeMap.get(managedElementType).add(node);
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
		ArrayList<String> corenodes = new ArrayList<String>();
		try {
			for(Fdn count : NodeFDn){
			
				int grepManagedElementType = count.toString().indexOf("ManagedElement=")+10;
				corenodes.add(count.toString().substring(grepManagedElementType+5, count.toString().length()));
			}
		}catch(Exception e)
		{
			log.error("ReturnME():: Error in returning ManagedElement for NodeFDn = " +NodeFDn, e);
		}
		return corenodes;
	}
	
	
	
	
	
	
	

	public boolean DSCTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/CoreNetwork/dsc/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in DSC NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	public boolean HLRBSTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/HLRBladeCluster/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in HLRBSBSBLADE NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	public boolean SDNCPTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/CoreNetwork/sdncp/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in  SDNC-P NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	public boolean BBSCTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/CoreNetwork/bbsc/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in  BBSC NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	
	public boolean MGWTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/CELLO/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in  MGW NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	
	
	public boolean CNTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/core/topologyData/CoreNetwork/ |grep -i " +specifiedcoreTypeNode.trim(); 
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
			log.error("Error occured in  CoreNetwork NodeFdnsTopology", e);
			return false;
		}

		return result;
	}	
	
	
	
	
	public boolean DSCSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/CoreNetwork/dsc/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching DSC Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	
	
	public boolean HLRBSSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/HLRBladeCluster/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching HLRBSBLADE Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	
	public boolean SDNCPSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/CoreNetwork/sdncp/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching SDNC-P Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	
	public boolean BBSCSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/CoreNetwork/bbsc/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching BBSC Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	public boolean MGWSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/CELLO/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching MGW Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	
	public boolean CNSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/core/topologyData/CoreNetwork/ |grep -i " +corefdnSymLink.trim(); 
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
			log.error("fdnSymboliclinks :: Error in fetching CoreNetwork Symbolic Link !! ", e);
			return false;
		}
		return result;
	}	
	
	
	
	
	
	
	
	
	public boolean HLRBSEventSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				for(String corefdnEventSymLink : nodes){
					String executeCommand = "ls -ltr " +eventMountPoint +"/core/topologyData/HLRBladeCluster/ |grep -i " +corefdnEventSymLink.trim(); 
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
			log.error("fdnEventSymboliclink :: Error in fetching  HLRBSSymbolic Link !! ", e);
			return false;
		}
		return result;
	}
	
	
	public boolean MGWEventSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				for(String corefdnEventSymLink : nodes){
					String executeCommand = "ls -ltr " +eventMountPoint +"/core/topologyData/CELLO/ |grep -i " +corefdnEventSymLink.trim(); 
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
			log.error("fdnEventSymboliclink :: Error in fetching  MGWSSymbolic Link !! ", e);
			return false;
		}
		return result;
	}
	
	
	
	
	public boolean CNEventSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				for(String corefdnEventSymLink : nodes){
					String executeCommand = "ls -ltr " +eventMountPoint +"/core/topologyData/CoreNetwork/ |grep -i " +corefdnEventSymLink.trim(); 
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
			log.error("fdnEventSymboliclink :: Error in fetching  PoolSSymbolic Link !! ", e);
			return false;
		}
		return result;
	}
	
	
	public boolean utrannodeFdnsTopology(String coreType ){
		boolean result = false;
		try{
			ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				for(String specifiedcoreTypeNode : nodes){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint+ "/outputfiles/utran/topologyData/RBS/ |grep -i " +specifiedcoreTypeNode.trim(); 
					String executeCommand1 = "ls -ltr " +volumePoint +"/outputfiles/lte/topologyData/ERBS/ |grep -i " +specifiedcoreTypeNode.trim();
					String topologyData1=helper.simpleExec(executeCommand1);
					String topologyData =helper.simpleExec(executeCommand);
					log.info("ut topology file1"+topologyData1);
					log.info("ut topology file"+topologyData );
					log.info("node type"+specifiedcoreTypeNode);
					if((topologyData!= null && topologyData.length()>0)||(topologyData1!= null && topologyData1.length()>0)){
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
	
	public boolean utranfdnSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String mountPoint=Eniq_Volume_Mt_Point().trim();
				for(String corefdnSymLink : nodes){
					String executeCommand = "ls -ltr " +mountPoint +"/utran/topologyData/RBS/ |grep -i " +corefdnSymLink.trim(); 
					String executeCommand1 = "ls -ltr " +mountPoint +"/lte/topologyData/ERBS/ |grep -i " +corefdnSymLink.trim();
					String symbolicLink1=helper.simpleExec(executeCommand1);
					String symbolicLink=helper.simpleExec(executeCommand);
					log.info("utSymbolic Link1 : " +symbolicLink1);
					log.info("utSymbolic Link : " +symbolicLink);
					
					if((symbolicLink!= null && symbolicLink.length()>0)||(symbolicLink1!= null && symbolicLink1.length()>0)){
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


	public boolean utranfdnEventSymboliclink(String coreType){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			if ((CheckMountPoint == true  && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				for(String corefdnEventSymLink : nodes){
					String executeCommand = "ls -ltr " +eventMountPoint +"/utran/topologyData/RBS/ |grep -i " +corefdnEventSymLink.trim(); 
					String executeCommand1 = "ls -ltr " +eventMountPoint +"/lte/topologyData/ERBS/ |grep -i " +corefdnEventSymLink.trim();
					String eventSymbolicLink=helper.simpleExec(executeCommand);
					String eventSymbolicLink1=helper.simpleExec(executeCommand1);
					log.info("utEventSymbolic Link1 : " +eventSymbolicLink1);
					log.info("utEventSymbolic Link : " +eventSymbolicLink);
					if((eventSymbolicLink!= null && eventSymbolicLink.length()>0)||(eventSymbolicLink1!= null && eventSymbolicLink1.length()>0)){
						result = true;
					}else{
						return false;
					}
				}
			}

		}catch (Exception e){
			log.error("fdnEventSymboliclink :: Error in fetching  Utran Event Symbolic Link !! ", e);
			return false;
		}
		return result;
	}
	
	
	
	
	
	
	public boolean MSCSTopology(String coreType ){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		ArrayList<Fdn> axeNodes =new ArrayList<Fdn>();
		ArrayList<Fdn> mscsNodes =new ArrayList<Fdn>();

		try{
			for(Fdn node: fdns){
				List<Attribute> sourceType = new ArrayList<Attribute>();				
				sourceType = OnrmHandler.getAttributes(node, "sourceType");
				String sourceTypeOfMSCS = sourceType.toString().replace("[sourceType=","").replace("\" ]","");

				log.info("MSCS node source type : " +sourceTypeOfMSCS);
				if(sourceTypeOfMSCS.contains("AXE")){
					axeNodes.add(node);
					log.info("AXE type MSCS node " +node);
				}
				else if((sourceTypeOfMSCS.contains("BSPHybrid")||sourceTypeOfMSCS.contains("ISBladeHybrid"))){
					mscsNodes.add(node);
					log.info("other type mscs " +node);
				}
			}
			int isZero=coreTypes.size();
			boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
			if(noNodes){
				log.info("no nodes " +noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes){
				ArrayList<String> axeNodeList = ReturnME(axeNodes);

				for(String axe : axeNodeList){
					String volumePoint=Eniq_Volume_Mt_Point().trim();	
					String executeCommand = "ls -ltr " +volumePoint+"/outputfiles/core/topologyData/AXE/ |grep -i " + axe.trim();			
					String axeNodeToplogy = helper.simpleExec(executeCommand);
					log.info("Topology File for axe platform MSCS Nodes :  " +axeNodeToplogy);	

					if(axeNodeToplogy!= null && axeNodeToplogy.length()>0){
						result = true;						
					}else{
						return false;
					}
				}
				ArrayList<String> mscsNodeList = ReturnME(mscsNodes);
				for(String mscs : mscsNodeList){
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String executeCommand = "ls -ltr " +volumePoint +"/outputfiles/core/topologyData/MSCCluster/ |grep -i " +mscs.trim();
					String mscsNodeToplogy = helper.simpleExec(executeCommand);
					log.info("Topology File for other MSCS Nodes :  " +mscsNodeToplogy);
					if(mscsNodeToplogy!= null && mscsNodeToplogy.length()>0){
						result = true;
					}else{
						return false;
					}
				}
			}
		}
		catch(Exception e){
			log.error("Error in MSCSTopology" , e);
			return false;
		}
		return result;
	}
	
	
	public boolean MSCSSymbolicLink(String coreeType ){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		ArrayList<Fdn> axeNodes =new ArrayList<Fdn>();
		ArrayList<Fdn> mscsNodes =new ArrayList<Fdn>();
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			for(Fdn node: fdns){
				List<Attribute> sourceType = new ArrayList<Attribute>();				
				sourceType = OnrmHandler.getAttributes(node, "sourceType");
				String sourceTypeOfMSCS = sourceType.toString().replace("[sourceType=","").replace("\" ]","");

				log.info("mscs node source type : " +sourceTypeOfMSCS);
				if(sourceTypeOfMSCS.contains("AXE")){
					axeNodes.add(node);
					log.info("AXE type MSCS node " +node);
				}
				else if((sourceTypeOfMSCS.contains("BSPHybrid")||sourceTypeOfMSCS.contains("ISBladeHybrid"))){
					mscsNodes.add(node);
					log.info("other type mscs " +node);
				}
			}

			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> axeNodeList = ReturnME(axeNodes);
				for(String axe : axeNodeList){
					String volumePoint=Eniq_Volume_Mt_Point().trim();				
					String executeCommand = "ls -ltr " +volumePoint +"/core/topologyData/AXE/ |grep -i " +axe.trim();
					String axeSymLink = helper.simpleExec(executeCommand);	
					log.info("Symbolic Links for AXE Nodes :  " +axeSymLink);
					if(axeSymLink!= null && axeSymLink.length()>0){
						result = true;
					}else{
						return false;
					}
					
				}
				ArrayList<String> mscsNodeList = ReturnME(mscsNodes);
				for(String mscs : mscsNodeList){
					
					String volumePoint=Eniq_Volume_Mt_Point().trim();			
					String ExecuteCommand = "ls -ltr " +volumePoint +"/core/topologyData/MSCCluster/ |grep -i " +mscs.trim();
					String mscsSymLink = helper.simpleExec(ExecuteCommand);
					log.info("Symbolic Links for MSCS Nodes :  " +mscsSymLink);
					if(mscsSymLink!= null && mscsSymLink.length()>0){
						result = true;
					}else{
						return false;
					}
				}
			}
		}
		catch(Exception e){
			log.error("Error in MSCSSymbolicLink" , e);
			return false;
		}
		return result;
	} 
	
	
	public boolean MSCSEventSymbolicLink(String coreType ){
		boolean result = false;
		ArrayList<Fdn> fdns =corenodeMap.get(coreType);
		ArrayList<Fdn> axeNodes =new ArrayList<Fdn>();
		ArrayList<Fdn> mscsNodes =new ArrayList<Fdn>();
		int isZero=coreTypes.size();
		boolean noNodes = !(isZero!=0) || !(coreTypes!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		try{
			for(Fdn node: fdns){
				List<Attribute> sourceType = new ArrayList<Attribute>();				
				sourceType = OnrmHandler.getAttributes(node, "sourceType");
				String sourceTypeOfMSCS = sourceType.toString().replace("[sourceType=","").replace("\" ]","");

				log.info("MSCS node source type : " +sourceTypeOfMSCS);
				if(sourceTypeOfMSCS.contains("AXE")){
					axeNodes.add(node);
					log.info("axe type mscs" +node);
				}
				else if(sourceTypeOfMSCS.contains("BSPHybrid")||sourceTypeOfMSCS.contains("ISBladeHybrid")){
					mscsNodes.add(node);
					log.info("other type mscs " +node);
				}
			}
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes){
				ArrayList<String> axeNodeList = ReturnME(axeNodes);
				for(String axe : axeNodeList){
					String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
					String executeCommand = "ls -ltr " +eventMountPoint +"/core/topologyData/AXE/ |grep -i " +axe.trim();
					String axeEventSymLink = helper.simpleExec(executeCommand);
					log.info("EventSymbolic Links forAXE MSCS Nodes :  " +axeEventSymLink);
					if(axeEventSymLink!= null && axeEventSymLink.length()>0){
						result = true;
					}else{
						return false;
					}
				}
			}
			ArrayList<String> MSCSNodeList = ReturnME(axeNodes);
			for(String MSCS : MSCSNodeList){
				String eventMountPoint=Eniq_Eniqm_Loc_Path().trim();
				String executeCommand = "ls -ltr " +eventMountPoint +"/core/topologyData/MSCCluster/ |grep -i " +MSCS.trim();
				String MSCSEventSymLink = helper.simpleExec(executeCommand);
				log.info("EventSymbolic Links for other MSCS Nodes :  " +MSCSEventSymLink);
				if(MSCSEventSymLink!= null && MSCSEventSymLink.length()>0){
					result = true;
				}else{
					return false;
				}
			}
	
		}
		catch(Exception e){
			log.error("Error in MSCS event symbolic Links" , e);
			return false;
		}
		return result;
	}
	
	
	
	
	
	
	
	
	
	
}

