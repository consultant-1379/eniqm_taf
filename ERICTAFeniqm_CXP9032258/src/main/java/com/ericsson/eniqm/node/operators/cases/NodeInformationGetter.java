package com.ericsson.eniqm.node.operators.cases;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.cases.CLICommandLine;
import com.ericsson.eniqm.operators.cases.CheckingMountPoint;
import com.esotericsoftware.minlog.Log;
import com.ericsson.eniqm.node.operators.cases.CheckingNodeDetails;

import org.apache.log4j.Logger;


public class NodeInformationGetter {
	Logger log = Logger.getLogger(NodeInformationGetter.class.getName());
	
	CLICommandHelper helper =  CLICommandLine.cliCommandRC();
	boolean CheckMountPoint = new CheckingMountPoint().MountPoint();

	ArrayList<String> MeTypes = new ArrayList<String>();
	public String Eniq_Volume_Mt_Point(){
		try{
			if(CheckMountPoint == true)
			{
				String MountptAvailable = helper.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
				int index = MountptAvailable.indexOf("=")+1;
				return MountptAvailable.substring(index,MountptAvailable.length()); 
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
				String Loc_Path = helper.simpleExec("cat /ericsson/eniq/etc/eniqevents.env | grep  ENIQ_ENIQM_LOC_PATH=");
				int index = Loc_Path.indexOf("=")+1;
				return Loc_Path.substring(index,Loc_Path.length());
			}
		}
		catch(Exception e){
			log.error("NodeInformationGetter:: Eniq_Eniqm_Loc_Path() Location Path isn't synchronized...", e);
		}
		return null;
	}

	public ArrayList<String> ReturnME(ArrayList<String> NodeFDn){
		try {
			for(String count : NodeFDn){
				int b = count.indexOf("ManagedElement=")+10;
				MeTypes.add(count.substring(b+5, count.length()));
			}
		}catch(Exception e)
		{
			log.error("NodeInformationGetter:: Eniq_Eniqm_Loc_Path() Location Path isn't synchronized...", e);
		}
		return MeTypes;
	}


	public boolean NodeFdnsTopology(ArrayList<String> MeType){

		boolean result = false;
		int isZero=MeType.size();
		log.info("True or False  :");
		log.info(!(isZero!=0) || !(MeType!=null));
		boolean noNodes = !(isZero!=0) || !(MeType!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		log.info("check mount point");
		log.info(CheckMountPoint == true && !noNodes);
		if (CheckMountPoint == true && !noNodes){
			ArrayList<String> MeTypes = ReturnME(MeType);
			log.info("nodes are : " +MeTypes);

			for(String i:MeTypes){

				String mt=Eniq_Volume_Mt_Point().trim();
				String command = "ls -ltr " +mt +"/outputfiles/core/topologyData/CoreNetwork/ |grep -i " +i.trim(); 
				String ac =helper.simpleExec(command);
				log.info("command : "+command);
				log.info("ac" +ac);
				if(ac!= null && ac.length()>0){
					log.info(ac);
					result=true;
				}
				else
					return false;
			}
		}

		return result;
	}

	public boolean NodeFdnsSymblinks(ArrayList<String> MeType){
		boolean result = false;
		int isZero=MeType.size();

		log.info("true or false  :");
		log.info(!(isZero!=0) || !(MeType!=null));
		boolean noNodes = !(isZero!=0) || !(MeType!=null);
		if(noNodes){
			log.info("no nodes " +noNodes);
			return true;
		}
		log.info("check mount point");
		log.info(CheckMountPoint == true && !noNodes);
		if (CheckMountPoint == true && !noNodes){

			ArrayList<String> MeTypes = ReturnME(MeType);

			String mt=Eniq_Volume_Mt_Point().trim();
			for(String i:MeTypes){
				String command = "ls -ltr " +mt +"/core/topologyData/CoreNetwork/ |grep -i " +i.trim(); 
				String ac=helper.simpleExec(command);
				log.info("command" +command);
				if(ac!= null && ac.length()>0){
					Log.info("ac  " +ac);
					result = true;
				}else{
					return false;
				}
			}
		}
		return result;
	}


	public boolean NodeFdnsEventSymblinks(ArrayList<String> MeType){
		boolean result = false;
		int isZero=MeType.size();

		log.info("true or false   :");
		log.info(!(isZero!=0) || !(MeType!=null));
		boolean noNodes = !(isZero!=0) || !(MeType!=null);
		if(noNodes){
			System.out.println("no nodes " +noNodes);
			return true;
		}
		if(!(isZero!=0) || !(MeType!=null))
			return true;
		log.info("check mount point");
		log.info(CheckMountPoint == true && !noNodes);
		if (CheckMountPoint == true && !noNodes){
			ArrayList<String> MeTypes = ReturnME(MeType);

			String mt=Eniq_Eniqm_Loc_Path().trim();
			for(String i:MeTypes){
				String command = "ls -ltr " +mt +"/core/topologyData/CoreNetwork/ |grep -i " +i.trim(); 
				log.info("command" +command);
				String ac=helper.simpleExec(command);
				if(ac!= null && ac.length()>0){
					Log.error("ac  " +ac);
					result = true;
				}else{
					return false;
				}
			}
		}
		return result;
	}

}

