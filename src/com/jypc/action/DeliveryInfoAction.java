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
import com.jypc.bean.DeliveryInfoBean;
import com.jypc.bean.PagerView;
import com.jypc.dao.DeliveryInfoDao;
import com.opensymphony.xwork2.ActionSupport;

public class DeliveryInfoAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<DeliveryInfoBean> deliveryInfoList;// 快递信息
	private List<DeliveryFirmBean> deliveryFirmList;// 快递公司信息
	private DeliveryInfoBean model;// 物业费用对象
	private String id;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	DeliveryInfoDao deliveryInfoDao;

	@Resource(name = "deliveryInfoDao")
	public void setDeliveryInfoDao(DeliveryInfoDao deliveryInfoDao) {
		this.deliveryInfoDao = deliveryInfoDao;
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
		pager.setAllData(deliveryInfoDao.getDataNum());
		deliveryInfoList = deliveryInfoDao.getDeliveryInfoList(pager);
		deliveryFirmList = deliveryInfoDao.getDeliveryFirmList();
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */

	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = deliveryInfoDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新 out.close();// 关闭
	}

	/**
	 * 添加快递信息
	 * 
	 * @return 0[失败] >0[成功]
	 */

	public String deliveryInfoAdd() {
		int result = 0;
		result = deliveryInfoDao.deliveryInfoAdd(model);
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
		int result = deliveryInfoDao.delInfo(id);
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

	public String delDeliveryInfos() {
		HttpServletRequest request = ServletActionContext.getRequest(); // 获取所选中的，名字叫delCost的复选框按钮的值
		String[] deliveryInfoList = request
				.getParameterValues("delDeliveryInfos");
		int result = 0;
		for (String item : deliveryInfoList) {
			result += deliveryInfoDao.delInfo(item);
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

	public void getDeliveryInfo() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(deliveryInfoDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @return 受影响的行数
	 */

	public String deliveryInfoEdit() {
		int result = 0;
		result = deliveryInfoDao.deliveryInfoUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	/**
	 * 收取快递
	 * 
	 * @return
	 */
	public String collect() {
		int result = 0;
		model = deliveryInfoDao.getEditInfo(id);
		model.setExtent("1");
		result = deliveryInfoDao.deliveryInfoUpdate(model);
		if (result > 0) {
			tips = "收取成功！";
		} else {
			tips = "收取失败！";
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

	public List<DeliveryInfoBean> getDeliveryInfoList() {
		return deliveryInfoList;
	}

	public void setDeliveryInfoList(List<DeliveryInfoBean> deliveryInfoList) {
		this.deliveryInfoList = deliveryInfoList;
	}

	public DeliveryInfoBean getModel() {
		return model;
	}

	public void setModel(DeliveryInfoBean model) {
		this.model = model;
	}

	public List<DeliveryFirmBean> getDeliveryFirmList() {
		return deliveryFirmList;
	}

	public void setDeliveryFirmList(List<DeliveryFirmBean> deliveryFirmList) {
		this.deliveryFirmList = deliveryFirmList;
	}

}
