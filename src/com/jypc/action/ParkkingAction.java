package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.PagerView;
import com.jypc.bean.ParkSRTypeBean;
import com.jypc.bean.ParkTypeBean;
import com.jypc.bean.ParkkingBean;
import com.jypc.bean.RoomBean;
import com.jypc.dao.ParkSRTypeDao;
import com.jypc.dao.ParkTypeDao;
import com.jypc.dao.ParkkingDao;
import com.jypc.dao.RoomDao;
import com.opensymphony.xwork2.ActionSupport;

public class ParkkingAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String parkkingId;// 车位编号
	private RoomBean roomModel;// 房间对象
	private List<ParkkingBean> parkkingList;// 车位列表
	private List<ParkSRTypeBean> psrtlist;// 出售类型
	private List<ParkTypeBean> ptlist;// 车位类型
	private List<RoomBean> roomlist;
	private String time;// 时间
	private String timend;// 结束时间
	private String money;// 出租、出售的钱
	private String tag;// 备注
	private PagerView pager = new PagerView();
	private String tips;
	private ParkkingBean model;// 车位对象

	ParkkingDao parkkingDao;

	@Resource(name = "parkkingDao")
	public void setParkkingDao(ParkkingDao parkkingDao) {
		this.parkkingDao = parkkingDao;
	}

	RoomDao roomDao;

	@Resource(name = "roomDao")
	public void setRoomDao(RoomDao roomDao) {
		this.roomDao = roomDao;
	}

	ParkTypeDao parkTypeDao;

	@Resource(name = "parkTypeDao")
	public void setParkTypeDao(ParkTypeDao parkTypeDao) {
		this.parkTypeDao = parkTypeDao;
	}

	ParkSRTypeDao parkSRTypeDao;

	@Resource(name = "parkSRTypeDao")
	public void setParkSRTypeDao(ParkSRTypeDao parkSRTypeDao) {
		this.parkSRTypeDao = parkSRTypeDao;
	}

	@Override
	public String execute() throws Exception {
		System.out.println("123");
		initdata();
		return SUCCESS;
	}

	/**
	 * 已处理车位初始化数据
	 */
	public void initdata() {
		pager.setAllData(parkkingDao.getRecordCounter());
		parkkingList = parkkingDao.getPagerCardList(pager);
		roomlist = roomDao.getAllRoomList();
		setPtlist(parkTypeDao.getAllParkTypeList());
		setPsrtlist(parkSRTypeDao.getAllParkSRTypeList());
	}

	/**
	 * 所有的车位数据初始化
	 */
	public String getList() {
		pager.setAllData(parkkingDao.getRecordCounter());
		parkkingList = parkkingDao.getPagerList(pager);
		roomlist = roomDao.getAllRoomList();
		setPtlist(parkTypeDao.getAllParkTypeList());
		setPsrtlist(parkSRTypeDao.getAllParkSRTypeList());
		return "parkRentList";
	}

	/**
	 * 获取已处理车位编辑对象
	 * 
	 * @throws IOException
	 */

	public void getEditeParkModel() throws IOException {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("parkkingId");
		model = parkkingDao.getParkkingModel(id);
		out.print(JSONObject.fromObject(model));
		out.flush();
		out.close();
	}

	/**
	 * 编辑
	 */
	public void update() {
		int result = parkkingDao.UpdateParkkingModel(model);
		if (result > 0) {
			tips = "编辑成功！";
		} else {
			tips = "编辑失败！";
		}

	}

	/**
	 * 编辑已处理车位编辑对象
	 * 
	 * @return
	 */
	public String UpdateParkkingModel() {
		update();
		initdata();
		return SUCCESS;
	}

	/**
	 * 编辑未处理车位编辑对象
	 * 
	 * @return
	 */
	public String UpdateParkkingModels() {
		update();
		getList();
		return "parkRentList";
	}

	/**
	 * 删除
	 * 
	 * @return
	 */
	public void delete() {
		int result = 0;
		result = parkkingDao.delSelected(parkkingId);
		if (result > 0) {
			tips = "删除成功";
		} else {
			tips = "删除失败";
		}

	}

	/**
	 * 已处理的车位删除
	 * 
	 * @return
	 */
	public String delInfo() {
		delete();
		initdata();
		return SUCCESS;
	}

	/**
	 * 未处理的车位删除
	 * 
	 * @return
	 */
	public String delInfos() {
		delete();
		getList();
		return SUCCESS;
	}

	/**
	 * 添加
	 */

	public String add() {
		System.out.println(model.getParkkingId());
		System.out.println(parkkingDao.IsExstCarNum(model.getCarNum()));
		if (parkkingDao.IsExstCarNum(model.getCarNum()) == false) {
			if (parkkingDao.add(model) > 0) {
				initdata();
				tips = "添加成功！";
				return SUCCESS;
			} else {
				tips = "添加失败！";
				initdata();
				return SUCCESS;
			}

		} else {
			tips = "记录已存在！不能重复添加";
			initdata();
			return SUCCESS;
		}
	}

	/**
	 * 判断是否重复
	 * 
	 * @throws IOException
	 */
	/*
	 * public void exists() throws IOException { HttpServletResponse response =
	 * ServletActionContext.getResponse(); PrintWriter out =
	 * response.getWriter();
	 * 
	 * int result = parkkingDao.IsExstCarNum(model.getCarNum()) ? 1 : 0;
	 * out.print(result); out.flush();// 刷新 out.close();// 关闭 }
	 */

	/**
	 * 添加未处理的车位
	 */

	public String addpark() {
		System.out.println(model.getParkkingId());
		System.out.println(parkkingDao.IsExisted(model.getParkkingId()));
		if (parkkingDao.IsExisted(model.getParkkingId()) == true) {
			if (parkkingDao.add(model) > 0) {
				getList();
				tips = "添加成功！";
				return "parkRentList";
			} else {
				tips = "添加失败！车位已租售";
				return "parkRentList";
			}
		} else {
			tips = "记录已存在！不能重复添加";
			getList();
			return "parkRentList";
		}
	}

	/**
	 * 已处理批量删除
	 * 
	 * @return
	 */
	public String deletemany() {
		int result = 0;
		HttpServletRequest request = ServletActionContext.getRequest();
		String[] list = request.getParameterValues("checkId");
		try {
			for (String items : list) {
				result += parkkingDao.delSelected(items);
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

	/**
	 * 已处理批量删除
	 * 
	 * @return
	 */
	public String deletemanys() {
		int result = 0;
		HttpServletRequest request = ServletActionContext.getRequest();
		String[] list = request.getParameterValues("checkId");
		try {
			for (String items : list) {
				result += parkkingDao.delSelected(items);
			}
			this.setTips("您成功删除了" + result + "记录");
			getList();
			return "parkRentList";
		} catch (Exception e) {
			this.setTips("删除失败！");
			getList();
			return "parkRentList";
		}

	}

	public String getParkkingId() {
		return parkkingId;
	}

	public RoomBean getRoomModel() {
		return roomModel;
	}

	public List<ParkkingBean> getParkkingList() {
		return parkkingList;
	}

	public List<ParkTypeBean> getPtlist() {
		return ptlist;
	}

	public List<RoomBean> getRoomlist() {
		return roomlist;
	}

	public String getTips() {
		return tips;
	}

	public void setParkkingId(String parkkingId) {
		this.parkkingId = parkkingId;
	}

	public PagerView getPager() {
		return pager;
	}

	public void setPager(PagerView pager) {
		this.pager = pager;
	}

	public void setRoomModel(RoomBean roomModel) {
		this.roomModel = roomModel;
	}

	public String getTime() {
		return time;
	}

	public String getTimend() {
		return timend;
	}

	public String getMoney() {
		return money;
	}

	public String getTag() {
		return tag;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public void setTimend(String timend) {
		this.timend = timend;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public void setParkkingList(List<ParkkingBean> parkkingList) {
		this.parkkingList = parkkingList;
	}

	public void setPtlist(List<ParkTypeBean> ptlist) {
		this.ptlist = ptlist;
	}

	public void setPsrtlist(List<ParkSRTypeBean> psrtlist) {
		this.psrtlist = psrtlist;
	}

	public void setRoomlist(List<RoomBean> roomlist) {
		this.roomlist = roomlist;
	}

	public void setTips(String tips) {
		this.tips = tips;
	}

	public List<ParkSRTypeBean> getPsrtlist() {
		return psrtlist;
	}

	public ParkkingBean getModel() {
		return model;
	}

	public void setModel(ParkkingBean model) {
		this.model = model;
	}

}
