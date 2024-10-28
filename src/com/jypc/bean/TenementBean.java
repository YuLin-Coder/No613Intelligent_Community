package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 居民信息
 * 
 * @author
 * 
 */
@Entity
@Table(name = "tb_tenement")
public class TenementBean {
	private String tenementId;
	private String tenementName;
	private String sex;
	private String idCard;
	private String aunit;// 所属单位
	private String phone;
	private String mobilePhone;
	private String email;
	private String areStay;
	private RoomBean roomModel;
	private String extent;

	@Id
	public String getTenementId() {
		return tenementId;
	}

	public void setTenementId(String tenementId) {
		this.tenementId = tenementId;
	}

	public String getTenementName() {
		return tenementName;
	}

	public void setTenementName(String tenementName) {
		this.tenementName = tenementName;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAreStay() {
		return areStay;
	}

	public void setAreStay(String areStay) {
		this.areStay = areStay;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	@ManyToOne
	@JoinColumn(name = "roomId")
	public RoomBean getRoomModel() {
		return roomModel;
	}

	public void setRoomModel(RoomBean roomModel) {
		this.roomModel = roomModel;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getAunit() {
		return aunit;
	}

	public void setAunit(String aunit) {
		this.aunit = aunit;
	}

}
