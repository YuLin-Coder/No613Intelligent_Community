package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.PagerView;
import com.jypc.bean.PaymentBean;
import com.jypc.bean.TenementBean;
import com.jypc.dao.CompleteCostDao;
import com.opensymphony.xwork2.ActionSupport;

public class CompleteCostAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<PaymentBean> completeCostList;// 住户补款信息
	private List<TenementBean> tenementList;// 住户信息
	private PaymentBean model;// 物业缴费对象
	private String id;
	private String idCard;// 身份证号码
	private String tips;// 提示字符
	private PagerView pager = new PagerView();

	CompleteCostDao completeCostDao;

	@Resource(name = "completeCostDao")
	public void setCompleteCostDao(CompleteCostDao completeCostDao) {
		this.completeCostDao = completeCostDao;
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
		pager.setAllData(completeCostDao.getDataNum());
		completeCostList = completeCostDao.getCompleteCostList(pager);// 获取存在欠费的信息列表
	}

	/**
	 * 根据身份证获取存在欠费的信息列表
	 * 
	 * @return
	 */
	public String getCompleteCostIdcard() {
		pager.setAllData(completeCostDao.getDataNumIdcard(model
				.getTenementModel().getIdCard()));
		completeCostList = completeCostDao.getCompleteCostIdcard(pager, model
				.getTenementModel().getIdCard());
		return "success";
	}

	/**
	 * 根据身份证号判断该住户是否存在
	 * 
	 * @throws IOException
	 */
	public void existsIdCard() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = completeCostDao.existsIdCard(idCard) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 根据缴费编号获取要修改的物业缴费信息
	 * 
	 * @throws IOException
	 */
	public void getPaymentInfo() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(completeCostDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 根据身份证号码获取住户信息
	 * 
	 * @throws IOException
	 */
	public void getTenementInfo() throws IOException {
		tenementList = completeCostDao.getTenementInfo(idCard);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONArray.fromObject(tenementList));
		out.flush();
		out.close();
	}

	/**
	 * 补齐费用（单条记录补齐）
	 * 
	 * @return
	 */
	public String addCompleteCost() {
		double completeCost = 0.0;// 需要补齐的费用
		model = completeCostDao.getEditInfo(id);
		completeCost = model.getPayable() - model.getPractical();// 得到需要补齐的费用
		model.setPractical(model.getPractical() + completeCost);
		int result = completeCostDao.paymentUpdate(model);
		if (result > 0) {
			tips = "补交成功";
		} else {
			tips = "补交失败";
		}
		initData();
		return "success";
	}

	/**
	 * 补齐费用（多条记录补齐）
	 * 
	 * @return
	 */
	public String addCompleteCosts() {
		double completeCost = 0.0;// 需要补齐的费用
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] completeCostList = request
				.getParameterValues("ckbCompleteCost");
		int result = 0;
		for (String item : completeCostList) {
			model = completeCostDao.getEditInfo(item);
			completeCost = model.getPayable() - model.getPractical();// 得到需要补齐的费用
			model.setPractical(model.getPractical() + completeCost);
			result += completeCostDao.paymentUpdate(model);
		}
		this.tips = "成功补齐了" + result + "条记录";
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

	public PaymentBean getModel() {
		return model;
	}

	public void setModel(PaymentBean model) {
		this.model = model;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public List<TenementBean> getTenementList() {
		return tenementList;
	}

	public void setTenementList(List<TenementBean> tenementList) {
		this.tenementList = tenementList;
	}

	public List<PaymentBean> getCompleteCostList() {
		return completeCostList;
	}

	public void setCompleteCostList(List<PaymentBean> completeCostList) {
		this.completeCostList = completeCostList;
	}

}
