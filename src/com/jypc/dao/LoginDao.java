package com.jypc.dao;

import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.UserBean;
import com.jypc.tools.DbHelper;
import com.jypc.tools.EncryptHelper;




@Component("loginDao")
public class LoginDao {
	HibernateTemplate hibernateTemplate;

	@Resource(name="hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
	/**
	 * 用户登录
	 * 
	 * @param account
	 *            登录账号
	 * @param userPwd
	 *            登录密码
	 * @return 是否登陆成功，true ：登陆成功 false ：失败
	 */
	public boolean userLogin(String account, String userPwd) {
		DbHelper db = new DbHelper();
		String sql = "select count(*) from tb_user where Account=? and userPwd=?";
		int result = db.getIntScalar(sql, account, userPwd);
		return result > 0 ? true : false;

	}
	/**
	 * 根据用户名获取用户实体
	 * 
	 * @param account
	 * @return
	 */
	public UserBean GetModel(String account) {
		@SuppressWarnings("unchecked")
		List<UserBean> list = this.hibernateTemplate.find(
				"from UserBean u where u.acount=?", account);
		if (list.size() > 0) {
			return list.get(0);
		} else {
			return null;
		}
	}
	
	/**获取用户密码
	 * 
	 * @param 
	 * @return
	 */
	public UserBean getUserPwd(String userId) {
		return (UserBean) this.hibernateTemplate.get(UserBean.class,
				userId);
	}

	/**
	 * 重置密码
	 * 
	 * @param model
	 * @return 加密后的密码
	 */
	public int reSet(final String userId) {
	
		return (Integer) hibernateTemplate.execute(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				return session
						.createQuery(
								"update UserBean u set u.userPwd=:userName where u.userId=:id")
						.setParameter("id", userId)
						.setParameter("userName", "123456").executeUpdate();

			}
		});
	}
	/**
	 * 重置密码
	 * 
	 * @param model
	 * @return 加密后的密码
	 */
	public int reSet(final String userId,final String userPwd) {
	
		return (Integer) hibernateTemplate.execute(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				return session
						.createQuery(
								"update UserBean u set u.userPwd=:userName where u.userId=:id")
						.setParameter("id", userId)
						.setParameter("userName", EncryptHelper.md5(userPwd)).executeUpdate();

			}
		});
	}

	

	/**
	 * 更新用户信息
	 * @param model
	 */
	public void update(UserBean model) {
		this.hibernateTemplate.update(model);
	}


	public UserBean getUserLoginInfo(String account) {
		return (UserBean) this.hibernateTemplate.get(UserBean.class, account);
	}


}
