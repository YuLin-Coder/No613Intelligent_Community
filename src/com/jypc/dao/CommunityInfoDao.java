package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.CommunityInfoBean;
import com.jypc.bean.PagerView;

/**
 * 社区类
 * 
 */
@Component(value = "communityInfoDao")
public class CommunityInfoDao {
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
		return this.hibernateTemplate.find("from CommunityInfoBean").size();
	}

	/**
	 * 获取社区信息列表（分页）
	 * 
	 * @param pager
	 * @return 社区信息
	 */
	@SuppressWarnings("unchecked")
	public List<CommunityInfoBean> getCommunityInfoList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<CommunityInfoBean> list = session
						.createQuery("from CommunityInfoBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数

				return list;
			}
		});
	}

	/**
	 * 获取社区信息列表
	 * 
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<CommunityInfoBean> getCommunityInfoList() {
		return this.hibernateTemplate.find("from CommunityInfoBean");
	}

	/**
	 * 判断要添加的社区编号是否重复
	 * 
	 * @param communityId
	 *            待判断的费用编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String communityId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from CommunityInfoBean c where c.communityId=:id", "id",
				communityId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加社区费用信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int communityAdd(CommunityInfoBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除受社区信息
	 * 
	 * @param communityId
	 *            物业费用communityId
	 * @return
	 */
	public int delInfo(String communityId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					CommunityInfoBean.class, communityId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的物业费用信息
	 * 
	 * @param costId
	 *            费用编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public CommunityInfoBean getEditInfo(String communityId) {
		return (CommunityInfoBean) this.hibernateTemplate.get(
				CommunityInfoBean.class, communityId);
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int communityUpdate(CommunityInfoBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
