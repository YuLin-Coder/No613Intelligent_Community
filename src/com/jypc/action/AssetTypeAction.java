package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.AssetTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.dao.AssetTypeDao;
import com.opensymphony.xwork2.ActionSupport;

public class AssetTypeAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<AssetTypeBean> assetTypeList;// 资产信息集合
	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	AssetTypeDao assetTypeDao;
	private AssetTypeBean model;

	@Resource(name = "assetTypeDao")
	public void setassetTypeDao(AssetTypeDao assetTypeDao) {
		this.assetTypeDao = assetTypeDao;
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

		pager.setAllData(assetTypeDao.getDataNum());

		assetTypeList = assetTypeDao.getAssetTypeList(pager);
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = assetTypeDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 物业费用信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String assetAdd() {
		int result = 0;

		result = assetTypeDao.assetAdd(model);
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
		int result = assetTypeDao.delInfo(id);
		if (result > 0) {
			setTips("删除成功！");
		} else {
			setTips("删除失败！");
		}
		initData();
		return "success";
	}

	/**
	 * 根据费用编号获取要修改的物业费用信息
	 * 
	 * @throws IOException
	 */
	public void getAssetModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(assetTypeDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 删除所选中的记录
	 * 
	 * @return
	 */
	public String deleteAssetLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] assetTypeList = request.getParameterValues("delAssetType");
		int result = 0;
		for (String item : assetTypeList) {
			result += assetTypeDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @return 受影响的行数
	 */
	public String assetEdit() {
		int result = 0;
		result = assetTypeDao.assetUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<AssetTypeBean> getAssetTypeList() {
		return assetTypeList;
	}

	public void setAssetTypeList(List<AssetTypeBean> assetTypeList) {
		this.assetTypeList = assetTypeList;
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

	/**
	 * @return the model
	 */
	public AssetTypeBean getModel() {
		return model;
	}

	/**
	 * @param model
	 *            the model to set
	 */
	public void setModel(AssetTypeBean model) {
		this.model = model;
	}

}
