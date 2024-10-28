package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.CommunityInfoBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.VillageInfoBean;
import com.jypc.dao.CommunityInfoDao;
import com.jypc.dao.VillageinfoDao;
import com.opensymphony.xwork2.ActionSupport;

public class VillageInfoAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<VillageInfoBean> villageInfoList;// 小区信息集合
	private List<CommunityInfoBean> communityList;// 社区信息集合
	private String id;
	private String tips;
	private VillageInfoBean model = new VillageInfoBean();
	private PagerView pager = new PagerView();

	CommunityInfoDao communityInfoDao;

	@Resource(name = "communityInfoDao")
	public void setCommunityInfoDao(CommunityInfoDao communityInfoDao) {
		this.communityInfoDao = communityInfoDao;
	}

	VillageinfoDao villageinfoDao;

	@Resource(name = "villageinfoDao")
	public void setVillageinfoDao(VillageinfoDao villageinfoDao) {
		this.villageinfoDao = villageinfoDao;
	}

	@Override
	public String execute() throws Exception {
		initData();
		return "success";
	}

	/**
	 * 初始化数据
	 */
	public void initData() {

		pager.setAllData(villageinfoDao.getDataNum());
		villageInfoList = villageinfoDao.getVillageInfoList(pager);
		communityList = communityInfoDao.getCommunityInfoList();
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = villageinfoDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 小区信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String villageAdd() {
		int result = 0;
		result = villageinfoDao.villageAdd(model);
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
		int result = villageinfoDao.delInfo(id);
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
	public String deleteVillageLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delVillage的复选框按钮的值
		String[] villageList = request.getParameterValues("delVillage");
		int result = 0;
		for (String item : villageList) {
			result += villageinfoDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据小区编号获取要修改的小区信息
	 * 
	 * @throws IOException
	 */
	public void getVillageModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(villageinfoDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改小区信息
	 * 
	 * @return 受影响的行数
	 */
	public String villageEdit() {
		int result = 0;
		result = villageinfoDao.villageUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<VillageInfoBean> getVillageInfoList() {
		return villageInfoList;
	}

	public void setVillageInfoList(List<VillageInfoBean> villageInfoList) {
		this.villageInfoList = villageInfoList;
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

	public VillageInfoBean getModel() {
		return model;
	}

	public void setModel(VillageInfoBean model) {
		this.model = model;
	}

	public List<CommunityInfoBean> getCommunityList() {
		return communityList;
	}

	public void setCommunityList(List<CommunityInfoBean> communityList) {
		this.communityList = communityList;
	}
}
