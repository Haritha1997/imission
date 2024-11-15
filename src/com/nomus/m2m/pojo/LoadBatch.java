package com.nomus.m2m.pojo;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.Hibernate;

@Entity
@Table(name="loadbatch")
public class LoadBatch {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column(name="batchid")
	private int batchId;
	@ManyToOne
	private Organization organization;
	@Column
	private String batchName;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date validUpTo;
	@OneToMany(mappedBy = "batch", cascade = CascadeType.ALL ,orphanRemoval = true,fetch = FetchType.LAZY)
	private List<OrganizationData> orgdatalist;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastExpiredPrompt;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getBatchId() {
		return batchId;
	}
	public Date getLastExpiredPrompt() {
		return lastExpiredPrompt;
	}
	public void setLastExpiredPrompt(Date lastExpiredPrompt) {
		this.lastExpiredPrompt = lastExpiredPrompt;
	}
	public void setBatchId(int batchId) {
		this.batchId = batchId;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	public String getBatchName() {
		return batchName;
	}
	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}
	public Date getValidUpTo() {
		return validUpTo;
	}
	public void setValidUpTo(Date validUpTo) {
		this.validUpTo = validUpTo;
	}
	public List<OrganizationData> getOrgdatalist() {
		Hibernate.initialize(orgdatalist);
		return orgdatalist;
	}
	public void setOrgdatalist(List<OrganizationData> orgdatalist) {
		this.orgdatalist = orgdatalist;
	}
}
