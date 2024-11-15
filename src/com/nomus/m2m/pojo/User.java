package com.nomus.m2m.pojo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.Hibernate;

@Entity
@Table(name="users")
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private int id;
	@Column
	private String username;
	@Column
	private String password;
	@Column
	private String role;
	@ManyToOne(cascade = {CascadeType.ALL})
	@JoinColumn(name = "organization_id")
	private Organization organization;
	@Column
	private String email;
	//@Column
	//@LazyCollection(LazyCollectionOption.FALSE)
	//@OneToMany(mappedBy = "id",cascade = {CascadeType.ALL})
	@ElementCollection
	private List<String> arealist;
	//@Column
	//@LazyCollection(LazyCollectionOption.FALSE)
	//@OneToMany(mappedBy = "id",cascade = {CascadeType.ALL})
	@ElementCollection
	private List<String> slnumberlist;
	@Column
	private String status;
	@OneToOne
	private User under;
	@OneToOne
	private User createdBy;
	@OneToOne
	private User deletedBy;
	/*@Column
	private Integer nodelimit;
	@Column
	private Integer userlimit;
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date validupto;*/
	@ElementCollection
	private List<String> favouriteList;
	
	@OneToMany(mappedBy = "user",orphanRemoval = true,fetch = FetchType.LAZY,cascade = CascadeType.ALL)
	private List<UserColumns> userColumnsList;
	
	@OneToMany(mappedBy = "usr",orphanRemoval = true,fetch = FetchType.LAZY,cascade = CascadeType.ALL)
	private List<SlNumbersRange> slNumRangeList;
	@Column
	private String oldPwd1;
	@Column
	private String oldPwd2;
	@Column
	private String oldPwd3;
	@Column
	private Date lastPwdUpdate;
	@Column
	private Integer pwdAttempts;
	@Column
	private Date linkGenon;
	@Column
	private Date freezeStart;
	@Column
	private Integer freezeTime;
	@Column
	private String linkstatus;
	public String getLinkstatus() {
		return linkstatus;
	}
	public void setLinkstatus(String linkstatus) {
		this.linkstatus = linkstatus;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	public String getOldPwd1() {
		return oldPwd1;
	}
	public void setOldPwd1(String oldPwd1) {
		this.oldPwd1 = oldPwd1;
	}
	public String getOldPwd2() {
		return oldPwd2;
	}
	public void setOldPwd2(String oldPwd2) {
		this.oldPwd2 = oldPwd2;
	}
	public String getOldPwd3() {
		return oldPwd3;
	}
	public void setOldPwd3(String oldPwd3) {
		this.oldPwd3 = oldPwd3;
	}
	public Date getLastPwdUpdate() {
		return lastPwdUpdate;
	}
	public void setLastPwdUpdate(Date lastPwdUpdate) {
		this.lastPwdUpdate = lastPwdUpdate;
	}
	public Integer getPwdAttempts() {
		return pwdAttempts;
	}
	public void setPwdAttempts(Integer pwdAttempts) {
		this.pwdAttempts = pwdAttempts;
	}
	public Date getLinkGenon() {
		return linkGenon;
	}
	public void setLinkGenon(Date linkGenon) {
		this.linkGenon = linkGenon;
	}
	public Date getFreezeStart() {
		return freezeStart;
	}
	public void setFreezeStart(Date freezeStart) {
		this.freezeStart = freezeStart;
	}
	public Integer getFreezeTime() {
		return freezeTime;
	}
	public void setFreezeTime(Integer freezeTime) {
		this.freezeTime = freezeTime;
	}
	public List<String> getArealist() {
		if(arealist == null)
			return new ArrayList<String>();
		if(arealist.size() == 0)
			arealist.add("-1");
		return arealist;
	}
	public void setArealist(List<String> arealist) {
		this.arealist = arealist;
	}
	public List<String> getSlnumberlist() {
		if(slnumberlist == null)
			return new ArrayList<String>();
		if(slnumberlist.size() == 0)
			slnumberlist.add("-1");
		return slnumberlist;
	}
	public void setSlnumberlist(List<String> slnumberlist) {
		this.slnumberlist = slnumberlist;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public User getUnder() {
		return under;
	}
	public void setUnder(User under) {
		this.under = under;
	}
	public User getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(User createdBy) {
		this.createdBy = createdBy;
	}
	public User getDeletedBy() {
		return deletedBy;
	}
	public void setDeletedBy(User deletedBy) {
		this.deletedBy = deletedBy;
	}
	public String getSlnumberLIstToString()
	{
		Hibernate.initialize(slnumberlist);
		StringBuffer sb = new StringBuffer("");
		if(slnumberlist != null && slnumberlist.size() > 0)
		{
			for(String slnum : slnumberlist)
			{
				if(sb.length() > 0)
					sb.append("','");
				sb.append(slnum);
			}
		}
		else
			return "";
		return sb.toString();
	}
	public String getareaListToString()
	{
		Hibernate.initialize(arealist);
		StringBuffer sb = new StringBuffer("");
		if(arealist != null)
		{
			for(String area : arealist)
			{
				if(sb.length() > 0)
					sb.append("','");
				sb.append(area);
			}
		}
		else
			return "";
		return sb.toString();
	}
	public List<String> getFavouriteList() {
		return favouriteList;
	}
	public void setFavouriteList(List<String> favouriteList) {
		this.favouriteList = favouriteList;
	}
	public List<UserColumns> getUserColumnsList() {
		Hibernate.initialize(userColumnsList);
		return userColumnsList;
	}
	public void setUserColumnsList(List<UserColumns> userColumnsList) {
		this.userColumnsList = userColumnsList;
	}
	public List<SlNumbersRange> getSlNumRangeList() {
		Hibernate.initialize(slNumRangeList);
		return slNumRangeList;
	}
	public void setSlNumRangeList(List<SlNumbersRange> slNumRangeList) {
		this.slNumRangeList = slNumRangeList;
	}
	
	
	/*public Integer getNodelimit() {
		return nodelimit;
	}
	public void setNodelimit(Integer nodelimit) {
		this.nodelimit = nodelimit;
	}
	public Integer getUserlimit() {
		return userlimit;
	}
	public void setUserlimit(Integer userlimit) {
		this.userlimit = userlimit;
	}
	public Date getValidupto() {
		return validupto;
	}
	public void setValidupto(Date validupto) {
		this.validupto = validupto;
	}*/
}
