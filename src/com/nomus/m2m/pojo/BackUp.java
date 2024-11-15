package com.nomus.m2m.pojo;

import java.util.Date;

import javax.persistence.*;

@Entity
@Table(name="backup")
public class BackUp {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column
	private String BackupSts="No";
	@Column
	private int BackupForEvery;
	@Column
	private String BackupPath;
	@Column
	private String SendMail="No";
	@Column
	@Temporal(TemporalType.TIMESTAMP)
	private Date LastBackupDate;
	@Column
	private String ReceiverMail;
	@Column
	private String BackupType;
	@Column
	private String RemoteProtocol;
	@Column
	private String Username;
	@Column
	private String Password;
	@Column
	private String IPaddress;
	@Column
	private String Port;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getBackupSts() {
		return BackupSts;
	}
	public void setBackupSts(String backupSts) {
		BackupSts = backupSts;
	}
	public int getBackupForEvery() {
		return BackupForEvery;
	}
	public void setBackupForEvery(int backupForEvery) {
		BackupForEvery = backupForEvery;
	}
	public String getBackupPath() {
		return BackupPath;
	}
	public void setBackupPath(String backupPath) {
		BackupPath = backupPath;
	}
	public String getSendMail() {
		return SendMail;
	}
	public void setSendMail(String sendMail) {
		SendMail = sendMail;
	}
	public Date getLastBackupDate() {
		return LastBackupDate;
	}
	public void setLastBackupDate(Date lastBackupDate) {
		LastBackupDate = lastBackupDate;
	}
	public String getReceiverMail() {
		return ReceiverMail;
	}
	public void setReceiverMail(String receiverMail) {
		ReceiverMail = receiverMail;
	}
	public String getBackupType() {
		return BackupType;
	}
	public void setBackupType(String backupType) {
		BackupType = backupType;
	}
	public String getRemoteProtocol() {
		return RemoteProtocol;
	}
	public void setRemoteProtocol(String remoteProtocol) {
		RemoteProtocol = remoteProtocol;
	}
	public String getUsername() {
		return Username;
	}
	public void setUsername(String username) {
		Username = username;
	}
	public String getPassword() {
		return Password;
	}
	public void setPassword(String password) {
		Password = password;
	}
	public String getIPaddress() {
		return IPaddress;
	}
	public void setIPaddress(String iPaddress) {
		IPaddress = iPaddress;
	}
	public String getPort() {
		return Port;
	}
	public void setPort(String port) {
		Port = port;
	}
}
