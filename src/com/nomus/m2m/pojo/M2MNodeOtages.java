package com.nomus.m2m.pojo;

import java.util.Date;

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
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "m2mnodeoutages", indexes = {
        @Index(columnList = "slnumber", name = "m2msnout_hidx"),
        @Index(columnList = "organization", name = "m2msnout_orgidx"),
})
public class M2MNodeOtages {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private int nodeid;
	@Column
	private String slnumber;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date downtime;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date uptime;
	@Column()
	private String severity="";
	@Column
	private String organization;
	@ManyToOne(fetch = FetchType.EAGER,cascade = CascadeType.ALL)
	@JoinColumn(name = "user_id")
	private User User;
	@Column
	private String location;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date updateTime;
	@Column
	private String alarmInfo;
	
	public void setId(int id) {
		this.id = id;
	}
	public int getNodeid() {
		return nodeid;
	}
	public void setNodeid(int nodeid) {
		this.nodeid = nodeid;
	}
	public String getSlnumber() {
		return slnumber;
	}
	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}
	public Date getDowntime() {
		return downtime;
	}
	public void setDowntime(Date downtime) {
		this.downtime = downtime;
	}
	public Date getUptime() {
		return uptime;
	}
	public void setUptime(Date uptime) {
		this.uptime = uptime;
	}
	public String getSeverity() {
		return severity;
	}
	public void setSeverity(String severity) {
		this.severity = severity;
	}
	public int getId() {
		return id;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public User getUser() {
		return User;
	}
	public void setUser(User user) {
		User = user;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getAlarmInfo() {
		return alarmInfo;
	}
	public void setAlarmInfo(String alarmInfo) {
		this.alarmInfo = alarmInfo;
	}
}
