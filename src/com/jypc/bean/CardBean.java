package com.jypc.bean;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "tb_card")
public class CardBean {
	private String cardId;// 卡号
	private RoomBean roomModel;// 房间
	private int stateFlag;//
	private String extent;

	@Id
	public String getCardId() {
		return cardId;
	}

	@ManyToOne
	@JoinColumn(name = "roomId")
	public RoomBean getRoomModel() {
		return roomModel;
	}

	public int getStateFlag() {
		return stateFlag;
	}

	public String getExtent() {
		return extent;
	}

	public void setCardId(String cardId) {
		this.cardId = cardId;
	}

	public void setRoomModel(RoomBean roomModel) {
		this.roomModel = roomModel;
	}

	public void setStateFlag(int stateFlag) {
		this.stateFlag = stateFlag;
	}

	public void setExtent(String extent) {
		this.extent = extent;
	}
}
