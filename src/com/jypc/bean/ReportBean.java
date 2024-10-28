package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_report")
public class ReportBean {
	private String reportId;
	private String equipment; // 设备名称
	private TenementBean tenementModel;
	private String reportName; // 报修人
	private Date reportTime; // 维修时间
	private String isReport; // 是否维修
	private String extent;

	@Id
	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public String getEquipment() {
		return equipment;
	}

	public void setEquipment(String equipment) {
		this.equipment = equipment;
	}

	@ManyToOne
	@JoinColumn(name = "tenementId")
	public TenementBean getTenementModel() {
		return tenementModel;
	}

	public void setTenementModel(TenementBean tenementModel) {
		this.tenementModel = tenementModel;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}

	public Date getReportTime() {
		return reportTime;
	}

	public void setReportTime(Date reportTime) {
		this.reportTime = reportTime;
	}

	public String getIsReport() {
		return isReport;
	}

	public void setIsReport(String isReport) {
		this.isReport = isReport;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
