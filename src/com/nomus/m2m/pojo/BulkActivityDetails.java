package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "bulkactivitydetails", indexes = {
        @Index(columnList = "configtype", name = "bulkdet_ctype_hidx"),
        @Index(columnList = "configid", name = "bulkdet_cid_hidx"),
        @Index(columnList = "status", name = "bulkdet_status_hidx"),
})
public class BulkActivityDetails{
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@ManyToOne
	@JoinColumn(name="configid")
	private BulkActivity bulkActivity;
	@Column
	private String slnumber;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date configtime;
	@Column
	private String configtype;
	@Column
	private String status;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date statustime;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	/*public int getConfigid() {
		return configid;
	}*/
	public String getSlnumber() {
		return slnumber;
	}
	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}
	public String getConfigtype() {
		return configtype;
	}
	public void setConfigtype(String configtype) {
		this.configtype = configtype;
	}
	/*public void setConfigid(int configid) {
		this.configid = configid;
	}*/
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
	public Date getStatustime() {
		return statustime;
	}
	public void setStatustime(Date statustime) {
		this.statustime = statustime;
	}
	public BulkActivity getBulkActivity() {
		return bulkActivity;
	}
	public void setBulkActivity(BulkActivity bulkActivity) {
		this.bulkActivity = bulkActivity;
	}
	
}
