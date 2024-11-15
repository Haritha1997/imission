package com.nomus.m2m.pojo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="userarea")
public class UserArea {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	//@ManyToOne(fetch = FetchType.LAZY,cascade = CascadeType.ALL)
   // @JoinColumn(name = "user_id")
	//private User user;
	private String area;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	/*public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}*/
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
}
