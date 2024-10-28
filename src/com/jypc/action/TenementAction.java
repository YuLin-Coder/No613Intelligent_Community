package com.jypc.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.jypc.bean.PagerView;
import com.jypc.bean.RoomBean;
import com.jypc.bean.TenementBean;
import com.jypc.dao.TenementDao;
import com.opensymphony.xwork2.ActionSupport;

public class TenementAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<TenementBean> tenementList;// 物业费用信息

	private List<RoomBean> roomList;// 费用类型信息
	private TenementBean model;// 物业费用对象
	private String id;
	private String tips;// 提示字符
	private PagerView pager = new PagerView();
	TenementDao tenementDao;

	@Resource(name = "tenementDao")
	public void setTenementDao(TenementDao tenementDao) {
		this.tenementDao = tenementDao;
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
		pager.setAllData(tenementDao.getDataNum());
		tenementList = tenementDao.getTenementList(pager);
		
		roomList = tenementDao.getRoomList();
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = tenementDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 社区费用信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String tenementAdd() {
		int result = 0;
		result = tenementDao.tenementAdd(model);
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
		int result = tenementDao.delInfo(id);
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
	public String deleteTenementLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫deltenementDao的复选框按钮的值
		String[] tenementList = request.getParameterValues("delTenement");
		int result = 0;
		for (String item : tenementList) {
			result += tenementDao.delInfo(item);
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
	public void getTenementModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(tenementDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @return 受影响的行数
	 */
	public String tenementEdit() {
		int result = 0;
		result = tenementDao.tenementUpdate(model);
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

	public List<TenementBean> getTenementList() {
		return tenementList;
	}

	public void setTenementList(List<TenementBean> tenementList) {
		this.tenementList = tenementList;
	}

	public List<RoomBean> getRoomList() {
		return roomList;
	}

	public void setRoomList(List<RoomBean> roomList) {
		this.roomList = roomList;
	}

	public TenementBean getModel() {
		return model;
	}

	public void setModel(TenementBean model) {
		this.model = model;
	}

}
