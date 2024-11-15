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
@Table(name="keyrequest")
public class KeyRequest {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private int id;
	@Column
	private String orgname;
	@Column
	private String location;
	@Column
	private String macaddress;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date expireDate;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date keyReqDate;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getMacaddress() {
		return macaddress;
	}
	public void setMacaddress(String macaddress) {
		this.macaddress = macaddress;
	}
	public Date getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(Date expireDate) {
		this.expireDate = expireDate;
	}
	public Date getKeyReqDate() {
		return keyReqDate;
	}
	public void setKeyReqDate(Date keyReqDate) {
		this.keyReqDate = keyReqDate;
	}
	
}
