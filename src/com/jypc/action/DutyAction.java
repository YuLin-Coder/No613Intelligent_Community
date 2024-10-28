package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.DutyBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.WorkerBean;
import com.jypc.dao.DutyDao;
import com.jypc.dao.WorkerDao;
import com.opensymphony.xwork2.ActionSupport;

public class DutyAction extends ActionSupport {

	private List<DutyBean> dutyList;// 值班信息集合
	private List<WorkerBean> workerList;
	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	private DutyBean model;

	WorkerDao workerDao;

	@Resource(name = "workerDao")
	public void setWorkerDao(WorkerDao workerDao) {
		this.workerDao = workerDao;
	}

	DutyDao dutyDao;

	@Resource(name = "dutyDao")
	public void setDutyDao(DutyDao dutyDao) {
		this.dutyDao = dutyDao;
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

		pager.setAllData(dutyDao.getDataNum());
		dutyList = dutyDao.getDutyList(pager);
		workerList = workerDao.getWorkerList();
	}

	/**
	 * 判断id是否存在
	 * 
	 * @throws IOException
	 */
	public void existed() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = dutyDao.existed(id) ? 1 : 0;
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

		int result = 0;
		result = dutyDao.add(model);
		if (result > 0) {
			tips = "添加成功！";
		} else {
			tips = "添加失败！";
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
		int result = dutyDao.delInfo(id);
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
	public String deleteDutyLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] dutyList = request.getParameterValues("delDuty");
		int result = 0;
		for (String item : dutyList) {
			result += dutyDao.delInfo(item);
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
	public void getDutyModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(dutyDao.getEditInfo(id)));
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
		result = dutyDao.update(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<DutyBean> getDutyList() {
		return dutyList;
	}

	public void setDutyList(List<DutyBean> dutyList) {
		this.dutyList = dutyList;
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

	public DutyBean getModel() {
		return model;
	}

	public void setModel(DutyBean model) {
		this.model = model;
	}

	public List<WorkerBean> getWorkerList() {
		return workerList;
	}

	public void setWorkerList(List<WorkerBean> workerList) {
		this.workerList = workerList;
	}

}
