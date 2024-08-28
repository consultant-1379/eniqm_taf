package com.ericsson.eniqm.operators.cases;

import com.ericsson.eniqm.operators.cases.HostProperties;
import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;

public class CLICommandLine {
	
	static final Host rcHost=HostProperties.HostRC();
	static final CLICommandHelper cliCommandRC = new CLICommandHelper(rcHost, rcHost.getUsers(UserType.ADMIN).get(0));
	
	static final Host gateWayHost=HostProperties.HostGATEWAY();
	static final CLICommandHelper cliCommandGateWay = new CLICommandHelper(gateWayHost, gateWayHost.getUsers(UserType.ADMIN).get(0));
	
	static final CLICommandHelper cmdHelper = new CLICommandHelper(DataHandler.getHostByType(HostType.RC), DataHandler.getHostByType(HostType.RC).getUsers(UserType.ADMIN).get(0));;
	
	
	static final Host host=HostProperties.HostGATEWAY();
	static final CLICommandHelper cliHost= new CLICommandHelper(host);
	
	
	public static CLICommandHelper cliCommandRC()
	{
	
		return cliCommandRC;
	}
	
	public static CLICommandHelper cliCommandGATEWAY()
	{
		return cliCommandGateWay;
	}
	
	public static CLICommandHelper cli()
	{
			return cmdHelper;
	}
	
	public static CLICommandHelper cliHost()
	{
		
		  return cliHost;
	}
	
}
