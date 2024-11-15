package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "m2mschreports")
public class M2MSchReports {

	@Id
    @GeneratedValue(strategy  = GenerationType.IDENTITY)
	private int id;
	@Column
	private String name;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date createdon;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date lasttriggered;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date nextfiretime;
	@Column
	private String format;
	@Column
	private String input; 
	@Column
	private String value; 
	@Column
	private String nodetype;
	@Column
	private String timeperiod;
	@Column
	private String fromdate;
	@Column
	private String todate;
	@Column
	private String orderby; 
	@Column
	private String ordertype; 
	@Column
	private String email;
	@JoinColumn
	@ManyToOne(fetch = FetchType.EAGER, cascade=CascadeType.ALL)
	private User user;
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
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getCreatedon() {
		return createdon;
	}
	public void setCreatedon(Date createdon) {
		this.createdon = createdon;
	}
	public Date getLasttriggered() {
		return lasttriggered;
	}
	public void setLasttriggered(Date lasttriggered) {
		this.lasttriggered = lasttriggered;
	}
	public Date getNextfiretime() {
		return nextfiretime;
	}
	public void setNextfiretime(Date nextfiretime) {
		this.nextfiretime = nextfiretime;
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getInput() {
		return input;
	}
	public void setInput(String input) {
		this.input = input;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getNodetype() {
		return nodetype;
	}
	public void setNodetype(String nodetype) {
		this.nodetype = nodetype;
	}
	public String getTimeperiod() {
		return timeperiod;
	}
	public void setTimeperiod(String timeperiod) {
		this.timeperiod = timeperiod;
	}
	public String getFromdate() {
		return fromdate;
	}
	public void setFromdate(String fromdate) {
		this.fromdate = fromdate;
	}
	public String getTodate() {
		return todate;
	}
	public void setTodate(String todate) {
		this.todate = todate;
	}
	public String getOrderby() {
		return orderby;
	}
	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
	public String getOrdertype() {
		return ordertype;
	}
	public void setOrdertype(String ordertype) {
		this.ordertype = ordertype;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
}
