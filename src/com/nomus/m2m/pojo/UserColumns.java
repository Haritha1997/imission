package com.nomus.m2m.pojo;

import java.util.HashMap;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="usercolumns")
public class UserColumns {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private int id;
	@ManyToOne(fetch = FetchType.LAZY)
	private User user;
	@Column
	private String tableName="dashboard";	
	@Column
	private String nodelabel="yes";
	@Column
	private String cellular_Wan_IP="yes";
	@Column
	private String loopbackip="yes";
	@Column
	private String slnumber="yes";
	@Column
	private String location="yes";
	@Column
	private String fwversion="yes";
	@Column
	private String modelnumber="yes";
	@Column
	private String routeruptime="yes";
	@Column
	private String imeinumber="yes";
	@Column
	private String activesim="yes";
	@Column
	private String network="yes";
	@Column
	private String signalstrength="yes";
	@Column
	private String port1="yes";
	@Column
	private String port2="yes";
	@Column
	private String port3="yes"; 
	@Column
	private String port4="yes";
	@Column
	private String WAN="yes";
	@Column
	private String di1="yes";
	@Column
	private String di2="yes";
	@Column
	private String di3="yes";
	/*S
	 * @Column private String ipaddress="yes"; 
	 * 
	 * @Column private String uptime="yes";
	 * 
	 * @Column private String status="yes";
	 * 
	 * @Column private String cpuutil="yes";
	 * 
	 * @Column private String memoryutil="yes";
	 * 
	 * @Column private String cellid="yes";
	 * 
	 * @Column private String mhversion="yes";
	 * 
	 * @Column private String dhversion="yes";
	 * 
	 * @Column private String modulename="yes";
	 * 
	 * @Column private String nwband="yes";
	 * 
	 * @Column private String iccid="yes";
	 */

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getNodelabel() {
		return nodelabel;
	}

	public void setNodelabel(String nodelabel) {
		this.nodelabel = nodelabel;
	}

	public String getCellular_Wan_IP() {
		return cellular_Wan_IP;
	}

	public void setCellular_Wan_IP(String cellular_Wan_IP) {
		this.cellular_Wan_IP = cellular_Wan_IP;
	}

	public String getLoopbackip() {
		return loopbackip;
	}

	public void setLoopbackip(String loopbackip) {
		this.loopbackip = loopbackip;
	}

	public String getSlnumber() {
		return slnumber;
	}

	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getFwversion() {
		return fwversion;
	}

	public void setFwversion(String fwversion) {
		this.fwversion = fwversion;
	}

	public String getModelnumber() {
		return modelnumber;
	}

	public void setModelnumber(String modelnumber) {
		this.modelnumber = modelnumber;
	}

	public String getRouteruptime() {
		return routeruptime;
	}

	public void setRouteruptime(String routeruptime) {
		this.routeruptime = routeruptime;
	}

	public String getImeinumber() {
		return imeinumber;
	}

	public void setImeinumber(String imeinumber) {
		this.imeinumber = imeinumber;
	}

	public String getActivesim() {
		return activesim;
	}

	public void setActivesim(String activesim) {
		this.activesim = activesim;
	}

	public String getNetwork() {
		return network;
	}

	public void setNetwork(String network) {
		this.network = network;
	}

	public String getSignalstrength() {
		return signalstrength;
	}

	public void setSignalstrength(String signalstrength) {
		this.signalstrength = signalstrength;
	}

	public String getPort1() {
		return port1;
	}

	public void setPort1(String port1) {
		this.port1 = port1;
	}

	public String getPort2() {
		return port2;
	}

	public void setPort2(String port2) {
		this.port2 = port2;
	}

	public String getPort3() {
		return port3;
	}

	public void setPort3(String port3) {
		this.port3 = port3;
	}

	public String getPort4() {
		return port4;
	}

	public void setPort4(String port4) {
		this.port4 = port4;
	}
	public String getWAN() {
		return WAN;
	}

	public void setWAN(String WAN) {
		this.WAN = WAN;
	}
	
	/*public String getIpaddress() {
		return ipaddress;
	}

	public void setIpaddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}

	public String getUptime() {
		return uptime;
	}

	public void setUptime(String uptime) {
		this.uptime = uptime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCpuutil() {
		return cpuutil;
	}

	public void setCpuutil(String cpuutil) {
		this.cpuutil = cpuutil;
	}

	public String getMemoryutil() {
		return memoryutil;
	}

	public void setMemoryutil(String memoryutil) {
		this.memoryutil = memoryutil;
	}

	public String getCellid() {
		return cellid;
	}

	public void setCellid(String cellid) {
		this.cellid = cellid;
	}

	public String getMhversion() {
		return mhversion;
	}

	public void setMhversion(String mhversion) {
		this.mhversion = mhversion;
	}

	public String getDhversion() {
		return dhversion;
	}

	public void setDhversion(String dhversion) {
		this.dhversion = dhversion;
	}

	public String getModulename() {
		return modulename;
	}

	public void setModulename(String modulename) {
		this.modulename = modulename;
	}

	public String getNwband() {
		return nwband;
	}

	public void setNwband(String nwband) {
		this.nwband = nwband;
	}

	public String getIccid() {
		return iccid;
	}

	public void setIccid(String iccid) {
		this.iccid = iccid;
	}*/
	
	public String getDi1() {
		return di1;
	}

	public void setDi1(String di1) {
		this.di1 = di1;
	}

	public String getDi2() {
		return di2;
	}

	public void setDi2(String di2) {
		this.di2 = di2;
	}

	public String getDi3() {
		return di3;
	}

	public void setDi3(String di3) {
		this.di3 = di3;
	}

	public HashMap<String, Boolean> getColumsStatus() {
		HashMap<String, Boolean> statusmap = new HashMap<String, Boolean>();
		
		//,"P0","P1","P2","P3/W"
		statusmap.put("Node Label", getNodelabel().equals("yes")?true:false);
		statusmap.put("Connected IP", getCellular_Wan_IP().equals("yes")?true:false);
		statusmap.put("Loopback IP",getLoopbackip().equals("yes")?true:false);
		statusmap.put("Serial Number", getSlnumber().equals("yes")?true:false);
		statusmap.put("Location", getLocation().equals("yes")?true:false);
		statusmap.put("FW Version", getFwversion().equals("yes")?true:false);
		statusmap.put("Model Number", getModelnumber().equals("yes")?true:false);
		statusmap.put("Router Uptime", getRouteruptime().equals("yes")?true:false);
		statusmap.put("IMEI No", getImeinumber().equals("yes")?true:false);
		statusmap.put("Active SIM", getActivesim().equals("yes")?true:false);
		statusmap.put("Network", getNetwork().equals("yes")?true:false);
		statusmap.put("Signal Strength", getSignalstrength().equals("yes")?true:false);
		statusmap.put("P0", getPort1().equals("yes")?true:false);
		statusmap.put("P1", getPort2().equals("yes")?true:false);
		statusmap.put("P2", getPort3().equals("yes")?true:false);
		statusmap.put("P3", getPort4().equals("yes")?true:false);
		statusmap.put("WAN", getWAN().equals("yes")?true:false);
		statusmap.put("DI1", getDi1().equals("yes")?true:false);
		statusmap.put("DI2", getDi2().equals("yes")?true:false);
		statusmap.put("DI3", getDi3().equals("yes")?true:false);
		return statusmap;
	}
	
}
