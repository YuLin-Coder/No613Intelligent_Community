package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.EquTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.RepairBean;
import com.jypc.bean.TenementBean;
import com.jypc.dao.ReportDao;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 报修
 * 
 * @author 张灿
 * 
 */

public class ReportAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<RepairBean> repairList;// 报修信息集合
	private List<TenementBean> tenementList;// 住户信息
	private List<EquTypeBean> equTypeList;// 类型信息

	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	ReportDao reportDao;
	private RepairBean model = new RepairBean();

	@Resource(name = "reportDao")
	public void setReportDao(ReportDao reportDao) {
		this.reportDao = reportDao;
	}

	public String execute() throws Exception {
		initData();
		return "success";
	}

	/**
	 * 初始化数据
	 */
	public void initData() {
		pager.setAllData(reportDao.getDataNum());

		repairList = reportDao.getRepairList(pager);
		tenementList = reportDao.getCostTypeList();
		equTypeList = reportDao.getEquTypeList();
	}

	/**
	 * 删除单条信息
	 * 
	 * @return true:删除成功;false:删除失败
	 */
	public String delInfo() {
		int result = reportDao.delInfo(id);
		if (result > 0) {
			setTips("删除成功！");
		} else {
			setTips("删除失败！");
		}
		initData();
		return "success";
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = reportDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 报修信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String costAdd() {
		int result = 0;
		result = reportDao.costAdd(model);
		if (result > 0) {
			tips = "添加成功！";
		} else {
			tips = "添加失败！";
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
		String[] repairList = request.getParameterValues("delCost");
		int result = 0;
		for (String item : repairList) {
			result += reportDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据报修编号获取要修改的报修信息
	 * 
	 * @throws IOException
	 */
	public void getReportModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(reportDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改报修信息
	 * 
	 * @return 受影响的行数
	 */
	public String costEdit() {
		int result = 0;
		result = reportDao.costUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<RepairBean> getRepairList() {
		return repairList;
	}

	public void setRepairList(List<RepairBean> repairList) {
		this.repairList = repairList;
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

	public RepairBean getModel() {
		return model;
	}

	public void setModel(RepairBean model) {
		this.model = model;
	}
	public List<TenementBean> getTenementList() {
		return tenementList;
	}

	public void setTenementList(List<TenementBean> tenementList) {
		this.tenementList = tenementList;
	}
	public List<EquTypeBean> getEquTypeList() {
		return equTypeList;
	}

	public void setEquTypeList(List<EquTypeBean> equTypeList) {
		this.equTypeList = equTypeList;
	}
	
}
