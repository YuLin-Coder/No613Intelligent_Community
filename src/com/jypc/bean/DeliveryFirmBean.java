package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 快递公司类
 * 
 * @author 郭波
 * 
 */
@Entity
@Table(name = "tb_deliveryfirm")
public class DeliveryFirmBean {
	private String deliveryfirmId;// 快递公司编号
	private String deliveryfirmName;// 快递公司名称
	private String head;// 负责人
	private String phone;// 联系电话
	private String address;// 快递公司地址
	private String extent;

	@Id
	public String getDeliveryfirmId() {
		return deliveryfirmId;
	}

	public void setDeliveryfirmId(String deliveryfirmId) {
		this.deliveryfirmId = deliveryfirmId;
	}

	public String getDeliveryfirmName() {
		return deliveryfirmName;
	}

	public void setDeliveryfirmName(String deliveryfirmName) {
		this.deliveryfirmName = deliveryfirmName;
	}

	public String getHead() {
		return head;
	}

	public void setHead(String head) {
		this.head = head;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
