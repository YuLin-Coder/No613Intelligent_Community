package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_Duty")
public class DutyBean {
	private String dutyId;// 主键编号
	private String dutyName;// 值班人员姓名
	private WorkerBean workerModel;// 工作编号(外键)
	private Date startTime;// 值班开始时间
	private Date endTime;// 值班结束时间
	private String place;// 值班地点
	private String sign;// 是否签到
	private String extent;

	@Id
	public String getDutyId() {
		return dutyId;
	}

	public void setDutyId(String dutyId) {
		this.dutyId = dutyId;
	}

	public String getDutyName() {
		return dutyName;
	}

	public void setDutyName(String dutyName) {
		this.dutyName = dutyName;
	}

	@ManyToOne
	@JoinColumn(name = "workerId")
	public WorkerBean getWorkerModel() {
		return workerModel;
	}

	public void setWorkerModel(WorkerBean workerModel) {
		this.workerModel = workerModel;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
