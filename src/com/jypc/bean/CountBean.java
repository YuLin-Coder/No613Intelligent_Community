package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_count")
public class CountBean {
	private String countId;
	private Date time;
	private OwenrBean owenrModel;
	private PaymentBean paymentModel;
	private double arrear;
	private String extent;

	@Id
	public String getCountId() {
		return countId;
	}

	public void setCountId(String countId) {
		this.countId = countId;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	@ManyToOne
	@JoinColumn(name = "owenId")
	public OwenrBean getOwenrModel() {
		return owenrModel;
	}

	public void setOwenrModel(OwenrBean owenrModel) {
		this.owenrModel = owenrModel;
	}

	@ManyToOne
	@JoinColumn(name = "paymentId")
	public PaymentBean getPaymentModel() {
		return paymentModel;
	}

	public void setPaymentModel(PaymentBean paymentModel) {
		this.paymentModel = paymentModel;
	}

	public double getArrear() {
		return arrear;
	}

	public void setArrear(double arrear) {
		this.arrear = arrear;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
