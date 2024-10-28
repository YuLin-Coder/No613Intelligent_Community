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
import com.jypc.bean.VillageInfoBean;
import com.jypc.dao.BuildingDao;
import com.jypc.dao.VillageinfoDao;
import com.opensymphony.xwork2.ActionSupport;

public class BuildingAction extends ActionSupport {

	private List<BuildingBean> buildingList;// 楼房信息集合
	private List<VillageInfoBean> villageInfoList;
	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	BuildingBean model = new BuildingBean();
	
	VillageinfoDao villageinfoDao;
	
	@Resource(name = "villageinfoDao")
	public void setVillageinfoDao(VillageinfoDao villageinfoDao) {
		this.villageinfoDao = villageinfoDao;
	}

	BuildingDao buildingDao;

	@Resource(name = "buildingDao")
	public void setBuildingDao(BuildingDao buildingDao) {
		this.buildingDao = buildingDao;
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

		pager.setAllData(buildingDao.getDataNum());

		buildingList = buildingDao.getBuildingList(pager);
		villageInfoList = villageinfoDao.getVillageInfoList();
		
	}

	/**
	 * 判断id是否存在
	 * 
	 * @throws IOException
	 */
	public void existed() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = buildingDao.existed(id) ? 1 : 0;
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

		int i = buildingDao.add(model);
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
		int result = buildingDao.delInfo(id);
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
	public String deleteBuildingLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] bulidingList = request.getParameterValues("delBuilding");
		int result = 0;
		for (String item : bulidingList) {
			result += buildingDao.delInfo(item);
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
	public void getBuildingModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(buildingDao.getEditInfo(id)));
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
		result = buildingDao.update(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<BuildingBean> getBuildingList() {
		return buildingList;
	}

	public void setBuildingList(List<BuildingBean> buildingList) {
		this.buildingList = buildingList;
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

	public BuildingBean getModel() {
		return model;
	}

	public void setModel(BuildingBean model) {
		this.model = model;
	}

	public List<VillageInfoBean> getVillageInfoList() {
		return villageInfoList;
	}

	public void setVillageInfoList(List<VillageInfoBean> villageInfoList) {
		this.villageInfoList = villageInfoList;
	}

}
