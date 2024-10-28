package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 快递信息类
 * 
 * @author 郭波
 * 
 */
@Entity
@Table(name = "tb_deliveryinfo")
public class DeliveryInfoBean {
	private String deliveryId;// 快递编号
	private DeliveryFirmBean deliveryfirmModel;// 外键-快递公司编号
	private String delivery;// 送件人
	private String deliveryPhone;// 送件人联系方式
	private String recipient;// 收件人
	private String recipientPhone;// 收件人联系方式
	private String address;// 收件人地址
	private String extent;// 是否收取

	@Id
	public String getDeliveryId() {
		return deliveryId;
	}

	public void setDeliveryId(String deliveryId) {
		this.deliveryId = deliveryId;
	}

	@ManyToOne
	@JoinColumn(name = "deliveryfirmId")
	public DeliveryFirmBean getDeliveryfirmModel() {
		return deliveryfirmModel;
	}

	public void setDeliveryfirmModel(DeliveryFirmBean deliveryfirmModel) {
		this.deliveryfirmModel = deliveryfirmModel;
	}

	public String getDelivery() {
		return delivery;
	}

	public void setDelivery(String delivery) {
		this.delivery = delivery;
	}

	public String getDeliveryPhone() {
		return deliveryPhone;
	}

	public void setDeliveryPhone(String deliveryPhone) {
		this.deliveryPhone = deliveryPhone;
	}

	public String getRecipient() {
		return recipient;
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public String getRecipientPhone() {
		return recipientPhone;
	}

	public void setRecipientPhone(String recipientPhone) {
		this.recipientPhone = recipientPhone;
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
