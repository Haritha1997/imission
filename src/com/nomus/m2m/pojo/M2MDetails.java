package com.nomus.m2m.pojo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.ColumnDefault;

@Entity
@Table(name = "m2mdetails")
public class M2MDetails {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	@ColumnDefault(value = "0")
	private int port;
	@Column
	@ColumnDefault(value = "'E:/httpserver'")
	private String httpserverpath;
	@Column
	@ColumnDefault(value = "'E:/tlsconfigs'")
	private String tlsconfigspath;
	@Column
	@ColumnDefault(value = "'E:/firmwares'")
	private String firmwaredir;


	@Column(columnDefinition = "varchar(255) default 'WiZ_NG.zip'") private
	String targetfilename;



	@Column(columnDefinition = "varchar(255) default 'version.txt'") 
	private String versionfile;

	@Column(columnDefinition = "varchar(50) default 'no'")
	private String enabledebug;
	@Column(columnDefinition = "integer default 10")
	private int readtimeout;
	@Column(columnDefinition = "integer default 2")
	private int daysforinactive;
	@Column(columnDefinition = "varchar(105)")
	private String username;
	@Column(columnDefinition = "varchar(105)")
	private String password;
	@Column(columnDefinition = "integer default 587")
	private int smtptport;
	@Column(columnDefinition = "varchar(105) default ''")
	private String smtpserver;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public String getHttpserverpath() {
		return httpserverpath.replace("\\", "/");
	}
	public void setHttpserverpath(String httpserverpath) {
		this.httpserverpath = httpserverpath;
	}
	public String getTlsconfigspath() {
		return tlsconfigspath.replace("\\", "/");
	}
	public void setTlsconfigspath(String tlsconfigspath) {
		this.tlsconfigspath = tlsconfigspath;
	}
	public String getFirmwaredir() {
		return firmwaredir.replace("\\", "/");
	}
	public void setFirmwaredir(String firmwaredir) {
		this.firmwaredir = firmwaredir;
	}
	public String getTargetfilename() 
	{ 
		return targetfilename; 
	} 
	public void setTargetfilename(String targetfilename) 
	{ 
		this.targetfilename = targetfilename; 
	}
	public String getVersionfile() 
	{ 
		return versionfile; 
	} 
	public void setVersionfile(String versionfile) 
	{ 
		this.versionfile = versionfile; 
	}
	public String getEnabledebug() {
		return enabledebug;
	}
	public void setEnabledebug(String enabledebug) {
		this.enabledebug = enabledebug;
	}
	public int getReadtimeout() {
		return readtimeout;
	}
	public void setReadtimeout(int readtimeout) {
		this.readtimeout = readtimeout;
	}
	public int getDaysforinactive() {
		return daysforinactive;
	}
	public void setDaysforinactive(int daysforinactive) {
		this.daysforinactive = daysforinactive;
	}
	public String getUsername() {
		return username==null?"":username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password==null?"":password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getSmtptport() {
		return smtptport;
	}
	public void setSmtptport(int smtptport) {
		this.smtptport = smtptport;
	}
	public String getSmtpserver() {
		return smtpserver==null?"":smtpserver;
	}
	public void setSmtpserver(String smtpserver) {
		this.smtpserver = smtpserver;
	}
}
