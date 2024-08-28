package com.ericsson.eniqm.operators.node.cases;

import java.util.ArrayList;
import java.util.HashMap;
//import java.util.HashMap;
import java.util.List;
//import java.util.Map;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CsProxy;
import com.ericsson.eniqm.operators.cases.CheckingCXCFiles;
import com.ericsson.eniqm.operators.cases.CheckingMountPoint;
import com.ericsson.oss.taf.cshandler.CSDatabase;
import com.ericsson.oss.taf.cshandler.CSTestHandler;
import com.ericsson.oss.taf.cshandler.model.Attribute;
import com.ericsson.oss.taf.cshandler.model.Fdn;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

public class CheckingNodeInformation {

	static CheckingNodeInformation classInstanceNodeInfo = null;
	List<Fdn> meNodes = new ArrayList<Fdn>();
	List<String> neTypes = new ArrayList<String>();
	List<Attribute> meType = new ArrayList<Attribute>();
	List<Attribute> ManagedElementId = new ArrayList<Attribute>();
	List<Attribute> userLabel = new ArrayList<Attribute>();

	// public static final HashMap<String, HashMap<String, String>> nodeDetails
	// = CsProxy.getNodeDetails();
	// public static final HashMap<String, ArrayList<String>> nodesForMeType =
	// CsProxy.getNodesForMeType();

	List<Fdn> nodeFdns = new ArrayList<Fdn>();
	List<String> meTypes = new ArrayList<String>();

	//
	// Map<String,ArrayList<Fdn>> nodeMap = new
	// HashMap<String,ArrayList<Fdn>>();

	static boolean CheckMountPoint = new CheckingMountPoint().MountPoint();
	static boolean CheckCXCFiles = new CheckingCXCFiles().CXCFiles();
	Logger log = Logger.getLogger(CheckingNodeInformation.class.getName());

	CSTestHandler OnrmHandler = new CSTestHandler(HostGroup.getOssmaster(),
			CSDatabase.Onrm);
	Host host = DataHandler.getHostByType(HostType.RC);
	CLICommandHelper helper = new CLICommandHelper(host, host.getUsers(
			UserType.ADMIN).get(0));

	public static CheckingNodeInformation getInstance() {
		if (classInstanceNodeInfo == null) {
			classInstanceNodeInfo = new CheckingNodeInformation();
		}
		return classInstanceNodeInfo;

	}

	private CheckingNodeInformation() {

	}

	public String Eniq_Volume_Mt_Point() {
		try {
			if (CheckMountPoint == true) {
				String volumePoint = helper
						.simpleExec("cat /ericsson/eniq/etc/eniq.env | grep  ENIQ_VOLUME_MT_POINT=");
				int index = volumePoint.indexOf("=") + 1;
				return volumePoint.substring(index, volumePoint.length());
			}
		} catch (Exception e) {
			log.error(
					"NodeInformationGetter:: Eniq_Volume_Mt_Point() Mount Point isn't synchronized",
					e);
		}
		return null;
	}

	public String Eniq_Eniqm_Loc_Path() {
		try {
			if (CheckMountPoint == true) {
				String locationPath = helper
						.simpleExec("cat /ericsson/eniq/etc/eniqevents.env | grep  ENIQ_ENIQM_LOC_PATH=");
				int index = locationPath.indexOf("=") + 1;
				return locationPath.substring(index, locationPath.length());
			}
		} catch (Exception e) {
			log.error(
					"NodeInformationGetter:: Eniq_Eniqm_Loc_Path() Location Path isn't synchronized...",
					e);
		}
		return null;
	}

