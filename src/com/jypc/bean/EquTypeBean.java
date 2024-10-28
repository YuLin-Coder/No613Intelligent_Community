package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tb_equType")
public class EquTypeBean {

	private String equTypeId;// 设备类别编号
	private String equType;// 设备类别名称
	private String extent;

	@Id
	public String getEquTypeId() {
		return equTypeId;
	}

	public void setEquTypeId(String equTypeId) {
		this.equTypeId = equTypeId;
	}

	public String getEquType() {
		return equType;
	}

	public void setEquType(String equType) {
		this.equType = equType;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
