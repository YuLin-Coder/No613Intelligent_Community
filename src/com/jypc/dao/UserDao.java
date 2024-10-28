package com.jypc.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.PagerView;
import com.jypc.bean.RoleBean;
import com.jypc.bean.UserBean;
import com.jypc.tools.DbHelper;

/**
 * 用户类
 * 
 */
@Component(value = "userDao")
public class UserDao {
	HibernateTemplate hibernateTemplate;

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 统计记录总数
	 * 
	 * @return 记录条数
	 */
	public int getDataNum() {
		return this.hibernateTemplate.find("from UserBean").size();
	}

	/**
	 * 获取用户信息列表（分页）
	 * 
	 * @param pager
	 * @return 用户信息
	 */
	@SuppressWarnings("unchecked")
	public List<UserBean> getUserList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<UserBean> list = session
						.createQuery("from UserBean c join fetch c.roleModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取用户信息列表
	 * 
	 * @return 用户信息
	 */
	@SuppressWarnings("unchecked")
	public List<UserBean> getUserList() {
		return this.hibernateTemplate.find("from UserBean");
	}

	/**
	 * 获取角色信息
	 * 
	 * @return 角色信息
	 */
	@SuppressWarnings("unchecked")
	public List<RoleBean> getRoleList() {
		return this.hibernateTemplate.find("from RoleBean");
	}

	/**
	 * 判断要添加的用户编号是否重复
	 * 
	 * @param userId
	 *            待判断的用户编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String userId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from UserBean c where c.userId=:id", "id", userId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加用户信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int userAdd(UserBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除单条用户信息
	 * 
	 * @param userId
	 *            用户userId
	 * @return
	 */
	public int delInfo(String userId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					UserBean.class, userId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的用户信息
	 * 
	 * @param userId
	 *            费用编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public UserBean getEditInfo(String userId) {
		return (UserBean) this.hibernateTemplate.get(UserBean.class, userId);
	}

	/**
	 * 修改userId信息
	 * 
	 * @param model携带修改过后的userId信息
	 * @return 0[失败] >0[成功]
	 */
	public int userUpdate(UserBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}

	}

	public UserBean getUserLoginInfo(String account) {

		UserBean model = null;
		DbHelper db = new DbHelper();
		String sql = "select user.*,role.roleName from user inner join role on user.roleId = role.roleId where account=?";
		ResultSet rs = db.executeQuery(sql, account);
		try {
			if (rs.next()) {
				model = new UserBean();
				model.setUserId(rs.getString("userId"));
				model.setAccount(rs.getString("account"));
				model.setUserName(rs.getString("userName"));
				model.setUserPwd(rs.getString("userPwd"));
				model.setIdentityCard(rs.getString("identityCard"));
				model.setQuestion(rs.getString("question"));
				model.setAnswer(rs.getString("answer"));
				model.setEmail(rs.getString("email"));
				RoleBean roleModel = new RoleBean();
				roleModel.setRoleId(rs.getString("roleId"));
				roleModel.setRoleName(rs.getString("roleName"));
				model.setRoleModel(roleModel);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return model;
	}

	/**
	 * 获取学生密码
	 * 
	 * @param
	 * @return
	 */
	/*
	 * public UserBean getUserPwd(String userId) { return (UserBean)
	 * this.hibernateTemplate.get(UserBean.class, userId); }
	 *//**
	 * 重置密码
	 * 
	 * @param model
	 * @return 加密后的密码
	 */
	/*
	 * public int reSet(final String userId) {
	 * 
	 * return (Integer) hibernateTemplate.execute(new HibernateCallback() {
	 * public Object doInHibernate(Session session) throws HibernateException {
	 * return session .createQuery(
	 * "update UserBean sdt set sdt.userPwd=:userName where sdt.userId=:id")
	 * .setParameter("id", userId) .setParameter("userName",
	 * "123456").executeUpdate();
	 * 
	 * } }); }
	 *//**
	 * 重置密码
	 * 
	 * @param model
	 * @return 加密后的密码
	 */
	/*
	 * public int reSet(final String userId,final String userPwd) {
	 * 
	 * return (Integer) hibernateTemplate.execute(new HibernateCallback() {
	 * public Object doInHibernate(Session session) throws HibernateException {
	 * return session .createQuery(
	 * "update UserBean sdt set sdt.userPwd=:userName where sdt.userId=:id")
	 * .setParameter("id", userId) .setParameter("userName",
	 * EncryptHelper.md5(userPwd)).executeUpdate();
	 * 
	 * } }); }
	 */
}
