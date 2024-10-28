package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.CostBean;
import com.jypc.bean.CostTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.PaymentBean;
import com.jypc.bean.TenementBean;
import com.jypc.dao.CostDao;
import com.jypc.dao.PaymentNoFixedDao;
import com.opensymphony.xwork2.ActionSupport;

public class PaymentNoFixedAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<PaymentBean> paymentNoFixedList;// 住户非固定缴费信息
	private List<CostTypeBean> costTypeList;// 费用类型信息
	private List<CostBean> costList;// 物业费用信息
	private List<TenementBean> tenementList;// 住户信息
	private PaymentBean model;// 物业缴费对象
	private CostBean costModel;
	private String id;
	private String idCard;// 身份证号码
	private String tenementId;
	private String costId;
	private String selYears;
	private String selMonths;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();

	PaymentNoFixedDao paymentNoFixedDao;

	@Resource(name = "paymentNoFixedDao")
	public void setPayment_NoFixedDao(PaymentNoFixedDao payment_NoFixedDao) {
		this.paymentNoFixedDao = payment_NoFixedDao;
	}

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
		pager.setAllData(paymentNoFixedDao.getDataNum());
		paymentNoFixedList = paymentNoFixedDao.getPaymentList_NoFixed(pager);
		costList = paymentNoFixedDao.getCostList_NoFixed();
	}

	/**
	 * 获取非固定费用缴费页面的初始数据
	 * 
	 * @return
	 */
	public String costInit_NoFixed() {
		initData();
		costList = paymentNoFixedDao.getCostList_NoFixed();
		return "paymentAdd_NoFixed";
	}

	/**
	 * 判断添加物业缴费信息时的物业缴费编号是否重复
	 * 
	 * @throws IOException
	 */
	public void existsPayId() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();
		int result = paymentNoFixedDao.existsPayId(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 判断物业缴费信息是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = paymentNoFixedDao.exists(tenementId, costId, selYears,
				selMonths) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 根据身份证号判断该住户是否存在
	 * 
	 * @throws IOException
	 */
	public void existsIdCard() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = paymentNoFixedDao.existsIdCard(idCard) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 添加物业缴费信息
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String paymentAdd() {
		int result = 0;
		// SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//
		// 设置日期格式
		model.setPayDate(new Date());// new Date()为获取当前系统时间
		result = paymentNoFixedDao.paymentAdd(model);
		if (result > 0) {
			tips = "添加成功！";
		} else {
			tips = "添加失败！";
		}
		initData();
		return "paymentAdd_NoFixed";
	}

	/**
	 * 删除单条信息
	 * 
	 * @return true:删除成功;false:删除失败
	 */
	public String delInfo() {
		int result = paymentNoFixedDao.delInfo(id);
		if (result > 0) {
			setTips("删除成功！");
		} else {
			setTips("删除失败！");
		}
		initData();
		return "success";
	}

	/**
	 * 删除所选中的信息
	 * 
	 * @return
	 */
	public String delPaymentLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] paymentList = request.getParameterValues("delPaymentList");
		int result = 0;
		for (String item : paymentList) {
			result += paymentNoFixedDao.delInfo(item);
		}
		this.tips = "成功删除了" + result + "条记录";
		initData();
		return "success";
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
		out.print(JSONObject.fromObject(paymentNoFixedDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 根据身份证号码获取住户信息
	 * 
	 * @throws IOException
	 */
	public void getTenementInfo() throws IOException {
		tenementList = paymentNoFixedDao.getTenementInfo(idCard);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONArray.fromObject(tenementList));
		out.flush();
		out.close();
	}

	/**
	 * 根据费用信息编号获取费用信息
	 * 
	 * @throws IOException
	 */
	public void getCostInfo() throws IOException {
		costModel = costDao.getEditInfo(costId);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(costModel));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业缴费信息
	 * 
	 * @return 受影响的行数
	 */
	public String paymentEdit() {
		int result = 0;
		result = paymentNoFixedDao.paymentUpdate(model);
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

	public List<CostTypeBean> getCostTypeList() {
		return costTypeList;
	}

	public void setCostTypeList(List<CostTypeBean> costTypeList) {
		this.costTypeList = costTypeList;
	}

	public PaymentBean getModel() {
		return model;
	}

	public void setModel(PaymentBean model) {
		this.model = model;
	}

	public List<CostBean> getCostList() {
		return costList;
	}

	public void setCostList(List<CostBean> costList) {
		this.costList = costList;
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

	public CostBean getCostModel() {
		return costModel;
	}

	public void setCostModel(CostBean costModel) {
		this.costModel = costModel;
	}

	public String getCostId() {
		return costId;
	}

	public void setCostId(String costId) {
		this.costId = costId;
	}

	public String getSelYears() {
		return selYears;
	}

	public void setSelYears(String selYears) {
		this.selYears = selYears;
	}

	public String getSelMonths() {
		return selMonths;
	}

	public void setSelMonths(String selMonths) {
		this.selMonths = selMonths;
	}

	public String getTenementId() {
		return tenementId;
	}

	public void setTenementId(String tenementId) {
		this.tenementId = tenementId;
	}

	public List<PaymentBean> getPaymentNoFixedList() {
		return paymentNoFixedList;
	}

	public void setPayment_NoFixedList(List<PaymentBean> payment_NoFixedList) {
		this.paymentNoFixedList = payment_NoFixedList;
	}

}
