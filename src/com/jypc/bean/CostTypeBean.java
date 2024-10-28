package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 费用类型类
 * 
 * @author guoBo
 * 
 */
@Entity
@Table(name = "tb_costtype")
public class CostTypeBean {
	private String ctId;// 费用类型编号
	private String ctName;// 费用类型名称
	private String extent;// 扩展字段

	@Id
	public String getCtId() {
		return ctId;
	}

	public void setCtId(String ctId) {
		this.ctId = ctId;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	public String getCtName() {
		return ctName;
	}

	public void setCtName(String ctName) {
		this.ctName = ctName;
	}

}
