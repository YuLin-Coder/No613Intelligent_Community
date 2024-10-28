package com.jypc.bean;

/**
 * 车位缴费信息类
 */
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_parkkingmoney")
public class ParkkingMoneyBean {
	private String parkkingMoneyId;// 收费编号
	private ParkkingBean parkkingModel;// 车位编号
	private String year;// 缴费年份
	private double parkkingMoney;// 车位收费
	private Date parkkingMoneyDate;// 收费日期
	private String extent;// 扩展字段

	@Id
	public String getParkkingMoneyId() {
		return parkkingMoneyId;
	}

	public void setParkkingMoneyId(String parkkingMoneyId) {
		this.parkkingMoneyId = parkkingMoneyId;
	}

	@ManyToOne
	@JoinColumn(name = "parkkingId")
	public ParkkingBean getParkkingModel() {
		return parkkingModel;
	}

	public void setParkkingModel(ParkkingBean parkkingModel) {
		this.parkkingModel = parkkingModel;
	}

	public String getYear() {
		return year;
	}

	public double getParkkingMoney() {
		return parkkingMoney;
	}

	public String getExtent() {
		return extent;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public void setParkkingMoney(double parkkingMoney) {
		this.parkkingMoney = parkkingMoney;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	public Date getParkkingMoneyDate() {
		return parkkingMoneyDate;
	}

	public void setParkkingMoneyDate(Date parkkingMoneyDate) {
		this.parkkingMoneyDate = parkkingMoneyDate;
	}

}
