package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/*
 * 物业信息表
 */
@Entity
@Table(name = "tb_owenr")
public class OwenrBean {
	public String owenrId;
	public String owenrName;
	public String sex;
	public String aUnit;// 所属单位
	public String idCard;
	public String phone;
	public String mobilePhone;
	public String email;
	public Date buyDate;
	private String extent;

	@Id
	public String getOwenrId() {
		return owenrId;
	}

	public void setOwenrId(String owenrId) {
		this.owenrId = owenrId;
	}

	public String getOwenrName() {
		return owenrName;
	}

	public void setOwenrName(String owenrName) {
		this.owenrName = owenrName;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getaUnit() {
		return aUnit;
	}

	public void setaUnit(String aUnit) {
		this.aUnit = aUnit;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
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

	public Date getBuyDate() {
		return buyDate;
	}

	public void setBuyDate(Date buyDate) {
		this.buyDate = buyDate;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
