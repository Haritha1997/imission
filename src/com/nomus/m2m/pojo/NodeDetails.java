package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.Lob;
import javax.persistence.PrePersist;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.ColumnDefault;

@Entity
@Table(name = "NodeDetails", indexes = {
        @Index(columnList = "slnumber", name = "slnumber_hidx"),
})
public class NodeDetails{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private String imeinumber="-";
	@Column
	private String ipaddress="-";
	@Column
	private String slnumber="-";
	@Column
	private String nodelabel="-";
	@Column
	private String location="-";
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date uptime;
	@Column
	private String status="-";
	@Column
	private String fwversion="-";
	@Column
	private int cversion=0;
	@Column
	private String signalstrength="-";
	@Column
	private String upgradeversion="";
	@Column
	private String sendconfig="no"; 
	@Column
	private int bulkedit=0;         // bulkedit means apply some change of a configuration to two or more devices.
	@Column
	private String export="no";
	@Column
	private String reboot="no";
	@Column
	private String upgrade="no";
	@Column
	private String loopbackip="-";
	@Column
	private String routeruptime="-";
	@Column
	private String swdate="-";
	@Column
	private String activesim="-";
	@Column
	private String network="-";
	@Column
	private String cpuutil="-";
	@Column
	private String memoryutil="-";
	@Column
	private String modelnumber="-";
	@Column
	private int bulkupdate=0;  // bultupdate means bulk export 
	@Column
	private int orgupdate=0;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date createdtime;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date downtime;
	@Column
	private String connectedip;
	@Column
	private int sendconfigstatus=0;
	@Column
	private int exportstatus=0;
	@Column
	private int rebootstatus=0;
	@Column
	private int upgradestatus=0;
	@Column
	private String severity=""; 
	@Column
	@ColumnDefault("0")
	private int outagecnt;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastexport;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastconfig;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastreboot;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastupgrade;
	
	@Column
	@Lob
	private String ipsecstats="";
	@Column
	private String switch1="DOWN";
	@Column
	private String switch2="DOWN";
	@Column
	private String switch3="DOWN"; 
	@Column
	private String switch4="DOWN";
	
	@Column
	private String cellid="";
	
	@Column
	private String mhversion="";
	@Column
	private String dhversion="";
	@Column
	private String modulename=""; 
	@Column
	private String revision="";
	@Column
	private String nwband="";
	@Column
	private String iccid="";
	@Column
	private String sim1usage="";
	@Column
	private String sim2usage="";
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date rebootinittime;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date upgradeinittime;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date configinittime;
	
	@Column
	private String organization;
	@Column
	private String wanstatus;
	@Column
	private String wanip;
	@Column
	private String wanuptime;
	@Column
	private String celstatus; //cellular status
	@Column
	private String celip;     //cellular IP
	@Column
	private String celuptime; //cellular uptime
	@Column
	private String conintf;  //connected interface
	@Column
	private String di1 = "0";
	@Column
	private String di2 = "0";
	@Column
	private String di3 = "0";
	@Column(columnDefinition = "varchar(255) default ''")
	private String comment;
	@Column(columnDefinition = "varchar(25) default ''")
	private String repslnummber;
	@Column
	private String zerotierip;     //Zerotire IP
	@Column
	private String ztnwid;     //Zerotire Network ID
	@Column
	private String fallbacksts;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date upgradestarttime;
	@Column
	@Lob
	private String openvpnstatus;
	@Column
	private String loadAverage; 
	@Column
	private String TotalUsableMemoryRAM;
	@Column
	private String UsedMemory;
	@Column
	private String UnallocatedFreeMemory;
	@Column
	private String  MemoryAvailableForAllocation;
	@Column
	private String Cached;
	
	public String getOpenvpnstatus() {
		return openvpnstatus;
	}
	public void setOpenvpnstatus(String openvpnstatus) {
		this.openvpnstatus = openvpnstatus;
	}
	public NodeDetails() {}
	public NodeDetails(String imeinumber, String ipaddress, String slnumber,String nodelabel,String location,String lastupdatetime,
			String status,int cversion,String fwversion,String signalstrength
			) {
		this.imeinumber = imeinumber;
		this.ipaddress = ipaddress;
		this.slnumber = slnumber;
		this.nodelabel = nodelabel;
		this.location = location;
		this.status = status;
		this.cversion = cversion;
		this.fwversion = fwversion;
		this.signalstrength = signalstrength;
	}
	@PrePersist
	public void prePersist() {
	    if(severity == null) //We set default value in case if the value is not set yet.
	    	severity = "";
	    if(ipsecstats == null)
	    	ipsecstats = "";
	}

	public String getUpgradeversion() {
		return upgradeversion;
	}
	public void setUpgradeversion(String upgradeversion) {
		this.upgradeversion = upgradeversion;
	}
	public String getExport() {
		return export;
	}
	public void setExport(String export) {
		this.export = export;
	}
	public String getReboot() {
		return reboot;
	}
	public void setReboot(String reboot) {
		this.reboot = reboot;
	}
	public String getUpgrade() {
		return upgrade;
	}
	public void setUpgrade(String upgrade) {
		this.upgrade = upgrade;
	}
	public String getLoopbackip() {
		return loopbackip;
	}
	public void setLoopbackip(String loopbackip) {
		this.loopbackip = loopbackip;
	}
	public int getId() {
		return id;
	}

