package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.PagerView;
import com.jypc.bean.ParkTypeBean;
import com.jypc.bean.ParkkingBean;
import com.jypc.bean.ParkkingMoneyBean;
import com.jypc.dao.ParkkingMoneyDao;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 车位费用缴费类
 * 
 * @author 郭波
 * 
 */
public class ParkkingMoneyAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<ParkkingMoneyBean> parkkingMoneyList;// 车位缴费信息
	private List<ParkkingBean> parkkingList;// 车位信息
	private List<ParkTypeBean> parkTypeList;// 车位类型信息
	private ParkkingMoneyBean model;
	private String id;
	private String carNum;// 车牌号
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	ParkkingMoneyDao parkkingMoneyDao;

	@Resource(name = "parkkingMoneyDao")
	public void setParkkingMoneyDao(ParkkingMoneyDao parkkingMoneyDao) {
		this.parkkingMoneyDao = parkkingMoneyDao;
	}

	@Override
	public String execute() throws Exception {
		initData();
		return "success";
	}

	/**
	 * 初始化车位缴费信息数据
	 */
	public void initData() {
		pager.setAllData(parkkingMoneyDao.getDataNum());
		parkkingMoneyList = parkkingMoneyDao.getParkkingMoneyList(pager);
		parkTypeList = parkkingMoneyDao.getParkTypeList();// 获取车位类型信息
	}

	/**
	 * 获取车位缴费页面的初始数据
	 * 
	 * @return
	 */
	public String parkTypeInit() {
		initData();
		parkTypeList = parkkingMoneyDao.getParkTypeList();// 获取车位类型信息
		return "parkkingMoneyAdd";
	}

	/**
	 * 根据车牌号判断该车是否存在
	 * 
	 * @throws IOException
	 */
	public void existsIdCard() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = parkkingMoneyDao.existsCarInfo(carNum) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 判断添加车位缴费信息时的车位缴费编号是否重复
	 * 
	 * @throws IOException
	 */
	public void existsParkkingMoneyId() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = parkkingMoneyDao.existsParkkingMoneyId(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 添加车费缴费信息
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String parkkingMoneyAdd() {
		int result = 0;
		// SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//
		// 设置日期格式
		model.setParkkingMoneyDate(new Date());// new Date()为获取当前系统时间
		result = parkkingMoneyDao.parkkingMoneyAdd(model);
		if (result > 0) {
			tips = "添加成功！";
		} else {
			tips = "添加失败！";
		}
		initData();
		return "parkkingMoneyAdd";
	}

	/**
	 * 删除单条信息
	 * 
	 * @return true:删除成功;false:删除失败
	 */
	public String delInfo() {
		int result = parkkingMoneyDao.delInfo(id);
		if (result > 0) {
			setTips("删除成功！");
		} else {
			setTips("删除失败！");
		}
		initData();
		return "success";
	}

	/**
	 * 删除所选中的信息
	 * 
	 * @return
	 */
	public String delParkkingMoneyLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] paymentList = request
				.getParameterValues("delParkkingMoneyList");
		int result = 0;
		for (String item : paymentList) {
			result += parkkingMoneyDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据车牌号码获取汽车信息
	 * 
	 * @throws IOException
	 */
	public void getCarInfo() throws IOException {
		parkkingList = parkkingMoneyDao.getCarInfo(carNum);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONArray.fromObject(parkkingList));
		out.flush();
		out.close();
	}

	/**
	 * 根据缴费编号获取要修改的物业缴费信息
	 * 
	 * @throws IOException
	 */
	public void getParkkingMoneyInfo() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(parkkingMoneyDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业缴费信息
	 * 
	 * @return 受影响的行数
	 */
	public String parkkingMoneyEdit() {
		int result = 0;
		result = parkkingMoneyDao.parkkingMoneyUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<ParkkingMoneyBean> getParkkingMoneyList() {
		return parkkingMoneyList;
	}

	public void setParkkingMoneyList(List<ParkkingMoneyBean> parkkingMoneyList) {
		this.parkkingMoneyList = parkkingMoneyList;
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

	public String getCarNum() {
		return carNum;
	}

	public void setCarNum(String carNum) {
		this.carNum = carNum;
	}

	public List<ParkkingBean> getParkkingList() {
		return parkkingList;
	}

	public void setParkkingList(List<ParkkingBean> parkkingList) {
		this.parkkingList = parkkingList;
	}

	public List<ParkTypeBean> getParkTypeList() {
		return parkTypeList;
	}

	public void setParkTypeList(List<ParkTypeBean> parkTypeList) {
		this.parkTypeList = parkTypeList;
	}

	public ParkkingMoneyBean getModel() {
		return model;
	}

	public void setModel(ParkkingMoneyBean model) {
		this.model = model;
	}
}
