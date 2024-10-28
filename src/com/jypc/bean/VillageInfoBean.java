package com.jypc.bean;

/*
 * 小区信息bean
 */

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_villageInfo")
public class VillageInfoBean {
	private String villageId;
	private String villageName;
	private CommunityInfoBean communityModel;// 社区model
	private String linkman;// 负责人
	private Date setUpTime;// 建立日期
	private String phone;
	private String mobilePhone;
	private String floorArea;// 占地面积
	private String buildingArea;// 建筑面积
	private String garageArea;// 车库面积
	private String stallNum;// 车位数
	private String greenArea;// 绿化面积
	private String location;// 位置说明
	private String introduction;// 小区说明
	private String extent;

	@Id
	public String getVillageId() {
		return villageId;
	}

	public void setVillageId(String villageId) {
		this.villageId = villageId;
	}

	public String getVillageName() {
		return villageName;
	}

	public void setVillageName(String villageName) {
		this.villageName = villageName;

	}

	@ManyToOne
	@JoinColumn(name = "communityId")
	public CommunityInfoBean getCommunityModel() {
		return communityModel;
	}

	public void setCommunityModel(CommunityInfoBean communityModel) {
		this.communityModel = communityModel;
	}

	public String getLinkman() {
		return linkman;
	}

	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}

	public Date getSetUpTime() {
		return setUpTime;
	}

	public void setSetUpTime(Date setUpTime) {
		this.setUpTime = setUpTime;
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

	public String getFloorArea() {
		return floorArea;
	}

	public void setFloorArea(String floorArea) {
		this.floorArea = floorArea;
	}

	public String getBuildingArea() {
		return buildingArea;
	}

	public void setBuildingArea(String buildingArea) {
		this.buildingArea = buildingArea;
	}

	public String getGarageArea() {
		return garageArea;
	}

	public void setGarageArea(String garageArea) {
		this.garageArea = garageArea;
	}

	public String getStallNum() {
		return stallNum;
	}

	public void setStallNum(String stallNum) {
		this.stallNum = stallNum;
	}

	public String getGreenArea() {
		return greenArea;
	}

	public void setGreenArea(String greenArea) {
		this.greenArea = greenArea;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getIntroduction() {
		return introduction;
	}

	public void setIntroduction(String introduction) {
		this.introduction = introduction;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
