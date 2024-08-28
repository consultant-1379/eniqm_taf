package com.ericsson.eniqm.test;

import org.testng.annotations.Test;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.DataDriven;
import com.ericsson.cifwk.taf.annotations.Input;
import com.ericsson.eniqm.operators.node.cases.CheckingNodeInformation;
import com.ericsson.eniqm.operators.CheckingCXCFilesInterface;
import com.ericsson.eniqm.operators.CheckingConfigFilesInterface;
import com.ericsson.eniqm.operators.CheckingMCAfterRestartInterface;
import com.ericsson.eniqm.operators.CheckingMCStatusInterface;
import com.ericsson.eniqm.operators.CheckingMountPointInterface;
import com.ericsson.eniqm.operators.CheckingStarteniqmInterface;
import com.ericsson.eniqm.operators.CsProxy;
import com.ericsson.eniqm.operators.cases.CheckingCXCFiles;
import com.ericsson.eniqm.operators.cases.CheckingConfigFiles;
import com.ericsson.eniqm.operators.cases.CheckingMCAfterRestart;
import com.ericsson.eniqm.operators.cases.CheckingMCStatus;
import com.ericsson.eniqm.operators.cases.CheckingMountPoint;
import com.ericsson.eniqm.operators.cases.CheckingStarteniqm;
import com.ericsson.eniqm.operators.cases.EniqmScriptExecutor;
import com.esotericsoftware.minlog.Log;

@SuppressWarnings("deprecation")
public class TestClass extends TorTestCaseHelper implements TestCase {

	EniqmScriptExecutor eniqmScriptExecutor;

	public static boolean isEniqMounted;

	/*@Test
 	public void Eniqmounting(){
		Logger logger = Logger.getLogger(TestClass.class.getName());
		String pattern="\n-----------------------------------------------------------------------------\n";

	HostInfoUsage host = HostInfoUsage.getInstance();
	RemoteObjectHandler remoteFileHandler = new RemoteObjectHandler(host.pmsHost, new User("nmsadm", "nms27511", UserType.OPER));
	CLICommandHelper cli = new CLICommandHelper(host.pmsHost, new User("nmsadm", "nms27511", UserType.OPER));
	 
//	@Context(context = {Context.API})
	//Id(id = "Mounting", title = "ENIQMounting")
	@Test
	public void Mounting() {
		logger.info(pattern+"in Mounting Method"+pattern);
		String Script = "eniqmount1.py";
		for(String input : Script){
		logger.info(pattern+"transferring .py file to server :"+input+""+pattern);
		List<String> Eniqm = FileFinder.findFile(input);
		String localFileToTransfer = null;
		logger.info(pattern+"File in the list :"+Eniqm.toString()+pattern);
		for (String file : Eniqm){
			logger.info(pattern+""+file+""+pattern);
			if(file.contains("target/contents")){
				logger.info("inside if condition");
				localFileToTransfer = file;
			}else{
				logger.info(pattern+"else condition"+pattern);
			}
		}
		logger.info(pattern+"file found in below path:"+localFileToTransfer+""+pattern);
	
		boolean result=remoteFileHandler.copyLocalFileToRemote(localFileToTransfer,"/");
				logger.info(count+") "+localFileToTransfer+"Local File Copied::"+result);
			    logger.info(pattern+"applying chmod 750 for :: "+input+ pattern);	
		String chmod=cli.simpleExec("cd / && chmod 750 "+input);
		        logger.info(pattern+"chmod"+pattern);		
		}
		logger.info(pattern+"******** Files Transfered ********"+pattern);	
		logger.info(pattern+"******** ENIQ Mounting is in progress ********"+pattern);	
  		String setup = cli.simpleExec("cd / && perl eniqmount1.py").trim();
		logger.info(pattern+"ENIQ Mounting setup status ::"+setup+pattern);
	}
}*/

	@Test
	@DataDriven(name = "test_cases")
	public void testScriptCases(@Input("TestCases") String tc) {
		if (eniqmScriptExecutor == null) {
			eniqmScriptExecutor = new EniqmScriptExecutor();
		}
		String value = eniqmScriptExecutor.executeScript(tc);

		assertEquals(value, "PASS");
	}

	@Test
	public void testMCStatus() {
		Log.info("Checking MC status ");
		CheckingMCStatusInterface obj = new CheckingMCStatus();

		boolean value = obj.checkMC();
		Log.info("Checking MC status" + "Result: " + value);
		assertEquals(value, true);
	}

	@Test
	public void testCXCFiles() {
		// new CheckingLTENodeInformation();
		CheckingCXCFilesInterface obj = new CheckingCXCFiles();
		boolean value = obj.CXCFiles();
		Log.info("testCXCFiles" + "Result: " + value);
		assertEquals(value, true);
	}

	@Test
	public void testMountPoint() {
		CheckingMountPointInterface obj = new CheckingMountPoint();
		Log.info("Checking MountPoint ");
		boolean isEniqMounted = obj.MountPoint();
		Log.info("testMountPoint" + "Result: " + isEniqMounted);
		assertEquals(isEniqMounted, true);
	}

