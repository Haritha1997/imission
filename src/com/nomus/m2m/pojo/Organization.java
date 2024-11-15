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
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.Hibernate;

@Entity
@Table(name = "organization")
public class Organization {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private String name;
	@Column
	private String address;
	@Column
	private String status;
	@Column
	private Integer nodesLimit=0;
	@Column
	private Integer userlimit=0;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date validUpto;
	@OneToMany(cascade = CascadeType.ALL,mappedBy = "organization",fetch = FetchType.LAZY,orphanRemoval = true)
	@OrderBy("batchId")
	private List<LoadBatch> loadBatchList;
	@Column
	//@Generated(GenerationTime.INSERT) 
	//@ColumnDefault(value = "yes")
	private String refresh="yes";
	@Column
	//@ColumnDefault(value = "10")
	//@Generated(GenerationTime.INSERT) 
	private int refreshTime = 60;
	public Integer getNodesLimit() {
		return nodesLimit;
	}
	public void setNodesLimit(Integer nodesLimit) {
		this.nodesLimit = nodesLimit;
	}
	public Integer getUserlimit() {
		return userlimit;
	}
	public void setUserlimit(Integer userlimit) {
		this.userlimit = userlimit;
	}
	public Date getValidUpto() {
		return validUpto;
	}
	public void setValidUpto(Date validUpto) {
		this.validUpto = validUpto;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getId() {
		return id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public List<LoadBatch> getLoadBatchList() {
		Hibernate.initialize(loadBatchList);
		return loadBatchList;
	}
	public void setLoadBatchList(List<LoadBatch> loadBatchList) {
		this.loadBatchList = loadBatchList;
	}
	public String getRefresh() {
		return refresh;
	}
	public void setRefresh(String refresh) {
		this.refresh = refresh;
	}
	public int getRefreshTime() {
		return refreshTime;
	}
	public void setRefreshTime(int refreshTime) {
		this.refreshTime = refreshTime;
	}
	
}
