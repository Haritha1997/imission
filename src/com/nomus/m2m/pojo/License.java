package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="license")
public class License {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column
	private String orgName;
	
	@Column
	private String location;
	
	@Column
	private String macAddress;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date licGenDate;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date validUpTo;
	
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date currentDate;
	
	@Column
	private String email;
	
	@Column(name = "lickey")
	private String key;
	
	@Column
	private String status;
	@Column
	private Integer nodeLimit=0;
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getMacAddress() {
		return macAddress;
	}

	public void setMacAddress(String macAddress) {
		this.macAddress = macAddress;
	}

	public Date getLicGenDate() {
		return licGenDate;
	}

	public void setLicGenDate(Date licGenDate) {
		this.licGenDate = licGenDate;
	}

	public Date getValidUpTo() {
		return validUpTo;
	}

	public void setValidUpTo(Date validUpTo) {
		this.validUpTo = validUpTo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCurrentDate() {
		return currentDate;
	}

	public void setCurrentDate(Date currentDate) {
		this.currentDate = currentDate;
	}
	public Integer getNodeLimit() {
		return nodeLimit;
	}

	public void setNodeLimit(Integer nodeLimit) {
		this.nodeLimit = nodeLimit;
	}
}
