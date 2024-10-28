package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_notice")
public class NoticeBean {
	private String noticeId, contents, extent, titles;
	private Date createTime;
	private int isSide;
	private int isTop;
	private int isRecommend;

	private NoticeTypeBean noticeTypeModel;

	@Id
	public String getNoticeId() {
		return noticeId;
	}

	public void setNoticeId(String noticeId) {
		this.noticeId = noticeId;
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

	public String getTitles() {
		return titles;
	}

	public void setTitles(String titles) {
		this.titles = titles;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@ManyToOne
	@JoinColumn(name = "typeId")
	public NoticeTypeBean getNoticeTypeModel() {
		return noticeTypeModel;
	}

	public void setNoticeTypeModel(NoticeTypeBean noticeTypeModel) {
		this.noticeTypeModel = noticeTypeModel;
	}

	public int getIsSide() {
		return isSide;
	}

	public void setIsSide(int isSide) {
		this.isSide = isSide;
	}

	public int getIsTop() {
		return isTop;
	}

	public void setIsTop(int isTop) {
		this.isTop = isTop;
	}

	public int getIsRecommend() {
		return isRecommend;
	}

	public void setIsRecommend(int isRecommend) {
		this.isRecommend = isRecommend;
	}

	public NoticeBean(String noticeId, String contents, String extent,
			String titles, Date createTime, int stateFlag, int isSide,
			int isTop, int isRecommend, String imagePath,
			NoticeTypeBean noticeTypeModel) {
		super();
		this.noticeId = noticeId;
		this.contents = contents;
		this.extent = extent;
		this.titles = titles;
		this.createTime = createTime;
		this.isSide = isSide;
		this.isTop = isTop;
		this.isRecommend = isRecommend;

		this.noticeTypeModel = noticeTypeModel;
	}

	public NoticeBean(String noticeId, String contents, String extent,
			String titles, Date createTime, int stateFlag, int isSide,
			int isTop, String imagePath, NoticeTypeBean noticeTypeModel) {
		super();
		this.noticeId = noticeId;
		this.contents = contents;
		this.extent = extent;
		this.titles = titles;
		this.createTime = createTime;

		this.isSide = isSide;
		this.isTop = isTop;
		this.noticeTypeModel = noticeTypeModel;
	}

	public NoticeBean() {
		super();
		// TODO Auto-generated constructor stub
	}

}
