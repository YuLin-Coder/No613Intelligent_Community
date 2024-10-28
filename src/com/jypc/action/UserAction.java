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
import com.jypc.bean.RoleBean;
import com.jypc.bean.UserBean;
import com.jypc.dao.UserDao;
import com.jypc.tools.EncryptHelper;
import com.opensymphony.xwork2.ActionSupport;

public class UserAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<UserBean> userList;// 用户信息集合
	private List<RoleBean> roleList;
	private UserBean model;
	private String id;
	private String tips;
	private PagerView pager = new PagerView();
	UserDao userDao;

	@Resource(name = "userDao")
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
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

		pager.setAllData(userDao.getDataNum());

		userList = userDao.getUserList(pager);
		roleList = userDao.getRoleList();
	}

	/**
	 * 判断主键是否重复
	 * 
	 * @throws IOException
	 */
	public void exists() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		PrintWriter out = response.getWriter();

		int result = userDao.exists(id) ? 1 : 0;
		out.print(result);
		out.flush();// 刷新
		out.close();// 关闭
	}

	/**
	 * 物业费用信息添加
	 * 
	 * @return 0[失败] >0[成功]
	 */
	public String userAdd() {
		int result = 0;
		model.setUserPwd(EncryptHelper.md5(model.getUserPwd()));
		result = userDao.userAdd(model);
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
		int result = userDao.delInfo(id);
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
	public String deleteUserLists() {
		HttpServletRequest request = ServletActionContext.getRequest();
		// 获取所选中的，名字叫delCost的复选框按钮的值
		String[] userList = request.getParameterValues("delUser");
		int result = 0;
		for (String item : userList) {
			result += userDao.delInfo(item);
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
	public void getUserModel() throws IOException {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();// 获取out
		out.print(JSONObject.fromObject(userDao.getEditInfo(id)));
		out.flush();
		out.close();
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @return 受影响的行数
	 */
	public String userEdit() {
		int result = 0;

		model.setUserPwd(EncryptHelper.md5(model.getUserPwd()));
		result = userDao.userUpdate(model);
		if (result > 0) {
			tips = "修改成功！";
		} else {
			tips = "修改失败！";
		}
		initData();
		return "success";
	}

	public List<UserBean> getUserList() {
		return userList;
	}

	public void setCostList(List<UserBean> userList) {
		this.userList = userList;
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
	 * @return the roleList
	 */
	public List<RoleBean> getRoleList() {
		return roleList;
	}

	/**
	 * @param roleList
	 *            the roleList to set
	 */
	public void setRoleList(List<RoleBean> roleList) {
		this.roleList = roleList;
	}

	/**
	 * @return the model
	 */
	public UserBean getModel() {
		return model;
	}

	/**
	 * @param model
	 *            the model to set
	 */
	public void setModel(UserBean model) {
		this.model = model;
	}

	/**
	 * @param userList
	 *            the userList to set
	 */
	public void setUserList(List<UserBean> userList) {
		this.userList = userList;
	}

}