	@Test
	public void testConfigFiles() {
		CheckingConfigFilesInterface obj = new CheckingConfigFiles();
		Log.info("Checking ConfigFiles ");
		boolean value = obj.checkConfig();
		Log.info("testConfigFiles" + "Result: " + value);
		assertEquals(value, true);
	}

	@Test
	public void testStartEniqm() {
		CheckingStarteniqmInterface obj = new CheckingStarteniqm();
		Log.info("Checking Start Eniqm ");
		boolean value = obj.starteniqm();
		Log.info("testStartEniqm" + "Result: " + value);
		assertEquals(value, true);
	}

	@Test
	public void testMCAfterRestart() {
		CheckingMCAfterRestartInterface obj = new CheckingMCAfterRestart();
		Log.info("Checking MCafterRestart Eniqm ");
		boolean value = obj.MCRestart();
		Log.info("testMCAfterRestart" + "Result: " + value);
		assertEquals(value, true);
	}

	CheckingNodeInformation nodeInfo = CheckingNodeInformation.getInstance();
	static CsProxy csProxy = CsProxy.getInstance();
	static {
		csProxy.populateCSData();
	}

	@Test
	@DataDriven(name = "node_details")
	public void testNodeInfo(@Input("NodeType") final String nodeType,
			@Input("TopologyPath") final String topologyPath,
			@Input("EventSymlinkPath") final String eventSymlinkPath,
			@Input("StatSymlinkPath") final String symlinkPath

	)

	{

		try {
			boolean topologyFileData = false;
			boolean eventSymbolicLink = false;
			boolean symbolicLink = false;
			boolean node = false;
			try {
				Log.info("TestClass : testNodeInfo : Check Topology File for Node Type:"
						+ nodeType + "with Topology path :" + topologyPath);
				topologyFileData = nodeInfo.nodeFdnsTopology(nodeType,
						topologyPath);

			} catch (Exception e) {
				Log.error(
						"testTopologyFiles :: Exception while fetching Topology File .. "
								+ nodeType, e);
			}

			try {
				Log.info("TestClass : testNodeInfo :Check symbolicLink for Node Type:"
						+ nodeType + "with symbolicLinkpath :" + symlinkPath);
				symbolicLink = nodeInfo.nodeFdnsTopology(nodeType, symlinkPath);
			} catch (Exception e) {
				Log.error(
						"testEventSymbolicLink :: Exception while fetching EventSymbolic Link ..  "
								+ nodeType, e);
			}

			try {
				if (!eventSymlinkPath.equals("NA")) {
					Log.info("TestClass : testNodeInfo :Check eventSymbolicLink for Node Type:"
							+ nodeType
							+ "with eventSymlinkPath:"
							+ eventSymlinkPath);
					eventSymbolicLink = nodeInfo.fdnEventSymboliclink(nodeType,
							eventSymlinkPath);
				} else {
					eventSymbolicLink = true;
				}
			} catch (Exception e) {
				Log.error(
						"testNodeSymbolicLink :: Exception while fetching Symbolic Link ..  "
								+ nodeType, e);

			}
			if (topologyFileData == true && symbolicLink == true
					&& eventSymbolicLink == true) {
				node = true;

			}
			assertEquals(node, true);
		} catch (Exception e) {
			Log.error(
					"testNodeInfo :: Exception while Checking files and symlinks for the Node ..  "
							+ nodeType, e);

		}
	}

	@Test
	@DataDriven(name = "node_details")
	public void checkTopologyData(@Input("NodeType") final String nodeType,
			@Input("TopologyPath") final String topologyPath)

	{
		boolean topologyData = false;
		try {

			Log.info("TestClass : checkTopologyData : Check Topology Data in the File for Node Type:"
					+ nodeType + "with Topology path :" + topologyPath);
			topologyData = nodeInfo.checkTopologyData(nodeType, topologyPath);
			assertEquals(topologyData, true);
		}

		catch (Exception e) {
			Log.error(
					"checkTopologyData :: Exception while Checking Topology Data..  "
							+ nodeType, e);

		}
	}

