package com.ericsson.eniqm.operators.cases;

import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;

public class HostProperties {

	
	public static Host HostRC()
	{
		Host host = DataHandler.getHostByType(HostType.RC);
		return host;
		
		}
	
	public static Host HostGATEWAY()
	{ 
	Host host = DataHandler.getHostByType(HostType.GATEWAY);
	return host;
	
	}
	
	
	
	
	
}