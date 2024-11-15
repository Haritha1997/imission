package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="orgdata")
public class OrganizationData {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private String organization;
	@ManyToOne
	private LoadBatch batch;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date validUpto;
	@Column
	private String slnumber;
	@Column(columnDefinition = "varchar(255) default ''")
	private String status;
	public Date getValidUpto() {
		return validUpto;
	}
	public void setValidUpto(Date validUpto) {
		this.validUpto = validUpto;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getSlnumber() {
		return slnumber;
	}
	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}
	public LoadBatch getBatch() {
		return batch;
	}
	public void setBatch(LoadBatch batch) {
		this.batch = batch;
	}
	public String getStatus() {
		if(status == null)
			status = "";
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
