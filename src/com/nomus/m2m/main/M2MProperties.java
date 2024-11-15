package com.nomus.m2m.main;

public class M2MProperties {

	String httpserverpath;
	String tlsconfigspath;
	String firmwaredir;
	String targetfilename;
	public String getFirmwaredir() {
		return firmwaredir;
	}
	public void setFirmwaredir(String firmwaredir) {
		this.firmwaredir = firmwaredir;
	}
	public String getHttpserverpath() {
		return httpserverpath;
	}
	public String getTargetfilename() {
		return targetfilename;
	}
	public void setTargetfilename(String targetfilename) {
		this.targetfilename = targetfilename;
	}
	public void setHttpserverpath(String httpserverpath) {
		this.httpserverpath = httpserverpath;
	}
	public String getTlsconfigspath() {
		return tlsconfigspath;
	}
	public void setTlsconfigspath(String tlsconfigspath) {
		this.tlsconfigspath = tlsconfigspath;
	}

	
}
