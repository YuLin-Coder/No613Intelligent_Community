package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tb_noticetype")
public class NoticeTypeBean {

	private String typeId, typeName, extent;

	public NoticeTypeBean() {
		super();
		// TODO Auto-generated constructor stub
	}

	public NoticeTypeBean(String typeId, String typeName, String extent) {
		super();
		this.typeId = typeId;
		this.typeName = typeName;
		this.extent = extent;
	}

	@Id
	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public String getExtent() {
		return extent;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}

}
