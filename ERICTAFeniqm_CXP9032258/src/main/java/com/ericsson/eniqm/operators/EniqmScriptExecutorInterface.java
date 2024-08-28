package com.ericsson.eniqm.operators;

import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;

public interface EniqmScriptExecutorInterface {

	public void init();
	public boolean copySuiteToServer(Host host, RemoteObjectHandler remote);
	public String unZipSuite();
	public String unTarSuite();
	public void copySuiteToRoot();
	public void setPermissions();
	public String executeScript(String tc);
	
}
