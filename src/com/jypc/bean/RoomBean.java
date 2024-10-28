package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_room")
public class RoomBean {
	private String roomId;// 房间编号
	private String roomName;// 房间名称
	private BuildingBean buildingModel;// 楼房编号（外键，与楼房信息表建立联系）
	private String unitNum;// 单元号（1单元，2单元...）
	private String eApartment;// 户型
	private double buildArea;// 建筑面积
	private double usingArea;// 使用面积
	private String face;// 朝向
	private String extent;
	private String housetype;// 户型
	private String lease;

	@Id
	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	public String getRoomName() {
		return roomName;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	@ManyToOne
	@JoinColumn(name = "buildingId")
	public BuildingBean getBuildingModel() {
		return buildingModel;
	}

	public void setBuildingModel(BuildingBean buildingModel) {
		this.buildingModel = buildingModel;
	}

	public String getUnitNum() {
		return unitNum;
	}

	public void setUnitNum(String unitNum) {
		this.unitNum = unitNum;
	}

	public String geteApartment() {
		return eApartment;
	}

	public void seteApartment(String eApartment) {
		this.eApartment = eApartment;
	}

	public double getBuildArea() {
		return buildArea;
	}

	public void setBuildArea(double buildArea) {
		this.buildArea = buildArea;
	}

	public double getUsingArea() {
		return usingArea;
	}

	public void setUsingArea(double usingArea) {
		this.usingArea = usingArea;
	}

	public String getFace() {
		return face;
	}

	public void setFace(String face) {
		this.face = face;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	public String getLease() {
		return lease;
	}

	public void setLease(String lease) {
		this.lease = lease;
	}

	public String getHousetype() {
		return housetype;
	}

	public void setHousetype(String housetype) {
		this.housetype = housetype;
	}
}
