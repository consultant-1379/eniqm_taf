package com.ericsson.eniqm.operators.cases;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.cases.CLICommandLine;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.eniqm.operators.EniqmScriptExecutorInterface;


public class EniqmScriptExecutor implements EniqmScriptExecutorInterface{

	Logger log = Logger.getLogger(EniqmScriptExecutor.class.getName());
	boolean isCopied = false;
	CLICommandHelper cmdHelper = CLICommandLine.cli();


	public EniqmScriptExecutor(){
		init();
	}

	@Override
	public void init(){
		try{
			Host host = HostProperties.HostGATEWAY();
			RemoteObjectHandler remote = new RemoteObjectHandler(DataHandler.getHostByType(HostType.GATEWAY), host.getUsers(UserType.ADMIN).get(0));
			  CLICommandHelper helper =CLICommandLine.cliHost();
			

			System.out.println("Coping Suite from local to server.... ");
			isCopied = copySuiteToServer(host, remote);
			if(isCopied){
			helper.openShell(); 
			helper.runInteractiveScript("scp "+"/" + "ENIQ-M_Automation_Suite.tar.gz"+" root@ossmaster:"+"/"); 
			helper.closeAndValidateShell();
			helper.disconnect();
			//helper.expect("Password:"); helper.interactWithShell("suser101"); 
			}
			//isCopied = copyFile("ENIQ-M_Automation_Suite.tar.gz","/",remote); 
			System.out.println("Is copied to server: " +isCopied);

			if(isCopied){
				System.out.println("Unziping the suite...");
				System.out.println("Unzip Successful? "+unZipSuite());
				//unZipSuite();
				System.out.println("Untaring the suite...");
				System.out.println("PWD"+cmdHelper.simpleExec("pwd"));
				System.out.println(unTarSuite());
				System.out.println(cmdHelper.simpleExec("ls /home/nmsadm/ENIQ-M_Automation_Suite"));
				System.out.println("PWD"+cmdHelper.simpleExec("pwd"));
				System.out.println("Copying suite to root");
				copySuiteToRoot();
				System.out.println("set permissions");
				setPermissions();
				System.out.println("Executing the script");
				//		executeScript1(helper,tc);
			}
		}
		catch(Exception e){
			log.error("EniqmScriptExecutor::init() Exception occured..", e);
		}
	}
	
	@Override
	public boolean copySuiteToServer(Host host, RemoteObjectHandler remote){

		return remote.copyLocalFileToRemote("/ENIQ-M_Automation_Suite.tar.gz", "/ENIQ-M_Automation_Suite.tar.gz");

	}
	@Override
	public String unZipSuite(){	
		 
		System.out.println(""+cmdHelper.simpleExec("chmod 777 /ENIQ-M_Automation_Suite.tar.gz"));
		System.out.println(""+cmdHelper.simpleExec("cp /ENIQ-M_Automation_Suite.tar.gz  /home/nmsadm"));
		System.out.println(""+cmdHelper.simpleExec("cd /home/nmsadm/"));
		return cmdHelper.simpleExec("gunzip /home/nmsadm/ENIQ-M_Automation_Suite.tar.gz");
	}
	@Override
	public String unTarSuite(){
		System.out.println(cmdHelper.simpleExec("cd /home/nmsadm/"));
		return cmdHelper.simpleExec("cd /home/nmsadm/ &&  tar -xvf  ENIQ-M_Automation_Suite.tar  &&  tar -xvf  ENIQ-M_Automation_Suite.tar");
	}
	@Override
	public void copySuiteToRoot(){
		

		System.out.println(""+cmdHelper.simpleExec("mkdir /home/nmsadm/ENIQ-M_Automation_Suite"));
		System.out.println(""+cmdHelper.simpleExec("mkdir /home/nmsadm/ENIQ-M_Automation_Suite/Test_Cases"));
		System.out.println(""+cmdHelper.simpleExec("cp /ENIQ-M_Automation_Suite/* /home/nmsadm/ENIQ-M_Automation_Suite/"));
		System.out.println(""+cmdHelper.simpleExec("cp /ENIQ-M_Automation_Suite/Test_Cases/* /home/nmsadm/ENIQ-M_Automation_Suite/Test_Cases/"));
		System.out.println(""+cmdHelper.simpleExec("mkdir /Test_Cases"));
		System.out.println(""+cmdHelper.simpleExec("cp /ENIQ-M_Automation_Suite/Test_Cases/* /Test_Cases/"));
	}
	@Override
	public void setPermissions(){
		System.out.println(""+cmdHelper.simpleExec("chmod 777 /home/nmsadm/ENIQ-M_Automation_Suite/ENIQ-M_Automation_Suite.pl"));
		System.out.println(""+cmdHelper.simpleExec("chmod 777 /home/nmsadm/ENIQ-M_Automation_Suite/*"));
		System.out.println(""+cmdHelper.simpleExec("chmod 777 /home/nmsadm/ENIQ-M_Automation_Suite"));
		System.out.println(""+cmdHelper.simpleExec("chmod 777 /home/nmsadm/ENIQ-M_Automation_Suite/Test_Cases/*"));
//		System.out.println(""+cmdHelper.simpleExec("chmod 777 /Test_Cases/*"));
//		System.out.println(""+cmdHelper.simpleExec("chmod 777 /ENIQ-M_Automation_Suite/Test_Cases/*"));
//		System.out.println(""+cmdHelper.simpleExec("chmod 777 /ENIQ-M_Automation_Suite/*"));
	}

	@Override
	public String executeScript(String tc){

		System.out.println("Starting Execution:"+tc);
		System.out.println(cmdHelper.simpleExec("cd /home/nmsadm/ENIQ-M_Automation_Suite/Test_Cases/"));
		try{
			if(!tc.equals("<EOF>")){
				System.out.println(cmdHelper.simpleExec("pwd"));
				String output = cmdHelper.simpleExec("/usr/bin/perl  /home/nmsadm/ENIQ-M_Automation_Suite/Test_Cases/"+tc);
				System.out.println("output:: "+output);
				String result= output.substring(output.lastIndexOf("|")+1);

				System.out.println("result:: "+result);
				if(result.trim().equalsIgnoreCase("pass")){
					return "PASS";
				}
				else{
					return "FAIL";
				}
			}
			else{
				removesuiteFromServer();
				return "PASS";
			}

		}
		catch(Exception e){
			log.error("EniqmScriptExecutor::executeScript() Exception occured..", e);
			removesuiteFromServer();
			return "FAIL";
		}			
	}

	public void removesuiteFromServer(){

		System.out.println("Starting Execution");
		System.out.println(""+cmdHelper.simpleExec("cd /"));
		System.out.println(""+cmdHelper.simpleExec("rm -rf ENIQ-M_Automation_Suite.tar.gz ENIQ-M_Automation_Suite/"));
		System.out.println(""+cmdHelper.simpleExec("cd /home/nmsadm/"));
		System.out.println(""+cmdHelper.simpleExec("rm -rf /home/nmsadm/ENIQ-M_Automation_Suite/"));
		System.out.println(""+cmdHelper.simpleExec("rm -rf /home/nmsadm/ENIQ-M_Automation_Suite.tar"));
	}
}

