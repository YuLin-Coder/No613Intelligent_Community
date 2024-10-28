package com.jypc.action;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.SessionAware;

import com.jypc.bean.PagerView;
import com.jypc.bean.UserBean;
import com.jypc.dao.LoginDao;
import com.jypc.dao.UserDao;
import com.jypc.tools.EncryptHelper;
import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings("serial")
public class LoginAction extends ActionSupport implements SessionAware {
	private String tips;
	private List<UserBean> userlist;
	private UserBean model;
	private Map<String, Object> session;
	private PagerView pager = new PagerView();
	private String account;
	private String userPwd;
	private String userName;
	private String identityCard;

	private UserBean userbean = new UserBean();
	UserDao userDao;

	LoginDao loginDao;

	@Resource(name = "loginDao")
	public void setLogindao(LoginDao loginDao) {
		this.loginDao = loginDao;
	}

	@Override
	public String execute() throws Exception {

		return super.execute();
	}

	// 管理员登陆验证
	public String LoginUser() {
		if (loginDao.userLogin(account, EncryptHelper.md5(userPwd))) {
			HttpServletRequest request = ServletActionContext.getRequest();
			UserBean userbean = loginDao.getUserLoginInfo(account);
			request.getSession().setAttribute("identity", userbean);
			tips = "登录成功";
			return "bbb";
		} else {
			tips = "账号或密码错误！";
			return "ccc";
		}

	}

	/**
	 * 重置密码
	 * 
	 */
	public String reSet() {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpSession session = request.getSession();
		String userPwd = request.getParameter("userPwd");
		userbean = (UserBean) session.getAttribute("identity");
		int result = 0;
		result = loginDao.reSet(userbean.getUserId(), userPwd);
		if (result > 0) {
		} else {

		}
		tips = "请使用新密码登录！";
		return "ddd";

	}

	/*
	 * public void userUpdate(){ HttpServletRequest request =
	 * ServletActionContext.getRequest(); HttpSession session =
	 * request.getSession(); UserBean model = new UserBean(); String userPwd =
	 * (String)session.getAttribute("userPwd"); model =
	 * loginDao.getUserLoginInfo(account); session.putValue("", model);
	 * model.setUserPwd(userPwd); model.setAccount(account.toString());
	 * userDao.userUpdate(model); }
	 */

	public String userUpdate() {
		HttpServletRequest request = ServletActionContext.getRequest();
		/*
		 * HttpSession session = request.getSession(); UserBean model = new
		 * UserBean(); String userPwd = (String)session.getAttribute("userPwd");
		 */
		model = loginDao.getUserLoginInfo(account);

		session.put("AdminMain", model);
		model.setUserPwd(EncryptHelper.md5(userPwd));
		model.setAccount(account.toString());
		model.setUserName(userName);
		model.setIdentityCard(identityCard);
		loginDao.update(model);
		return "ddd";
	}

	/**
	 * 登出
	 */
	public String loginOut() {
		HttpServletRequest request = ServletActionContext.getRequest();
		request.getSession().removeAttribute("identity");// 将登录信息移除
		return "ccc";
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	/**
	 * @return the pager
	 */
	public PagerView getPager() {
		return pager;
	}

	/**
	 * @param pager
	 *            the pager to set
	 */
	public void setPager(PagerView pager) {
		this.pager = pager;
	}

	/**
	 * @return the userPwd
	 */
	public String getUserPwd() {
		return userPwd;
	}

	/**
	 * @param userPwd
	 *            the userPwd to set
	 */
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	/**
	 * @return the loginbean
	 */
	/*
	 * public LoginBean getLoginbean() { return loginbean; }
	 */

	/**
	 * @param loginbean
	 *            the loginbean to set
	 */
	/*
	 * public void setLoginbean(LoginBean loginbean) { this.loginbean =
	 * loginbean; }
	 */

	/**
	 * @param userlist
	 *            the userlist to set
	 */
	public void setUserlist(List<UserBean> userlist) {
		this.userlist = userlist;
	}

	/**
	 * @return the userbean
	 */
	public UserBean getUserbean() {
		return userbean;
	}

	/**
	 * @param userbean
	 *            the userbean to set
	 */
	public void setUserbean(UserBean userbean) {
		this.userbean = userbean;
	}

	/**
	 * @return the model
	 */
	public UserBean getModel() {
		return model;
	}

	/**
	 * @return the userlist
	 */
	public List<UserBean> getUserlist() {
		return userlist;
	}

	/**
	 * @param model
	 *            the model to set
	 */
	public void setModel(UserBean model) {
		this.model = model;
	}

	/**
	 * @return the tips
	 */
	public String getTips() {
		return tips;
	}

	/**
	 * @param tips
	 *            the tips to set
	 */
	public void setTips(String tips) {
		this.tips = tips;
	}

	/**
	 * @return the session
	 */
	public Map<String, Object> getSession() {
		return session;
	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName
	 *            the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return the identityCard
	 */
	public String getIdentityCard() {
		return identityCard;
	}

	/**
	 * @param identityCard
	 *            the identityCard to set
	 */
	public void setIdentityCard(String identityCard) {
		this.identityCard = identityCard;
	}

}
