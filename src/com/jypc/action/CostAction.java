package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.CostBean;
import com.jypc.bean.CostTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.dao.CostDao;
import com.opensymphony.xwork2.ActionSupport;

public class CostAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<CostBean> costList;// 物业费用信息
	private List<CostTypeBean> costTypeList;// 费用类型信息
	private CostBean model;// 物业费用对象
	private String id;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	CostDao costDao;

	@Resource(name = "costDao")
	public void setCostDao(CostDao costDao) {
		this.costDao = costDao;
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
		pager.setAllData(costDao.getDataNum());
		costList = costDao.getCostList(pager);
		costTypeList = costDao.getCostTypeList();
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = costDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 物业费用信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String costAdd() {
		int result = 0;
		result = costDao.costAdd(model);
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
		int result = costDao.delInfo(id);
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
	public String deleteCostLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] costList = request.getParameterValues("delCost");
		int result = 0;
		for (String item : costList) {
			result += costDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据费用编号获取要修改的物业费用信息
	 * 
	 * @throws IOException
	 */
	public void getCostModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(costDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @return 受影响的行数
	 */
	public String costEdit() {
		int result = 0;
		result = costDao.costUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<CostBean> getCostList() {
		return costList;
	}

	public void setCostList(List<CostBean> costList) {
		this.costList = costList;
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

	public List<CostTypeBean> getCostTypeList() {
		return costTypeList;
	}

	public void setCostTypeList(List<CostTypeBean> costTypeList) {
		this.costTypeList = costTypeList;
	}

	public CostBean getModel() {
		return model;
	}

	public void setModel(CostBean model) {
		this.model = model;
	}

}
