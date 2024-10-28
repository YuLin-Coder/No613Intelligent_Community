package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.DeliveryFirmBean;
import com.jypc.bean.PagerView;
import com.jypc.dao.DeliveryFirmDao;
import com.opensymphony.xwork2.ActionSupport;

public class DeliveryFirmAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<DeliveryFirmBean> deliveryFirmList;// 快递公司信息
	private DeliveryFirmBean model;// 物业费用对象
	private String id;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	DeliveryFirmDao deliveryFirmDao;

	@Resource(name = "deliveryFirmDao")
	public void setDeliveryFirmDao(DeliveryFirmDao deliveryFirmDao) {
		this.deliveryFirmDao = deliveryFirmDao;
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
		pager.setAllData(deliveryFirmDao.getDataNum());
		deliveryFirmList = deliveryFirmDao.getDeliveryFirmList(pager);
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = deliveryFirmDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 添加快递公司信息
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String deliveryFirmAdd() {
		int result = 0;
		result = deliveryFirmDao.deliveryFirmAdd(model);
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
		int result = deliveryFirmDao.delInfo(id);
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
	public String delDeliveryFirms() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delDeliveryFirm的复选框按钮的值
		String[] costList = request.getParameterValues("delDeliveryFirm");
		int result = 0;
		for (String item : costList) {
			result += deliveryFirmDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
	}

	/**
	 * 根据费用编号获取要修改的快递公司信息
	 * 
	 * @throws IOException
	 */
	public void getDeliveryFirmInfo() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(deliveryFirmDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改快递公司信息
	 * 
	 * @return 受影响的行数
	 */
	public String deliveryFirmEdit() {
		int result = 0;
		result = deliveryFirmDao.deliveryFirmUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
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

	public List<DeliveryFirmBean> getDeliveryFirmList() {
		return deliveryFirmList;
	}

	public void setDeliveryFirmList(List<DeliveryFirmBean> deliveryFirmList) {
		this.deliveryFirmList = deliveryFirmList;
	}

	public DeliveryFirmBean getModel() {
		return model;
	}

	public void setModel(DeliveryFirmBean model) {
		this.model = model;
	}

}
