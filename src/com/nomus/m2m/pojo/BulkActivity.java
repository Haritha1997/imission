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
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "bulkactivity", indexes = {
        @Index(columnList = "configtype", name = "bulkinfo_ctype_hidx"),
})
public class BulkActivity{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int configid;
	@Column
	private String configtype;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date configtime;
	@JoinColumn
	@ManyToOne(fetch = FetchType.EAGER, cascade=CascadeType.ALL)
	private User createdby;
	@Column
	private String status;
	@OneToMany(fetch=FetchType.LAZY, cascade = {CascadeType.ALL})
	@JoinColumn(name="configid")
	private List<BulkActivityDetails> bulkActivityDetList;
	@Column
	private String organization;
	@JoinColumn
	@ManyToOne(fetch = FetchType.EAGER, cascade=CascadeType.ALL)
	private User superior;
	
	public User getSuperior() {
		return superior;
	}
	public void setSuperior(User superior) {
		this.superior = superior;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public int getConfigid() {
		return configid;
	}
	public void setConfigid(int configid) {
		this.configid = configid;
	}
	public String getConfigtype() {
		return configtype;
	}
	public void setConfigtype(String configtype) {
		this.configtype = configtype;
	}
	public Date getConfigtime() {
		return configtime;
	}
	public void setConfigtime(Date configtime) {
		this.configtime = configtime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public User getCreatedby() {
		return createdby;
	}
	public void setCreatedby(User createdby) {
		this.createdby = createdby;
	}
	public List<BulkActivityDetails> getBulkActivityDetList() {
		return bulkActivityDetList;
	}
	public void setBulkActivityDetList(List<BulkActivityDetails> bulkActivityDetList) {
		this.bulkActivityDetList = bulkActivityDetList;
	}
	
}
