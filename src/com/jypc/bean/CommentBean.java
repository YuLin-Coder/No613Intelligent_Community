package com.jypc.bean;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_comment")
public class CommentBean {
	private String commentId, contents, extent;
	private Date createTime;
	private UserBean userModel;
	private NoticeBean noticeModel;

	public CommentBean() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CommentBean(String commentId, String contents, String extent,
			Date createTime, UserBean userModel, NoticeBean noticeModel) {
		super();
		this.commentId = commentId;
		this.contents = contents;
		this.extent = extent;
		this.createTime = createTime;
		this.userModel = userModel;
		this.noticeModel = noticeModel;
	}

	@Id
	public String getCommentId() {
		return commentId;
	}

	public void setCommentId(String commentId) {
		this.commentId = commentId;
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

	@ManyToOne
	@JoinColumn(name = "userId")
	public UserBean getUserModel() {
		return userModel;
	}

	public void setUserModel(UserBean userModel) {
		this.userModel = userModel;
	}

	@ManyToOne
	@JoinColumn(name = "noticeId")
	public NoticeBean getNoticeModel() {
		return noticeModel;
	}

	public void setNoticeModel(NoticeBean noticeModel) {
		this.noticeModel = noticeModel;
	}

}
