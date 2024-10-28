package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_building")
public class BuildingBean {
	private String buildingId;// 楼房编号
	private String buildingName;// 楼名(A-1幢、A-2幢)
	private String face;// 朝向
	private double buildArea;// 建筑面积
	private int floorNum;// 层数
	private double height;// 高度
	private Date buildTime;// 建筑时间
	private String type;// 类别
	private VillageInfoBean villageInfoModel;// 小区编号（外键，与小区信息表建立联系）
	private String extent;

	@Id
	public String getBuildingId() {
		return buildingId;
	}

	public void setBuildingId(String buildingId) {
		this.buildingId = buildingId;
	}

	public String getBuildingName() {
		return buildingName;
	}

	public void setBuildingName(String buildingName) {
		this.buildingName = buildingName;
	}

	public String getFace() {
		return face;
	}

	public void setFace(String face) {
		this.face = face;
	}

	public double getBuildArea() {
		return buildArea;
	}

	public void setBuildArea(double buildArea) {
		this.buildArea = buildArea;
	}

	public int getFloorNum() {
		return floorNum;
	}

	public void setFloorNum(int floorNum) {
		this.floorNum = floorNum;
	}

	public double getHeight() {
		return height;
	}

	public void setHeight(double height) {
		this.height = height;
	}

	public Date getBuildTime() {
		return buildTime;
	}

	public void setBuildTime(Date buildTime) {
		this.buildTime = buildTime;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@ManyToOne
	@JoinColumn(name = "villageId")
	public VillageInfoBean getVillageInfoModel() {
		return villageInfoModel;
	}

	public void setVillageInfoModel(VillageInfoBean villageInfoModel) {
		this.villageInfoModel = villageInfoModel;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
