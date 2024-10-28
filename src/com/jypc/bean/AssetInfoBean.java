package com.jypc.bean;

/*
 * 资产信息bean
 */

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_assetInfo")
public class AssetInfoBean {
	private String assetId; // 资产编号
	private String assetName;// 资产名称
	private String buyDate;
	private String userLife;// 使用寿命
	private String assetNum;
	private String extent;
	private AssetTypeBean assetTypeModel;// 资产类型对象

	@Id
	public String getAssetId() {
		return assetId;
	}

	public void setAssetId(String assetId) {
		this.assetId = assetId;
	}

	public String getAssetName() {
		return assetName;
	}

	public void setAssetName(String assetName) {
		this.assetName = assetName;
	}

	public String getBuyDate() {
		return buyDate;
	}

	public void setBuyDate(String buyDate) {
		this.buyDate = buyDate;
	}

	public String getUserLife() {
		return userLife;
	}

	public void setUserLife(String userLife) {
		this.userLife = userLife;
	}

	public String getAssetNum() {
		return assetNum;
	}

	public void setAssetNum(String assetNum) {
		this.assetNum = assetNum;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	@ManyToOne
	@JoinColumn(name = "assetTypeId")
	public AssetTypeBean getAssetTypeModel() {
		return assetTypeModel;
	}

	public void setAssetTypeModel(AssetTypeBean assetTypeModel) {
		this.assetTypeModel = assetTypeModel;
	}

}