	public boolean nodeFdnsTopology(String neType, String topologyPath) {
		boolean result = false;

		try {
			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(neType);
			log.info("CheckingNodeInformation : nodeFdnsTopology: NEType - "
					+ neType);
			int isZero = listOfNodeOfNeType.size();
			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			if (noNodes) {
				log.info("CheckingNodeInformation : nodeFdnsTopology: No nodes for netype"
						+ neType + " : " + noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes) {

				for (String specifiedTypeNode : listOfNodeOfNeType) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();

					String executeCommand = "ls -ltr " + volumePoint
							+ topologyPath + " |grep -i "
							+ specifiedTypeNode.trim();
					log.info("CheckingNodeInformation : nodeFdnsTopology -execute message :  "
							+ executeCommand);
					String topologyData = helper.simpleExec(executeCommand);
					log.info("CheckingNodeInformation : nodeFdnsTopology - Topology File of core Nodes :  "
							+ topologyData);
					if (topologyData != null && topologyData.length() > 0) {
						result = true;
					} else
						return false;
				}
			}
		} catch (Exception e) {
			log.error(
					"CheckingNodeInformation: nodeFdnsTopology - Exception for "
							+ neType, e);
			return false;
		}

		return result;
	}

	//
	// private void substring(int i, int j) {
	// // TODO Auto-generated method stub
	//
	// }
	public boolean fdnEventSymboliclink(String neType,
			String fdnEventSymboliclink) {

		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(neType);
		log.info("CheckingNodeInformation : fdnEventSymboliclink: NEType - "
				+ neType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		if (noNodes) {
			log.info("CheckingNodeInformation : fdnEventSymboliclink: No nodes for netype"
					+ neType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {
				// ArrayList<String> nodes = ReturnME(fdns);
				String eventMountPoint = Eniq_Eniqm_Loc_Path().trim();
				for (String fdnEventSymLink : listOfNodeOfNeType) {
					String executeCommand = "ls -ltr " + eventMountPoint
							+ fdnEventSymboliclink + " |grep -i "
							+ fdnEventSymLink.trim();
					log.info("CheckingNodeInformation : fdnEventSymboliclink -Execute :  "
							+ executeCommand);
					String eventSymbolicLink = helper
							.simpleExec(executeCommand);
					log.info("CheckingNodeInformation : fdnEventSymboliclink : EventSymbolic Link : "
							+ eventSymbolicLink);
					if (eventSymbolicLink != null
							&& eventSymbolicLink.length() > 0) {
						result = true;
					} else {
						return false;
					}
				}
			}

		} catch (Exception e) {
			log.error(
					"CheckingNodeInformation : fdnEventSymboliclink :: Error in fetching Symbolic Link for node "
							+ "neType", e);
			return false;
		}
		return result;
	}

	public boolean fdnSymboliclink(String neType, String fdnSymboliclink) {
		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(neType);
		log.info("CheckingNodeInformation : fdnSymboliclink: NEType - "
				+ neType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		if (noNodes) {
			log.info("CheckingNodeInformation : fdnSymboliclink: No nodes for netype"
					+ neType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {

				String mountPoint = Eniq_Volume_Mt_Point().trim();
				for (String fdnSymLink : listOfNodeOfNeType) {
					String executeCommand = "ls -ltr " + mountPoint
							+ fdnSymboliclink + " |grep -i "
							+ fdnSymLink.trim();
					log.info("CheckingNodeInformation : fdnSymboliclink -Execute :  "
							+ executeCommand);
					String symbolicLink = helper.simpleExec(executeCommand);
					log.info("CheckingNodeInformation : fdnSymboliclink:Symbolic Link for core Nodes: "
							+ symbolicLink);
					if (symbolicLink != null && symbolicLink.length() > 0) {
						result = true;
					} else {
						return false;
					}
				}
			}
		} catch (Exception e) {
			log.error(
					"CheckingNodeInformation : fdnSymboliclink: :: Error in fetching Symbolic Link for node "
							+ "neType", e);
			return false;
		}
		return result;
	}

	public boolean sapcTopology(String neType) {
		boolean result = false;
		ArrayList<String> listOfNodesOfNeType = CsProxy.nodesForMeType
				.get(neType);
		ArrayList<String> sapcNodes = new ArrayList<String>();
		ArrayList<String> esapcNodes = new ArrayList<String>();

		for (String nodeType : CsProxy.nodesForMeType.keySet()) {
			System.out.println("node type : " + nodeType + " value "
					+ CsProxy.nodesForMeType.get(nodeType));
		}

		try {
			for (String node : listOfNodesOfNeType) {
				String sourceType = CsProxy.nodeDetails.get(node).get(
						"sourceType");
				// OnrmHandler.getAttributes(node, "sourceType");
				// String sourceTypeOfSapc =
				// sourceType.toString().replace("[sourceType=","").replace("\" ]","");

				log.info("sapc node source type : " + sourceType);
				if (sourceType.contains("TSP")) {
					sapcNodes.add(node);
					log.info("sapc node list:" + node);
				} else if (sourceType.contains("CBA")) {
					esapcNodes.add(node);
					log.info("esapc node list:" + node);
				}
			}
			int isZero = neTypes.size();
			boolean noNodes = !(isZero != 0) || !(neTypes != null);
			if (noNodes) {
				log.info("no nodes " + noNodes);
				return true;
			}
			if (CheckMountPoint == true && !noNodes) {
				// ArrayList<String> sapcNodeList = ReturnME(sapcNodes);

				for (String sapc : sapcNodes) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand = "ls -ltr "
							+ volumePoint
							+ "/outputfiles/core/topologyData/CoreNetwork/ |grep -i "
							+ sapc.trim();
					String sapcNodeToplogy = helper.simpleExec(executeCommand);
					log.info("Topology File for SAPC Nodes :  "
							+ sapcNodeToplogy);

					if (sapcNodeToplogy != null && sapcNodeToplogy.length() > 0) {
						result = true;
					} else {
						return false;
					}
				}
				// ArrayList<String> esapcNodeList = ReturnME(esapcNodes);
				for (String esapc : esapcNodes) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand = "ls -ltr "
							+ volumePoint
							+ "/outputfiles/core/topologyData/CoreNetwork/sapc |grep -i "
							+ esapc.trim();
					String esapcNodeToplogy = helper.simpleExec(executeCommand);
					log.info("Topology File for ESAPC Nodes :  "
							+ esapcNodeToplogy);
					if (esapcNodeToplogy != null
							&& esapcNodeToplogy.length() > 0) {
						result = true;
					} else {
						return false;
					}
				}
			}
		} catch (Exception e) {
			log.error("Error in sapcTopology", e);
			return false;
		}
		return result;
	}

	public boolean lteNodeFdnsTopology(String lteType, String topologyPath[]) {
		boolean result = false;
		try {

			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(lteType);
			int isZero = listOfNodeOfNeType.size();
			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			log.info("CheckingNodeInformation : lteNodeFdnsTopology: NEType - "
					+ lteType);
			if (noNodes) {
				log.info("CheckingNodeInformation : ltenodeFdnsTopology: No nodes for netype"
						+ lteType + " : " + noNodes);
				return true;
			}

			if (CheckMountPoint == true && !noNodes) {
				for (String specifiedlteTypeNode : listOfNodeOfNeType) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand[] = new String[topologyPath.length];
					String topologyData[] = new String[topologyPath.length];
					for (int i = 0; i < topologyPath.length; i++) {
						executeCommand[i] = "ls -ltr " + volumePoint
								+ topologyPath[i] + " |grep -i "
								+ specifiedlteTypeNode.trim();
						log.info("CheckingNodeInformation : lteNodeFdnsTopology -Execute :  "
								+ executeCommand[i]);
						topologyData[i] = helper.simpleExec(executeCommand[i]);
						log.info("Topology File :  " + topologyData[i]);
					}
					for (int j = 0; j < topologyData.length; j++) {
						if ((topologyData[j] != null && topologyData[j]
								.length() > 0)) {// ||(topologyData1!= null &&
													// topologyData1.length()>0)||(topologyData2!=
													// null &&
													// topologyData2.length()>0)||(topologyData3!=
													// null &&
													// topologyData3.length()>0)){
							return true;
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("Error occured in lteNodeFdnsTopology", e);
			return false;
		}

		return result;
	}

	public boolean lteFdnSymboliclink(String lteType, String symlinkPath[]) {
		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(lteType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		log.info("CheckingNodeInformation : lteFdnSymboliclink: NEType - "
				+ lteType);
		if (noNodes) {
			log.info("CheckingNodeInformation : lteFdnSymboliclink: No nodes for netype"
					+ lteType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {

				String mountPoint = Eniq_Volume_Mt_Point().trim();
				for (String specifiedlteTypeNode : listOfNodeOfNeType) {
					String executeCommand[] = new String[symlinkPath.length];
					String symbolicLink[] = new String[symlinkPath.length];
					for (int i = 0; i < symlinkPath.length; i++) {
						executeCommand[i] = "ls -ltr " + mountPoint
								+ symlinkPath[i] + " |grep -i "
								+ specifiedlteTypeNode.trim();
						log.info("CheckingNodeInformation : lteFdnSymboliclink -Execute :  "
								+ executeCommand[i]);
						symbolicLink[i] = helper.simpleExec(executeCommand[i]);
						log.info("lteFdnSymboliclink File :  "
								+ symbolicLink[i]);
					}
					for (int j = 0; j < symbolicLink.length; j++) {
						if ((symbolicLink[j] != null && symbolicLink[j]
								.length() > 0)) {// ||(topologyData1!= null &&
													// topologyData1.length()>0)||(topologyData2!=
													// null &&
													// topologyData2.length()>0)||(topologyData3!=
													// null &&
													// topologyData3.length()>0)){
							return true;
						}
					}
				}
			}
		} catch (Exception e) {
			log.error(
					"lteFdnSymboliclink :: Error in fetching LTE Symbolic Link !! ",
					e);
			return false;
		}
		return result;
	}

	public boolean lteFdnEventSymboliclink(String lteType,
			String eventSymlinkPat[]) {
		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(lteType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		log.info("CheckingNodeInformation : lteFdnEventSymboliclink: NEType - "
				+ lteType);
		if (noNodes) {
			log.info("CheckingNodeInformation : lteFdnEventSymboliclink: No nodes for netype"
					+ lteType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {
				String eventMountPoint = Eniq_Eniqm_Loc_Path().trim();
				for (String ltefdnEventSymLink : listOfNodeOfNeType) {
					String executeCommand[] = new String[eventSymlinkPat.length];
					String symbolicLink[] = new String[eventSymlinkPat.length];
					for (int i = 0; i < eventSymlinkPat.length; i++) {
						executeCommand[i] = "ls -ltr " + eventMountPoint
								+ eventSymlinkPat[i] + " |grep -i "
								+ ltefdnEventSymLink.trim();
						log.info("CheckingNodeInformation : lteFdnEventSymboliclink -Execute :  "
								+ executeCommand[i]);
						symbolicLink[i] = helper.simpleExec(executeCommand[i]);
						log.info("lteFdnEventSymboliclink File :  "
								+ symbolicLink[i]);
					}
					for (int j = 0; j < symbolicLink.length; j++) {
						if ((symbolicLink[j] != null && symbolicLink[j]
								.length() > 0)) {// ||(topologyData1!= null &&
													// topologyData1.length()>0)||(topologyData2!=
													// null &&
													// topologyData2.length()>0)||(topologyData3!=
													// null &&
													// topologyData3.length()>0)){
							return true;
						}
					}
				}
			}

		} catch (Exception e) {
			log.error(
					"lteFdnEventSymboliclink :: Error in fetching  LTE Symbolic Link !! ",
					e);
			return false;
		}
		return result;
	}

	public boolean platformBasedFdnsTopology(String nodeType,
			String topologyPath[]) {
		boolean result = false;
		try {

			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(nodeType);
			int isZero = listOfNodeOfNeType.size();
			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			log.info("CheckingNodeInformation : platformBasedFdnsTopology: NEType - "
					+ nodeType);
			if (noNodes) {
				log.info("CheckingNodeInformation : platformBasedFdnsTopology: No nodes for netype"
						+ nodeType + " : " + noNodes);
				return true;
			}

			if (CheckMountPoint == true && !noNodes) {
				for (String specifiedTypeNode : listOfNodeOfNeType) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand[] = new String[topologyPath.length];
					String topologyData[] = new String[topologyPath.length];
					for (int i = 0; i < topologyPath.length; i++) {
						executeCommand[i] = "ls -ltr " + volumePoint
								+ topologyPath[i] + " |grep -i "
								+ specifiedTypeNode.trim();
						log.info("CheckingNodeInformation : platformBasedFdnsTopology -Execute :  "
								+ executeCommand[i]);
						topologyData[i] = helper.simpleExec(executeCommand[i]);
						log.info("Topology File :  " + topologyData[i]);
					}
					for (int j = 0; j < topologyData.length; j++) {
						if ((topologyData[j] != null && topologyData[j]
								.length() > 0)) {// ||(topologyData1!= null &&
													// topologyData1.length()>0)||(topologyData2!=
													// null &&
													// topologyData2.length()>0)||(topologyData3!=
													// null &&
													// topologyData3.length()>0)){
							return true;
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("Error occured in platformBasedFdnsTopology", e);
			return false;
		}

		return result;
	}

	public boolean platformBasedFdnSymboliclink(String neType,
			String symlinkPath[]) {
		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(neType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		log.info("CheckingNodeInformation : platformBasedFdnSymboliclink: NEType - "
				+ neType);
		if (noNodes) {
			log.info("CheckingNodeInformation : platformBasedFdnSymboliclink: No nodes for netype"
					+ neType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {

				String mountPoint = Eniq_Volume_Mt_Point().trim();
				for (String specifiedTypeNode : listOfNodeOfNeType) {
					String executeCommand[] = new String[symlinkPath.length];
					String symbolicLink[] = new String[symlinkPath.length];
					for (int i = 0; i < symlinkPath.length; i++) {
						executeCommand[i] = "ls -ltr " + mountPoint
								+ symlinkPath[i] + " |grep -i "
								+ specifiedTypeNode.trim();
						log.info("CheckingNodeInformation : platformBasedFdnSymboliclink -Execute :  "
								+ executeCommand[i]);
						symbolicLink[i] = helper.simpleExec(executeCommand[i]);
						log.info("platformBasedFdnSymboliclink File :  "
								+ symbolicLink[i]);
					}
					for (int j = 0; j < symbolicLink.length; j++) {
						if ((symbolicLink[j] != null && symbolicLink[j]
								.length() > 0)) {// ||(topologyData1!= null &&
													// topologyData1.length()>0)||(topologyData2!=
													// null &&
													// topologyData2.length()>0)||(topologyData3!=
													// null &&
													// topologyData3.length()>0)){
							return true;
						}
					}
				}
			}
		} catch (Exception e) {
			log.error(
					"platformBasedFdnSymboliclink :: Error in fetching Symbolic Link !! ",
					e);
			return false;
		}
		return result;
	}

	public boolean platformBasedFdnEventSymboliclink(String neType,
			String eventSymlinkPat[]) {
		boolean result = false;
		ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
				.get(neType);
		int isZero = listOfNodeOfNeType.size();
		boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
		log.info("CheckingNodeInformation : platformBasedFdnEventSymboliclink: NEType - "
				+ neType);
		if (noNodes) {
			log.info("CheckingNodeInformation : platformBasedFdnEventSymboliclink: No nodes for netype"
					+ neType + " : " + noNodes);
			return true;
		}
		try {
			if ((CheckMountPoint == true && CheckCXCFiles == true) && !noNodes) {
				String eventMountPoint = Eniq_Eniqm_Loc_Path().trim();
				for (String fdnEventSymLink : listOfNodeOfNeType) {
					if (!fdnEventSymLink.contains("ESAPC")) {
						String executeCommand[] = new String[eventSymlinkPat.length];
						String symbolicLink[] = new String[eventSymlinkPat.length];
						for (int i = 0; i < eventSymlinkPat.length; i++) {
							executeCommand[i] = "ls -ltr " + eventMountPoint
									+ eventSymlinkPat[i] + " |grep -i "
									+ fdnEventSymLink.trim();
							log.info("CheckingNodeInformation : platformBasedFdnEventSymboliclink -Execute :  "
									+ executeCommand[i]);
							symbolicLink[i] = helper
									.simpleExec(executeCommand[i]);
							log.info("platformBasedFdnEventSymboliclink File :  "
									+ symbolicLink[i]);
						}
						for (int j = 0; j < symbolicLink.length; j++) {
							if ((symbolicLink[j] != null && symbolicLink[j]
									.length() > 0)) {// ||(topologyData1!= null
														// &&
														// topologyData1.length()>0)||(topologyData2!=
														// null &&
														// topologyData2.length()>0)||(topologyData3!=
														// null &&
														// topologyData3.length()>0)){
								return true;
							}
						}
					} else {
						log.info("platformBasedFdnEventSymboliclin : No EvEnt SymLinks for ESAPC Node");
						return true;
					}
				}
			}

		} catch (Exception e) {
			log.error(
					"platformBasedFdnEventSymboliclink :: Error in fetching  Symbolic Link !! ",
					e);
			return false;
		}
		return result;
	}

	public boolean checkTopologyData(String neType, String topologyPath) {

		boolean nodeVer = false;
		boolean userlabel = false;
		boolean managedelementType = false;
		boolean result = false;

		try {
			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(neType);
			log.info("CheckingNodeInformation : nodeFdnsTopology: NEType - "
					+ neType);
			int isZero = listOfNodeOfNeType.size();

			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			if (noNodes) {
				log.info("CheckingNodeInformation : nodeFdnsTopology: No nodes for netype"
						+ neType + " : " + noNodes);
				return true;
			}

			if (CheckMountPoint == true && !noNodes) {

				for (String specifiedTypeNode : listOfNodeOfNeType) {

					System.out.println("********" + specifiedTypeNode);
					String volumePoint = Eniq_Volume_Mt_Point().trim();

					if (neType.equals("CPG")) {
						topologyPath = topologyPath + "/";
					}

					String executeCommand = "ls -ltr " + volumePoint
							+ topologyPath + " |grep -i "
							+ specifiedTypeNode.trim();
					String topologyData = helper.simpleExec(executeCommand);

					if (!topologyData.equals("") && topologyData.length() > 0) {

						String topologyFileName = topologyData
								.substring(topologyData.indexOf("SubNetwork"));
						String executeCommand1 = "more " + volumePoint
								+ topologyPath + topologyFileName.trim()
								+ " | grep -i NodeVersion ";
						String nodeVersion = helper.simpleExec(executeCommand1);
						String executeCommand2 = "more " + volumePoint
								+ topologyPath + topologyFileName.trim()
								+ " | grep -i UserLabel ";
						String userLabel = helper.simpleExec(executeCommand2);
						String csManagedElementType = CsProxy.nodeDetails.get(
								specifiedTypeNode).get("managedElementType");
						String executeCommand3 = "more " + volumePoint
								+ topologyPath + topologyFileName.trim()
								+ " | grep -i item ";
						String managedElementType = (String) helper
								.simpleExec(executeCommand3);
						String metype = managedElementType.trim();
						String csManagedElementTypesplit = csManagedElementType
								.replace("\"", "");
						String[] csmanagedElementTypes = csManagedElementTypesplit
								.split("\\s+");

						if (neType.equals("HSS-FE")) {
							managedelementType = true;
							nodeVer = true;
						} else
							for (int i = 0; i < csmanagedElementTypes.length; i++) {
								managedelementType = false;
								if (metype.contains((csmanagedElementTypes[i]))) {
									managedelementType = true;
								}
							}

						if (!managedelementType) {
							managedelementType = false;
							break;
						}

						if (!(neType == "HSS-FE"))
							if (nodeVersion.contains(CsProxy.nodeDetails.get(
									specifiedTypeNode).get("nodeVersion"))) {
								nodeVer = true;

							}
						if (userLabel.contains(CsProxy.nodeDetails.get(
								specifiedTypeNode).get("userLabel"))) {
							userlabel = true;
						}

					}
					if (!(nodeVer == true && userlabel == true && managedelementType == true)) {
						return false;
					} else {
						result = true;
					}
				}
			} else {
				log.error("CheckingNodeInformation: checkTopologyData :: Please check if mouting is prop ");
				return false;
			}
		} catch (Exception e) {
			log.error(
					"CheckingNodeInformation: checkTopologyData - Exception for "
							+ neType, e);
			return false;
		}
		return result;
	}

	public boolean checklteTopologyData(String lteType, String topologyPath[]) {

		boolean nodeVer = false;
		boolean userlabel = false;
		boolean managedelementType = false;
		boolean result = false;
		try {

			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(lteType);
			int isZero = listOfNodeOfNeType.size();
			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			log.info("CheckingNodeInformation : lteNodeFdnsTopology: NEType - "
					+ lteType);
			if (noNodes) {
				log.info("CheckingNodeInformation : ltenodeFdnsTopology: No nodes for netype"
						+ lteType + " : " + noNodes);
				return true;
			}

			if (CheckMountPoint == true && !noNodes) {
				for (String specifiedlteTypeNode : listOfNodeOfNeType) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand[] = new String[topologyPath.length];
					String topologyData[] = new String[topologyPath.length];
					for (int i = 0; i < topologyPath.length; i++) {
						log.info("specified lte node type:"
								+ specifiedlteTypeNode);
						executeCommand[i] = "ls -ltr " + volumePoint
								+ topologyPath[i] + " |grep -i "
								+ specifiedlteTypeNode.trim();
						log.info("CheckingNodeInformation : lteNodeFdnsTopology -Execute :  "
								+ executeCommand[i]);
						topologyData[i] = helper.simpleExec(executeCommand[i]);
						log.info("Topology File :  " + topologyData[i]);

						for (int j = 0; j < topologyData.length; j++) {
							if ((topologyData[j] != null && topologyData[j]
									.length() > 0)) {
								if (!topologyData[j].equals("")
										&& topologyData[j].length() > 0) {

									String topologyFileName = topologyData[j]
											.substring(topologyData[j]
													.indexOf("SubNetwork"));
									String executeCommand1 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i NodeVersion";
									String nodeVersion = helper
											.simpleExec(executeCommand1);
									String executeCommand2 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i UserLabel";
									String userLabel = helper
											.simpleExec(executeCommand2);
									String csManagedElementType = CsProxy.nodeDetails
											.get(specifiedlteTypeNode).get(
													"managedElementType");
									String executeCommand3 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i managedElementType";
									String managedElementType = helper
											.simpleExec(executeCommand3);
									String csManagedElementTypesplit = csManagedElementType
											.replace("\"", "");
									String[] csmanagedElementTypes = csManagedElementTypesplit
											.split("\\s+");
									if (specifiedlteTypeNode.length() == 5) {
										result = true;
									}

									else {
										if (nodeVersion
												.contains(CsProxy.nodeDetails
														.get(specifiedlteTypeNode)
														.get("nodeVersion"))) {
											nodeVer = true;

										}
										if (userLabel
												.contains(CsProxy.nodeDetails
														.get(specifiedlteTypeNode)
														.get("userLabel"))) {
											userlabel = true;
										}

										if (managedElementType
												.contains(csmanagedElementTypes[0])) {
											managedelementType = true;
										}

										if (!(nodeVer == true
												&& userlabel == true && managedelementType == true)) {
											return false;
										} else {
											result = true;
										}
									}
								}
							}

						}
					}
				}

			}
			return result;
		}

		catch (Exception e) {
			log.error("Error occured in lteNodeFdnsTopology", e);
			return false;
		}
		

	}

	public boolean checkplatformBasedTopologyData(String platformBasedType, String topologyPath[]) {

		boolean nodeVer = false;
		boolean userlabel = false;
		boolean managedelementType = false;
		boolean result = false;
		try {

			ArrayList<String> listOfNodeOfNeType = CsProxy.nodesForMeType
					.get(platformBasedType);
			int isZero = listOfNodeOfNeType.size();
			boolean noNodes = (isZero == 0) || (listOfNodeOfNeType == null);
			log.info("CheckingNodeInformation : platformBasedNodeFdnsTopology: NEType - "
					+ platformBasedType);
			if (noNodes) {
				log.info("CheckingNodeInformation : platformBasednodeFdnsTopology: No nodes for netype"
						+ platformBasedType + " : " + noNodes);
				return true;
			}

			if (CheckMountPoint == true && !noNodes) {
				for (String specifiedplatformBasedTypeNode : listOfNodeOfNeType) {
					String volumePoint = Eniq_Volume_Mt_Point().trim();
					String executeCommand[] = new String[topologyPath.length];
					String topologyData[] = new String[topologyPath.length];
					for (int i = 0; i < topologyPath.length; i++) {
						log.info("specified platformBased node type:"
								+ specifiedplatformBasedTypeNode);
						executeCommand[i] = "ls -ltr " + volumePoint
								+ topologyPath[i] + " |grep -i "
								+ specifiedplatformBasedTypeNode.trim();
						log.info("CheckingNodeInformation : platformBasedNodeFdnsTopology -Execute :  "
								+ executeCommand[i]);
						topologyData[i] = helper.simpleExec(executeCommand[i]);
						log.info("Topology File :  " + topologyData[i]);

						for (int j = 0; j < topologyData.length; j++) {
							if ((topologyData[j] != null && topologyData[j]
									.length() > 0)) {
								if (!topologyData[j].equals("")
										&& topologyData[j].length() > 0) {

									String topologyFileName = topologyData[j]
											.substring(topologyData[j]
													.indexOf("SubNetwork"));
									String executeCommand1 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i NodeVersion";
									String nodeVersion = helper
											.simpleExec(executeCommand1);
									String executeCommand2 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i UserLabel";
									String userLabel = helper
											.simpleExec(executeCommand2);
									String csManagedElementType = CsProxy.nodeDetails
											.get(specifiedplatformBasedTypeNode).get(
													"managedElementType");
									String executeCommand3 = "more "
											+ volumePoint + topologyPath[i]
											+ topologyFileName.trim()
											+ " | grep -i managedElementType";
									String managedElementType = helper
											.simpleExec(executeCommand3);
									String csManagedElementTypesplit = csManagedElementType
											.replace("\"", "");
									String[] csmanagedElementTypes = csManagedElementTypesplit
											.split("\\s+");
									if (specifiedplatformBasedTypeNode.length() == 5) {
										result = true;
									}

									else {
										if (nodeVersion
												.contains(CsProxy.nodeDetails
														.get(specifiedplatformBasedTypeNode)
														.get("nodeVersion"))) {
											nodeVer = true;

										}
										if (userLabel
												.contains(CsProxy.nodeDetails
														.get(specifiedplatformBasedTypeNode)
														.get("userLabel"))) {
											userlabel = true;
										}

										if (managedElementType
												.contains(csmanagedElementTypes[0])) {
											managedelementType = true;
										}

										if (!(nodeVer == true
												&& userlabel == true && managedelementType == true)) {
											return false;
										} else {
											result = true;
										}
									}
								}
							}

						}
					}
				}

			}
			return result;
		}

		catch (Exception e) {
			log.error("Error occured in platformBasedNodeFdnsTopology", e);
			return false;
		}
		

	}

	
	
}
