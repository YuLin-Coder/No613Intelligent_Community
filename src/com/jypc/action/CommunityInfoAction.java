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
import com.jypc.dao.CommunityInfoDao;
import com.opensymphony.xwork2.ActionSupport;

public class CommunityInfoAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<CommunityInfoBean> communityInfoList;// 社区信息
	private CommunityInfoBean model;// 社区对象
	private String id;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	CommunityInfoDao communityInfoDao;

	@Resource(name = "communityInfoDao")
	public void setCommunityInfoDao(CommunityInfoDao communityInfoDao) {
		this.communityInfoDao = communityInfoDao;
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
		pager.setAllData(communityInfoDao.getDataNum());
		communityInfoList = communityInfoDao.getCommunityInfoList(pager);
		//costTypeList = communityInfoDao.getCostTypeList();
	}
	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = communityInfoDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}
	/**
	 * 社区信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String communityAdd() {
		int result = 0;
		result = communityInfoDao.communityAdd(model);
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
		int result = communityInfoDao.delInfo(id);
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
	public String deleteCommunityInfoLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] communityInfoList = request.getParameterValues("delCommunity");
		int result = 0;
		for (String item : communityInfoList) {
			result += communityInfoDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}
	/**
	 * 根据费用编号获取要修改的社区信息
	 * 
	 * @throws IOException
	 */
	public void getCommunityModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(communityInfoDao.getEditInfo(id)));
		out.flush();
		out.close();
	}
	/**
	 * 修改社区信息
	 * 
	 * @return 受影响的行数
	 */
	public String communityEdit() {
		int result = 0;
		result = communityInfoDao.communityUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}
	

	public List<CommunityInfoBean> getCommunityInfoList() {
		return communityInfoList;
	}

	public void setCommunityInfoList(List<CommunityInfoBean> communityInfoList) {
		this.communityInfoList = communityInfoList;
	}

	public CommunityInfoBean getModel() {
		return model;
	}

	public void setModel(CommunityInfoBean model) {
		this.model = model;
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

	public CommunityInfoDao getCommunityInfoDao() {
		return communityInfoDao;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
