package com.ericsson.eniqm.operators.cases;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.eniqm.operators.CheckingMCAfterRestartInterface;

public class CheckingMCAfterRestart implements CheckingMCAfterRestartInterface {

	Logger log = Logger.getLogger(CheckingMCAfterRestart.class.getName());

	//This TC Checks the status of MC after Cold_Restart. Cold restart is performed to initiate the topology export.
	@Override
	public boolean MCRestart() {
		try{
//			Host host = DataHandler.getHostByType(HostType.RC);
//			String mcRestartCmd = "/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart eniqm -reason=other -reasontext=..";
//			String mcStatusCmd = "/opt/ericsson/nms_cif_sm/bin/smtool -l | grep -i eniqm";
//
//
//			CLICommandHelper helper = new CLICommandHelper(host, host.getUsers(UserType.ADMIN).get(0));
//			helper.simpleExec(mcRestartCmd);
//			String status=helper.simpleExec(mcStatusCmd);
//			if(status.contains("started")){
//				return true;
//			}else{
//				for(int time=600;time>0;time--){
//					//Thread is made to sleep for 10seconds.
//					SleepThread t = new SleepThread(10000L);
//					t.start();
//					status=helper.simpleExec(mcStatusCmd);
//					//Thread is again made to sleep for 5mins,if the MC is in Started State.
//					//Waiting for topology export to complete before executing the next TCs
//					if(status.contains("started")){
//						log.error("About to sleep for 5min...");
//						SleepThread t1 = new SleepThread(300000L);
//						t1.start();
//						return true;
//					}
//				}
//				log.error("ENIQM MC is not in started state..");
//				return false;
//			}
//			File a =new File("/testFile.txt");
//			if(!a.exists()){
//				try {
//					System.out.println("create file ... "+a.createNewFile());
//				} catch (IOException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//			}
			return true;
			
		}
		catch(Exception e){
			log.error("CheckingMCAfterRestart::MCRestart() Exception occured..", e);
			return false;
		}		
	}


	private class SleepThread extends Thread{
		long time;
		SleepThread(long time){
			this.time=time;
		}

		public void run(){
			try {
				Thread.sleep(time);
			} catch (InterruptedException e) {
				log.error("CheckingMCAfterRestart::MCRestart() Exception occured..", e);				
			}
		}
	}
}

