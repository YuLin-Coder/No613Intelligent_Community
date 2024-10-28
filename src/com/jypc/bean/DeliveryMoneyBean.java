package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 快递收入类
 * 
 * @author 郭波
 * 
 */
@Entity
@Table(name = "tb_delivery_money")
public class DeliveryMoneyBean {
	private String mid;// 快递编号
	private DeliveryFirmBean deliveryfirmModel;// 快递公司编号
	private String years;// 年份
	private String money;// 快递费用
	private String drawee;// 付款人
	private String payee;// 收款人
	private Date tradedate;// 交易时间
	private String extent;// 扩展字段

	@Id
	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	@ManyToOne
	@JoinColumn(name = "deliveryfirmId")
	public DeliveryFirmBean getDeliveryfirmModel() {
		return deliveryfirmModel;
	}

	public void setDeliveryfirmModel(DeliveryFirmBean deliveryfirmModel) {
		this.deliveryfirmModel = deliveryfirmModel;
	}

	public String getYears() {
		return years;
	}

	public void setYears(String years) {
		this.years = years;
	}

	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public String getDrawee() {
		return drawee;
	}

	public void setDrawee(String drawee) {
		this.drawee = drawee;
	}

	public String getPayee() {
		return payee;
	}

	public void setPayee(String payee) {
		this.payee = payee;
	}

	public Date getTradedate() {
		return tradedate;
	}

	public void setTradedate(Date tradedate) {
		this.tradedate = tradedate;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
