package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_repair")
public class RepairBean {
	private String repairId;
	private String equipment; // 设备名称
	private EquTypeBean equTypeModel;
	private TenementBean tenementModel;
	private String injureReason;// 损坏原因
	private String repairUnit; // 维修单位
	private Date repairTime; // 维修时间
	private String prid; // 是否付款

	private double payment; // 付款数
	private String isRepair; // 是否受理
	private String extent;
	

	@Id
	public String getRepairId() {
		return repairId;
	}

	public void setRepairId(String repairId) {
		this.repairId = repairId;
	}

	public String getEquipment() {
		return equipment;
	}

	public void setEquipment(String equipment) {
		this.equipment = equipment;
	}

	@ManyToOne
	@JoinColumn(name = "EquTypeId")
	public EquTypeBean getEquTypeModel() {
		return equTypeModel;
	}

	public void setEquTypeModel(EquTypeBean equTypeModel) {
		this.equTypeModel = equTypeModel;
	}

	@ManyToOne
	@JoinColumn(name = "TenementId")
	public TenementBean getTenementModel() {
		return tenementModel;
	}

	public void setTenementModel(TenementBean tenementModel) {
		this.tenementModel = tenementModel;
	}

	public String getInjureReason() {
		return injureReason;
	}

	public void setInjureReason(String injureReason) {
		this.injureReason = injureReason;
	}

	public String getRepairUnit() {
		return repairUnit;
	}

	public void setRepairUnit(String repairUnit) {
		this.repairUnit = repairUnit;
	}

	public Date getRepairTime() {
		return repairTime;
	}

	public void setRepairTime(Date repairTime) {
		this.repairTime = repairTime;
	}

	public String getPrid() {
		return prid;
	}

	public void setPrid(String prid) {
		this.prid = prid;
	}

	public double getPayment() {
		return payment;
	}

	public void setPayment(double payment) {
		this.payment = payment;
	}

	public String getIsRepair() {
		return isRepair;
	}

	public void setIsRepair(String isRepair) {
		this.isRepair = isRepair;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
