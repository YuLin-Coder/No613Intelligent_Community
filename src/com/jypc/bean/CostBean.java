package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 物业费用信息类
 * 
 * @author 郭波
 * 
 */
@Entity
@Table(name = "tb_cost")
public class CostBean {
	private String costId;// 费用编号
	private String costName;// 费用名称
	private double unitPrice;// 费用单价
	private String remarks;// 费用说明
	private CostTypeBean costTypeModel;// 外键-费用类型
	private String munit;// 计价单位
	private String extent;// 扩展字段

	@Id
	public String getCostId() {
		return costId;
	}

	public void setCostId(String costId) {
		this.costId = costId;
	}

	public String getCostName() {
		return costName;
	}

	public void setCostName(String costName) {
		this.costName = costName;
	}

	public double getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	@ManyToOne
	@JoinColumn(name = "ctId")
	public CostTypeBean getCostTypeModel() {
		return costTypeModel;
	}

	public void setCostTypeModel(CostTypeBean costTypeModel) {
		this.costTypeModel = costTypeModel;
	}

	public String getMunit() {
		return munit;
	}

	public void setMunit(String munit) {
		this.munit = munit;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