	@Test
	@DataDriven(name = "ltenode_details")
	public void testLteNodeInfo(@Input("NodeType") final String nodeType,
			@Input("TopologyPath") final String topologyPath[],
			@Input("EventSymlinkPath") final String eventSymlinkPath[],
			@Input("SymlinkPath") final String symlinkPath[]

	) {
		try {
			boolean topologyFileData = false;
			boolean eventSymbolicLink = false;
			boolean symbolicLink = false;
			boolean lteNode = false;

			try {
				Log.info("Check Topology File for LTE Node Type:" + nodeType
						+ "with Topology path :" + topologyPath);
				topologyFileData = nodeInfo.lteNodeFdnsTopology(nodeType,
						topologyPath);
			} catch (Exception e) {
				Log.error(
						"testLteTopologyFiles :: Exception while fetching Topology File .. "
								+ nodeType, e);
			}

			try {
				Log.info("Check LTE eventSymbolicLink File for Node Type:"
						+ nodeType + "with eventSymlinkPath :"
						+ eventSymlinkPath);
				eventSymbolicLink = nodeInfo.lteFdnEventSymboliclink(nodeType,
						eventSymlinkPath);
			} catch (Exception e) {
				Log.error(
						"testLteEventSymbolicLink :: Exception while fetching EventSymbolic Link ..  "
								+ nodeType, e);
			}
			try {

				Log.info("Check LTE symbolicLink File for Node Type:"
						+ nodeType + "with symlinkPath :" + symlinkPath);
				symbolicLink = nodeInfo.lteFdnSymboliclink(nodeType,
						symlinkPath);
			} catch (Exception e) {
				Log.error(
						"testLteNodeSymbolicLink :: Exception while fetching Symbolic Link ..  "
								+ nodeType, e);
			}
			if (topologyFileData == true && symbolicLink == true
					&& eventSymbolicLink == true) {
				lteNode = true;

			}
			assertEquals(lteNode, true);

		}

		catch (Exception e) {
			Log.error(
					"testLteNodeInfo :: Exception while Checking files and symlinks for the LTE Node.. "
							+ nodeType, e);
		}

	}

	@Test
	@DataDriven(name = "ltenode_details")
	public void checklTETopologyData(@Input("NodeType") final String nodeType,
			@Input("TopologyPath") final String topologyPath[])

	{
		boolean topologyData = false;
		try {

			for (int i = 0; i < topologyPath.length; i++)
				Log.info("TestClass : checkLTETopologyData : Check LTETopology Data in the File for Node Type:"
						+ nodeType + " with Topology path :" + topologyPath[i]);
			topologyData = nodeInfo
					.checklteTopologyData(nodeType, topologyPath);
			assertEquals(topologyData, true);
		}

		catch (Exception e) {
			Log.error(
					"checklteTopologyData :: Exception while Checking Topology Data..  "
							+ nodeType, e);

		}
	}

	@Test
	@DataDriven(name = "platformBasedNode_details")
	public void platformBasedTopologyFiles(
			@Input("NodeType") final String nodeType,
			@Input("TopologyPath") final String topologyPath[],
			@Input("EventSymlinkPath") final String eventSymlinkPath[],
			@Input("SymlinkPath") final String symlinkPath[])

	{
		try {
			boolean topologyFileData = false;
			boolean eventSymbolicLink = false;
			boolean symbolicLink = false;
			boolean platformNode = false;

			try {
				Log.info("Check Topology File for platformBased Node Type:"
						+ nodeType + "with Topology path :" + topologyPath);
				topologyFileData = nodeInfo.platformBasedFdnsTopology(nodeType,
						topologyPath);
			} catch (Exception e) {
				Log.error(
						"platformBasedTopologyFiles :: Exception while fetching Topology File .. "
								+ nodeType, e);
			}
			try {

				Log.info("Check platformBased eventSymbolicLink File for Node Type:"
						+ nodeType
						+ "with eventSymlinkPath :"
						+ eventSymlinkPath);
				eventSymbolicLink = nodeInfo.platformBasedFdnEventSymboliclink(
						nodeType, eventSymlinkPath);
			} catch (Exception e) {
				Log.error(
						"platformBasedEventSymbolicLink :: Exception while fetching EventSymbolic Link ..  "
								+ nodeType, e);
			}
			try {

				Log.info("Check platformBased symbolicLink File for Node Type:"
						+ nodeType + "with symlinkPath :" + symlinkPath);
				symbolicLink = nodeInfo.platformBasedFdnSymboliclink(nodeType,
						symlinkPath);
			} catch (Exception e) {
				Log.error(
						"platformBasedNodeSymbolicLink :: Exception while fetching Symbolic Link ..  "
								+ nodeType, e);
			}
			if (topologyFileData == true && symbolicLink == true
					&& eventSymbolicLink == true) {
				platformNode = true;

			}
			assertEquals(platformNode, true);
		} catch (Exception e) {
			Log.error(
					"platformBasedTopologyFiles :: Exception while Checking files and symlinks for the platform Node .. "
							+ nodeType, e);
		}
	}

	// @Test
	// @DataDriven(name="platformBasedNode_details")
	// public void checkPlatformBasedTopologyData
	// (
	// @Input("NodeType") final String nodeType,
	// @Input("TopologyPath") final String topologyPath[]
	// )
	//
	//
	// {
	// boolean topologyData=false;
	// try
	// {
	//
	// for(int i=0;i<topologyPath.length;i++)
	// Log.info("TestClass : checkPlatformTopologyData : Check PlatformTopology Data in the File for Node Type:"+nodeType+" with Topology path :"+topologyPath[i]);
	// topologyData=nodeInfo.checkplatformBasedTopologyData(nodeType,
	// topologyPath);
	// assertEquals(topologyData, true);
	// }
	//
	// catch(Exception e)
	// {
	// Log.error("checklteTopologyData :: Exception while Checking Topology Data..  "
	// +nodeType , e);
	//
	//
	// }
	// }

}