	public void setId( int id ) {
		this.id = id;
	}
	public String getImeinumber() {
		return imeinumber;
	}
	public void setImeinumber(String imeinumber) {
		this.imeinumber = imeinumber;
	}
	public String getIpaddress() {
		return ipaddress;
	}
	public void setIpaddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}
	public String getSlnumber() {
		return slnumber;
	}
	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}
	public String getNodelabel() {
		return nodelabel;
	}
	public void setNodelabel(String nodelabel) {
		this.nodelabel = nodelabel;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}

	public Date getUptime() {
		return uptime;
	}
	public void setUptime(Date uptime) {
		this.uptime = uptime;
	}
	public Date getDowntime() {
		return downtime;
	}
	public void setDowntime(Date downtime) {
		this.downtime = downtime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getFwversion() {
		return fwversion;
	}
	public void setFwversion(String fwversion) {
		this.fwversion = fwversion;
	}
	public int getCversion() {
		return cversion;
	}
	public void setCversion(int cversion) {
		this.cversion = cversion;
	}
	public String getSignalstrength() {
		return signalstrength;
	}
	public void setSignalstrength(String signalstrength) {
		this.signalstrength = signalstrength;
	}
	public String getRouteruptime() {
		return routeruptime;
	}
	public void setRouteruptime(String routeruptime) {
		this.routeruptime = routeruptime;
	}
	public String getSwdate() {
		return swdate;
	}
	public void setSwdate(String swdate) {
		this.swdate = swdate;
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
	public String getModelnumber() {
		return modelnumber;
	}
	public void setModelnumber(String modelnumber) {
		this.modelnumber = modelnumber;
	}
	public int getBulkupdate() {
		return bulkupdate;
	}
	public void setBulkupdate(int bulkupdate) {
		this.bulkupdate = bulkupdate;
	}
	public int getOrgupdate() {
		return orgupdate;
	}
	public void setOrgupdate(int orgupdate) {
		this.orgupdate = orgupdate;
	}
	public Date getCreatedtime() {
		return createdtime;
	}
	public void setCreatedtime(Date createdtime) {
		this.createdtime = createdtime;
	}
	public String getConnectedip() {
		if(connectedip == null)
			return  "";
		if(connectedip.contains(":"))
			connectedip = connectedip.substring(0,connectedip.indexOf(":"));
		return connectedip;
	}
	public void setConnectedip(String connectedip) {
		this.connectedip = connectedip;
	}
	public int getExportstatus() {
		return exportstatus;
	}
	public void setExportstatus(int exportstatus) {
		this.exportstatus = exportstatus;
	}
	public int getRebootstatus() {
		return rebootstatus;
	}
	public void setRebootstatus(int rebootstatus) {
		this.rebootstatus = rebootstatus;
	}
	public int getUpgradestatus() {
		return upgradestatus;
	}
	public void setUpgradestatus(int upgradestatus) {
		this.upgradestatus = upgradestatus;
	}
	public String getSendconfig() {
		return sendconfig;
	}
	public void setSendconfig(String sendconfig) {
		this.sendconfig = sendconfig;
	}
	public int getBulkedit() {
		return bulkedit;
	}
	public void setBulkedit(int bulkedit) {
		this.bulkedit = bulkedit;
	}
	public int getSendconfigstatus() {
		return sendconfigstatus;
	}
	public void setSendconfigstatus(int sendconfigstatus) {
		this.sendconfigstatus = sendconfigstatus;
	}
	public String getSeverity() {
		return severity;
	}
	public void setSeverity(String severity) {
		this.severity = severity;
	}
	public int getOutagecnt() {
		return outagecnt;
	}
	public void setOutagecnt(int outagecnt) {
		this.outagecnt = outagecnt;
	}
	public Date getLastbulkexport() {
		return lastexport;
	}
	public void setLastbulkexport(Date lastexport) {
		this.lastexport = lastexport;
	}
	public Date getLastconfig() {
		return lastconfig;
	}
	public void setLastconfig(Date lastconfig) {
		this.lastconfig = lastconfig;
	}
	public Date getLastreboot() {
		return lastreboot;
	}
	public void setLastreboot(Date lastreboot) {
		this.lastreboot = lastreboot;
	}
	public Date getLastupgrade() {
		return lastupgrade;
	}
	public void setLastupgrade(Date lastupgrade) {
		this.lastupgrade = lastupgrade;
	}
	public Date getLastexport() {
		return lastexport;
	}
	public void setLastexport(Date lastexport) {
		this.lastexport = lastexport;
	}
	public String getIpsecstats() {
		return ipsecstats;
	}
	public void setIpsecstats(String ipsecstats) {
		this.ipsecstats = ipsecstats;
	}
	public String getSwitch1() {
		return switch1;
	}
	public void setSwitch1(String switch1) {
		this.switch1 = switch1;
	}
	public String getSwitch2() {
		return switch2;
	}
	public void setSwitch2(String switch2) {
		this.switch2 = switch2;
	}
	public String getSwitch3() {
		return switch3;
	}
	public void setSwitch3(String switch3) {
		this.switch3 = switch3;
	}
	public String getSwitch4() {
		return switch4;
	}
	public void setSwitch4(String switch4) {
		this.switch4 = switch4;
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
	public String getRevision() {
		return revision;
	}
	public void setRevision(String revision) {
		this.revision = revision;
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
	}
	public String getSim1usage() {
		return sim1usage;
	}
	public void setSim1usage(String sim1usage) {
		this.sim1usage = sim1usage;
	}
	public String getSim2usage() {
		return sim2usage;
	}
	public void setSim2usage(String sim2usage) {
		this.sim2usage = sim2usage;
	}
	public Date getRebootinittime() {
		return rebootinittime;
	}
	public void setRebootinittime(Date rebootinittime) {
		this.rebootinittime = rebootinittime;
	}
	public Date getUpgradeinittime() {
		return upgradeinittime;
	}
	public void setUpgradeinittime(Date upgradeinittime) {
		this.upgradeinittime = upgradeinittime;
	}
	public Date getConfiginittime() {
		return configinittime;
	}
	public void setConfiginittime(Date configinittime) {
		this.configinittime = configinittime;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getWanstatus() {
		return wanstatus;
	}
	public void setWanstatus(String wanstatus) {
		this.wanstatus = wanstatus;
	}
	public String getWanip() {
		return wanip;
	}
	public void setWanip(String wanip) {
		this.wanip = wanip;
	}
	public String getWanuptime() {
		return wanuptime;
	}
	public void setWanuptime(String wanuptime) {
		this.wanuptime = wanuptime;
	}
	public String getCelstatus() {
		return celstatus;
	}
	public void setCelstatus(String celstatus) {
		this.celstatus = celstatus;
	}
	public String getCelip() {
		return celip;
	}
	public void setCelip(String celip) {
		this.celip = celip;
	}
	public String getCeluptime() {
		return celuptime;
	}
	public void setCeluptime(String celuptime) {
		this.celuptime = celuptime;
	}
	public String getConintf() {
		return conintf;
	}
	public void setConintf(String conintf) {
		this.conintf = conintf;
	}
	public String getDi1() {
		if(di1 == null)
			return "2";
		return di1;
	}
	public void setDi1(String di1) {
		this.di1 = di1;
	}
	public String getDi2() {
		if(di2 == null)
			return "2";
		return di2;
	}
	public void setDi2(String di2) {
		this.di2 = di2;
	}
	public String getDi3() {
		if(di3 == null)
			return "2";
		return di3;
	}
	public void setDi3(String di3) {
		this.di3 = di3;
	}
	public String getComment() {
		if(comment == null)
			return "";
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getRepslnummber() {
		if(repslnummber == null)
			return "";
		return repslnummber;
	}
	public void setRepslnummber(String repslnummber) {
		this.repslnummber = repslnummber;
	}
	public String getZerotierip() {
		return zerotierip;
	}
	public void setZerotierip(String zerotierip) {
		this.zerotierip = zerotierip;
	}
	public String getZtnwid() {
		return ztnwid;
	}
	public void setZtnwid(String ztnwid) {
		this.ztnwid = ztnwid;
	}
	public String getFallbacksts() {
		return fallbacksts;
	}
	public void setFallbacksts(String fallbacksts) {
		this.fallbacksts = fallbacksts;
	}
	public Date getUpgradestarttime() {
		return upgradestarttime;
	}
	public void setUpgradestarttime(Date upgradestarttime) {
		this.upgradestarttime = upgradestarttime;
	}
	public String getLoadAverage() {
		return loadAverage;
	}
	public void setLoadAverage(String loadAverage) {
		this.loadAverage = loadAverage;
	}
	public String getTotalUsableMemoryRAM() {
		return TotalUsableMemoryRAM;
	}
	public void setTotalUsableMemoryRAM(String totalUsableMemoryRAM) {
		TotalUsableMemoryRAM = totalUsableMemoryRAM;
	}
	public String getUsedMemory() {
		return UsedMemory;
	}
	public void setUsedMemory(String usedMemory) {
		UsedMemory = usedMemory;
	}
	public String getUnallocatedFreeMemory() {
		return UnallocatedFreeMemory;
	}
	public void setUnallocatedFreeMemory(String unallocatedFreeMemory) {
		UnallocatedFreeMemory = unallocatedFreeMemory;
	}
	public String getMemoryAvailableForAllocation() {
		return MemoryAvailableForAllocation;
	}
	public void setMemoryAvailableForAllocation(String memoryAvailableForAllocation) {
		MemoryAvailableForAllocation = memoryAvailableForAllocation;
	}
	public String getCached() {
		return Cached;
	}
	public void setCached(String cached) {
		Cached = cached;
	}
}
