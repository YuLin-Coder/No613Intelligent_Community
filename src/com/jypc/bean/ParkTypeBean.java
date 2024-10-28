package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/*
 * 车位类型信息
 */
@Entity
@Table(name = "tb_parktype")
public class ParkTypeBean {
	private String ptId;// 车位类型编号
	private String name;// 车位名称
	private String managercost;// 能耗费
	private String basecost;// 低价费
	private String year;// 以年为单位
	private String extent;// 扩展字段

	@Id
	public String getPtId() {
		return ptId;
	}

	public String getName() {
		return name;
	}

	public String getManagercost() {
		return managercost;
	}

	public String getBasecost() {
		return basecost;
	}

	public String getYear() {
		return year;
	}

	public String getExtent() {
		return extent;
	}

	public void setPtId(String ptId) {
		this.ptId = ptId;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setManagercost(String managercost) {
		this.managercost = managercost;
	}

	public void setBasecost(String basecost) {
		this.basecost = basecost;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
