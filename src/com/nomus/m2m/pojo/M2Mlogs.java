package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.CascadeType;
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

import org.hibernate.Hibernate;

@Entity
@Table(name = "m2mlogs", indexes = {
        @Index(columnList = "slnumber", name = "m2msnlog_hidx"),
        @Index(columnList = "organization", name = "m2msnlog_orgidx"),
})
public class M2Mlogs {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private int nodeid;
	@Column
	private String slnumber;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date updatetime;
	@Column
	private String loginfo;
	@Column
	private String severity;
	@Column
	private String organization;
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "generatedBy")
	private User generatedBy;
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "generatedTo")
	private User generatedTo;
	@Column
	private String location;
	
	public int getId() {
		return id;
	}
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
	public Date getUpdatetime() {
		return updatetime;
	}
	public void setUpdatetime(Date updatetime) {
		this.updatetime = updatetime;
	}
	public String getLoginfo() {
		return loginfo;
	}
	public void setLoginfo(String loginfo) {
		this.loginfo = loginfo;
	}
	public String getSeverity() {
		return severity;
	}
	public void setSeverity(String severity) {
		this.severity = severity;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public User getGeneratedBy() {
		Hibernate.initialize(generatedBy);
		return generatedBy;
	}
	public void setGeneratedBy(User generatedBy) {
		this.generatedBy = generatedBy;
	}
	public User getGeneratedTo() {
		Hibernate.initialize(generatedTo);
		return generatedTo;
	}
	public void setGeneratedTo(User generatedTo) {
		this.generatedTo = generatedTo;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
}
