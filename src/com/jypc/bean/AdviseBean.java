package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_advise")
public class AdviseBean {
	private String adviseId, contents, extent;
	/*
	 * Timestamp
	 */
	private Date createTime, answerTime;// 数据库没有answertime字段
	// private int sateFlag;
	private AdviseTypeBean adviceTypeModel;

	private UserBean userModel;

	public AdviseBean() {
		super();
	}

	public AdviseBean(String adviseId, String contents, String extent,
			Date createTime, Date answerTime, int sateFlag,
			AdviseTypeBean adviceTypeModel, UserBean userModel) {
		super();
		this.adviseId = adviseId;
		this.contents = contents;
		this.extent = extent;
		this.createTime = createTime;
		this.answerTime = answerTime;
		// this.sateFlag = sateFlag;
		this.adviceTypeModel = adviceTypeModel;
		this.userModel = userModel;
	}

	@Id
	public String getAdviseId() {
		return adviseId;
	}

	public void setAdviseId(String adviseId) {
		this.adviseId = adviseId;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getAnswerTime() {
		return answerTime;
	}

	public void setAnswerTime(Date answerTime) {
		this.answerTime = answerTime;
	}

	@ManyToOne
	@JoinColumn(name = "adviseTypeId")
	public AdviseTypeBean getAdviceTypeModel() {
		return adviceTypeModel;
	}

	public void setAdviceTypeModel(AdviseTypeBean adviceTypeModel) {
		this.adviceTypeModel = adviceTypeModel;
	}

	@ManyToOne
	@JoinColumn(name = "userId")
	public UserBean getUserModel() {
		return userModel;
	}

	public void setUserModel(UserBean userModel) {
		this.userModel = userModel;
	}

}
