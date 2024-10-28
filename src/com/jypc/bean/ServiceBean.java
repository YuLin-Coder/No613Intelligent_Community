package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_service")
public class ServiceBean {
	private String serviceId;
	private String content;
	private TenementBean tenementModel;
	private Date contentTime; // 发布时间
	private String extent;
	@Id
	public String getServiceId() {
		return serviceId;
	}
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	@ManyToOne
	@JoinColumn(name = "tenementId")
	public TenementBean getTenementModel() {
		return tenementModel;
	}
	public void setTenementModel(TenementBean tenementModel) {
		this.tenementModel = tenementModel;
	}
	public Date getContentTime() {
		return contentTime;
	}
	public void setContentTime(Date contentTime) {
		this.contentTime = contentTime;
	}
	public String getExtent() {
		return extent;
	}
	public void setExtent(String extent) {
		this.extent = extent;
	}


}
