package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.CardBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.RoomBean;
import com.jypc.dao.CardDao;
import com.jypc.dao.RoomDao;
import com.jypc.tools.DbPrimaryKeyHelper;
import com.opensymphony.xwork2.ActionSupport;

public class CardAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String cardId;// 车位编号
	private CardBean cardBean;// 车位对象
	private List<RoomBean> roomList;// 房间列表
	private List<CardBean> cardList;
	private PagerView pager = new PagerView();
	private String tips;

	CardDao cardDao;

	@Resource(name = "cardDao")
	public void setCardDao(CardDao cardDao) {
		this.cardDao = cardDao;
	}

	RoomDao roomDao;

	@Resource(name = "roomDao")
	public void setRoomDao(RoomDao roomDao) {
		this.roomDao = roomDao;
	}

	@Override
	public String execute() throws Exception {
		initdata();
		return SUCCESS;
	}

	/**
	 * 记载数据
	 */
	public void initdata() {
		pager.setAllData(cardDao.getRecordCounter());
		setCardList(cardDao.getPagerCardList(pager));
		roomList = roomDao.getAllRoomList();
	}

	/**
	 * 删除所选数据
	 */
	public String delInfo() {
		System.out.println("3333");
		int result = 0;
		result = cardDao.delSelected(cardId);
		if (result > 0) {
			tips = "删除成功";
		} else {
			tips = "删除失败";
		}
		initdata();
		return SUCCESS;

	}

	/**
	 * 加载住房信息
	 * 
	 * @return
	 */
	public String initroomInfro() {
		roomList = roomDao.getAllRoomList();
		return "add";
	}

	/**
	 * 添加信息
	 * 
	 * @return
	 */

	public String cardAdd() {
		int result = 0;
		String id = DbPrimaryKeyHelper.getKey();
		System.out.println(id);
		cardBean.setCardId(id);
		result = cardDao.add(cardBean);
		if (result > 0) {
			initdata();
			tips = "添加成功！";
			return SUCCESS;
		} else {
			tips = "添加失败！";
			return "add";
		}
	}

	/**
	 * 获取编辑对象
	 * 
	 * @throws IOException
	 */
	public void getEditeCard() throws IOException {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String cId = request.getParameter("cardId");
		System.out.println(cId);
		CardBean model = cardDao.getCardBean(cId);
		out.print(JSONObject.fromObject(model));
		out.flush();
		out.close();
	}

	/**
	 * 编辑
	 * 
	 * @return
	 */
	public String update() {
		int result = cardDao.Update(cardBean);
		if (result > 0) {
			tips = "编辑成功！";
		} else {
			tips = "编辑失败！";
		}

		initdata();
		return SUCCESS;
	}

	/**
	 * 启用
	 */
	public String startCard() {
		int result = 0;
		CardBean cardModel = cardDao.getCardBean(cardId);
		cardModel.setStateFlag(1);
		result = cardDao.Update(cardModel);
		if (result > 0) {
			tips = "成功启用";
		} else {
			tips = "启用失败";
		}
		initdata();
		return SUCCESS;
	}

	/**
	 * 停用
	 */
	public String stopCard() {
		int result = 0;
		CardBean cardModel = cardDao.getCardBean(cardId);
		cardModel.setStateFlag(0);
		result = cardDao.Update(cardModel);
		if (result > 0) {
			tips = "成功停用";
		} else {
			tips = "停用失败";
		}
		initdata();
		return SUCCESS;
	}

	/**
	 * 批量删除
	 * 
	 * @return
	 */
	public String deletemany() {
		int result = 0;
		HttpServletRequest request = ServletActionContext.getRequest();
		String[] list = request.getParameterValues("delCard");// 获取所选中的，名字叫delCost的复选框按钮的值
		try {
			for (String items : list) {
				result += cardDao.delSelected(items);
			}
			this.setTips("您成功删除了" + result + "记录");
			initdata();
			return SUCCESS;
		} catch (Exception e) {
			this.setTips("删除失败！");
			initdata();
			return SUCCESS;
		}
	}

	public String getCardId() {
		return cardId;
	}

	public CardBean getCardBean() {
		return cardBean;
	}

	public List<RoomBean> getRoomList() {
		return roomList;
	}

	public List<CardBean> getCardList() {
		return cardList;
	}

	public String getTips() {
		return tips;
	}

	public void setCardId(String cardId) {
		this.cardId = cardId;
	}

	public void setCardBean(CardBean cardBean) {
		this.cardBean = cardBean;
	}

	public void setRoomList(List<RoomBean> roomList) {
		this.roomList = roomList;
	}

	public void setCardList(List<CardBean> cardList) {
		this.cardList = cardList;
	}

	public void setTips(String tips) {
		this.tips = tips;
	}

	public PagerView getPager() {
		return pager;
	}

	public void setPager(PagerView pager) {
		this.pager = pager;
	}
}
