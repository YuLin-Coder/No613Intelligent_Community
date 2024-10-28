package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.BuildingBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.RoomBean;
import com.jypc.dao.BuildingDao;
import com.jypc.dao.RoomDao;
import com.opensymphony.xwork2.ActionSupport;

public class RoomAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<RoomBean> roomList;// 物业费用信息集合
	private List<BuildingBean> buildingList;
	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	private RoomBean model = new RoomBean();

	BuildingDao buildingDao;

	@Resource(name = "buildingDao")
	public void setBuildingDao(BuildingDao buildingDao) {
		this.buildingDao = buildingDao;
	}

	RoomDao roomDao;

	@Resource(name = "roomDao")
	public void setRoomDao(RoomDao roomDao) {
		this.roomDao = roomDao;
	}

	@Override
	public String execute() throws Exception {
		// TODO Auto-generated method stub
		initData();
		return "success";
	}

	/**
	 * 初始化数据
	 */
	public void initData() {

		pager.setAllData(roomDao.getDataNum());

		roomList = roomDao.getRoomList(pager);

		buildingList = buildingDao.getBuildingList();
	}

	/**
	 * 判断id是否存在
	 * 
	 * @throws IOException
	 */
	public void existed() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = roomDao.existed(id) ? 1 : 0;
		out.print(result);
		out.flush();
		out.close();
	}

	/**
	 * 添加信息
	 * 
	 * @return
	 */
	public String add() {

		int i = roomDao.add(model);
		if (i > 0) {
			tips = "添加成功";
		} else {
			tips = "添加失败";
		}
		initData();
		return "success";
	}

	/**
	 * 删除单条信息
	 * 
	 * @return true:删除成功;false:删除失败
	 */
	public String delInfo() {
		int result = roomDao.delInfo(id);
		if (result > 0) {
			setTips("删除成功！");
		} else {
			setTips("删除失败！");
		}
		initData();
		return "success";
	}

	/**
	 * 删除所选中的记录
	 * 
	 * @return
	 */
	public String deleteRoomLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] roomList = request.getParameterValues("delRoom");
		int result = 0;
		for (String item : roomList) {
			result += roomDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据编号获取要修改的信息
	 * 
	 * @throws IOException
	 */
	public void getRoomModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(roomDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改信息
	 * 
	 * @return 受影响的行数
	 */
	public String edit() {
		int result = 0;
		result = roomDao.update(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<RoomBean> getRoomList() {
		return roomList;
	}

	public void setRoomList(List<RoomBean> roomList) {
		this.roomList = roomList;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTips() {
		return tips;
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

	public RoomBean getModel() {
		return model;
	}

	public void setModel(RoomBean model) {
		this.model = model;
	}

	public List<BuildingBean> getBuildingList() {
		return buildingList;
	}

	public void setBuildingList(List<BuildingBean> buildingList) {
		this.buildingList = buildingList;
	}

}
