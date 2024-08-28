package com.ericsson.eniqm.operators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;



import org.apache.log4j.Logger;

import com.ericsson.oss.taf.cshandler.CSDatabase;
import com.ericsson.oss.taf.cshandler.CSTestHandler;
import com.ericsson.oss.taf.cshandler.model.Attribute;
import com.ericsson.oss.taf.cshandler.model.Fdn;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;






public class CsProxy {

	static CsProxy csProxy = null;

	
	
	Logger log = Logger.getLogger(CsProxy.class.getName()); 
	

	public static final HashMap<String, HashMap<String, String>> nodeDetails = new HashMap<String,HashMap<String, String>>();
	public static final HashMap<String, ArrayList<String>> nodesForMeType = new HashMap<String, ArrayList<String>>();
	CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(), CSDatabase.Onrm);
	String[] attributeNames = {"emUrl", "sourceType", "managedElementType", "nodeVersion", "userLabel"};
	List<String> attNames = Arrays.asList(attributeNames);
	List<Fdn> nodeFdns = new ArrayList<Fdn>();
	public static final List<String> neTypes=new ArrayList<String>();
	
	
	public static CsProxy getInstance()
	{
		if(csProxy==null)
		{
			csProxy = new CsProxy();
		}
		return csProxy;

	}
	
	
	public void populateCSData(){
		
		nodeFdns = listOfFdnFromCS();
		
		List<Attribute> csDataForNode;
		
		updateSupportedNeTypes();
		for (Fdn fdn : nodeFdns){
			
			csDataForNode = new ArrayList<Attribute>();
			
			
			
			
			try{
				
			csDataForNode = getListOfArrtibuesFromCS(fdn);
			}
			catch(Exception e){
				log.error("CsProxy: populateCSData - Eception while querinf CS for list of Attributes for FDN" +fdn.toString() + e );
			}
			
		
			String managedElementType= getManagedElementOfNode(csDataForNode.get(attNames.indexOf("managedElementType")));
			log.info("CsProxy: populateCSData - Managed Element Type for : " +fdn + " is : "+managedElementType);
		    
			if(isMeTypeSupported(managedElementType)){
			
				HashMap<String, String> nodeAttributes = new HashMap<String, String>();
				String nodeName = getNodeNameFromAttribute(csDataForNode.get(attNames.indexOf("userLabel")));
				log.info("CsProxy: populateCSData - node name for FDN: " +fdn + " is : "+nodeName);
				nodeAttributes.put("fdn", fdn.toString());
				
				for(int i=0; i<attributeNames.length; i++){
				
					if(i==attNames.indexOf("sourceType") || i==attNames.indexOf("managedElementType"))
					{
						
					nodeAttributes.put(attributeNames[i], csDataForNode.get(i).toString().substring(csDataForNode.get(i).toString().indexOf("=")+1, csDataForNode.get(i).toString().length()-2));
                    	}
					else{
						
						nodeAttributes.put(attributeNames[i], csDataForNode.get(i).toString().substring(csDataForNode.get(i).toString().indexOf("=")+1, csDataForNode.get(i).toString().length()));
	                   			
					}
					}

				updateNodeDetails(nodeName, nodeAttributes );
			    updateNodesForMeType(managedElementType, nodeName);
							
				}	
				
		}	
		
		
	}
	
	
	public void updateNodeDetails(String nodeName, HashMap<String, String> nodeAttributes){
		if(nodeName != null)
		{
			nodeDetails.put(nodeName, nodeAttributes );
		}
	}
	
	public void updateNodesForMeType(String managedElementType, String nodeName ){
		if(nodesForMeType.containsKey(managedElementType))
		{
			nodesForMeType.get(managedElementType).add(nodeName);
			
		}
		else
		{
			nodesForMeType.put(managedElementType, new ArrayList<String>());
			
			nodesForMeType.get(managedElementType).add(nodeName);
			;
		}	
	}
	
	
	public static void updateSupportedNeTypes(){		  
    neTypes.add("EME");neTypes.add("MRS");neTypes.add("Router_6672");neTypes.add("UPG");neTypes.add("CEE");neTypes.add("WCG");neTypes.add("BSC");
    neTypes.add("DUA-S");neTypes.add("GGSN");neTypes.add("BGFtwork");neTypes.add("EIR");neTypes.add("DSCdsc");neTypes.add("HLRServer");neTypes.add("MSCServer");
    neTypes.add("SDNC-Psdncp");neTypes.add("BBSCbbsc");neTypes.add("MGW");neTypes.add("GMPC");neTypes.add("SPP");neTypes.add("SDC");neTypes.add("HP-MRFP");
    neTypes.add("BCS-M");neTypes.add("EBCS-VCME");neTypes.add("BCS-VC");neTypes.add("CGSN");neTypes.add("CPG");neTypes.add("CSCF");neTypes.add("CUDB");
    neTypes.add("DHCPServer");neTypes.add("EdgeRouterRedback");neTypes.add("FNR");neTypes.add("HSS");neTypes.add("HSS-SM");neTypes.add("I-CSCF");neTypes.add("IMS-CO-ICS");
    neTypes.add("E-CSCF");neTypes.add("EPG");neTypes.add("HLR");neTypes.add("HSS-FE");neTypes.add("MiO");neTypes.add("MRFC");neTypes.add("MRF-PTT");
    neTypes.add("IMS");neTypes.add("MSC");neTypes.add("PGM");neTypes.add("PGM-AP");neTypes.add("PGM-AP-WUIGM");neTypes.add("PGM-MWI");
    neTypes.add("IPWorks");neTypes.add("PGM-PXD");neTypes.add("MTAS");neTypes.add("P-CSCF");neTypes.add("ProtocolServer");neTypes.add("PGM-WUIGM");
    neTypes.add("Isite");neTypes.add("SBG");neTypes.add("SASN");neTypes.add("SLF");neTypes.add("SmartMetro");neTypes.add("SSF");
    neTypes.add("S-CSCF");neTypes.add("SCP-T");neTypes.add("SGSN");neTypes.add("Firewall");neTypes.add("MCTR");neTypes.add("HOTSIP");
    neTypes.add("STP");neTypes.add("TSC");neTypes.add("AUC");neTypes.add("IPRouter");neTypes.add("TG");neTypes.add("LBG");
    neTypes.add("MGC");neTypes.add("NTP");neTypes.add("AXE");neTypes.add("CELL");neTypes.add("CELL");neTypes.add("SCGR");
    neTypes.add("LANSwitch");neTypes.add("ACME");neTypes.add("AXD301");neTypes.add("AXE10");neTypes.add("SMPC");
    neTypes.add("STN");neTypes.add("TRC");neTypes.add("MLPPP");neTypes.add("RBS");neTypes.add("RNC");neTypes.add("RXI");neTypes.add("DSC");neTypes.add("RadioNode");
    neTypes.add("RadioTNode");neTypes.add("SDNC-P");
    neTypes.add("ERBS");neTypes.add("MSRBS_V1");neTypes.add("PRBS");neTypes.add("BBSC");neTypes.add("SAPC");
 

    
    
	}
	
	public List<Fdn> listOfFdnFromCS(){
		return OnrmHandler.getByType("ManagedElement");	
	}
	
	public  List<Attribute> getListOfArrtibuesFromCS(Fdn fdn){

		try{
		log.info("CsProxy:"+"getListOfArrtibuesFromCS:"+"fdn:"+fdn);
		return OnrmHandler.getAttributes(fdn,attributeNames);
		
		}
		catch(Exception e){
			log.error("CsProxy:"+"Exception while getting List Of Arrtibues From from CS:"+"fdn:"+fdn+ e );
			return null;
		}
		
	}
	
	public String getManagedElementOfNode(Attribute managedElementType){
		
		String metype = managedElementType.toString().substring(managedElementType.toString().indexOf("=")+1, managedElementType.toString().length()-2);
	
		if(metype.indexOf(34) == -1){
			
		return metype;
		}
		else{
			log.info("CsProxy:"+"getManagedElementOfNode:"+"metype:"+metype);
			return metype.substring(0, (metype.indexOf(34)));
		}
	}
	
	public String getUserLabelofNode(Attribute userLabel ){
		String userlabel=userLabel.toString().substring(userLabel.toString().indexOf("=")+1, userLabel.toString().length()-2);
		if(userlabel.indexOf(34) == -1){
		return userlabel;
	}
		else
		{
			log.info("CsProxy:"+"getManagedElementOfNode:"+"metype:"+userlabel);
			return userlabel.substring(0, (userlabel.indexOf(34)));
		}

	}
	
	
	public String getNodeVersionofNode(Attribute nodeVersion ){
		String nodeversion=nodeVersion.toString().substring(nodeVersion.toString().indexOf("=")+1, nodeVersion.toString().length()-2);
		if(nodeversion.indexOf(34) == -1){
		return nodeversion;
	}
		else
		{
			log.info("CsProxy:"+"getManagedElementOfNode:"+"metype:"+nodeVersion);
			return nodeversion.substring(0, (nodeversion.indexOf(34)));
		}

	}
	
	
	
	
	
	 public boolean isMeTypeSupported(String meType){
		 return neTypes.contains(meType);
	 }
	 
	 public String getNodeNameFromAttribute(Attribute nodeName){
			return nodeName.toString().substring(nodeName.toString().indexOf("=")+1, nodeName.toString().length());
		}
	
	 
	 
	 public static HashMap<String, HashMap<String, String>> getNodeDetails()
	 {
		 return nodeDetails;
	 }
	
	 
	 
		public static HashMap<String, ArrayList<String>> getNodesForMeType(){
			return nodesForMeType;
		} 
	 
	 
	 
	 
}
