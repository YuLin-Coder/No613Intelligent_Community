package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.PagerView;
import com.jypc.bean.RoomBean;
import com.jypc.bean.TenementBean;

/**
 * 物业费用类
 * 
 */
@Component(value = "tenementDao")
public class TenementDao {
	HibernateTemplate hibernateTemplate;

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

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
		return this.hibernateTemplate.find("from TenementBean").size();
	}

	/**
	 * 获取居民信息列表（分页）
	 * 
	 * @param pager
	 * @return 社区信息
	 */
	@SuppressWarnings("unchecked")
	public List<TenementBean> getTenementList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<TenementBean> list = session
						.createQuery("from TenementBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数

				return list;
			}
		});
	}

	/**
	 * 获取居民信息列表
	 * 
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<TenementBean> getTenementList() {
		return this.hibernateTemplate.find("from TenementBean");
	}

	/**
	 * 获取房间编号信息
	 * 
	 * @return 费用类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<RoomBean> getRoomList() {
		return this.hibernateTemplate.find("from RoomBean");
	}

	/**
	 * 判断要添加的居民编号是否重复
	 * 
	 * @param tenementId
	 *            待判断的费用编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String tenementId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from TenementBean t where t.tenementId=:id", "id", tenementId)
				.size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加居民信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int tenementAdd(TenementBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除居民信息
	 * 
	 * @param tenementId
	 *            物业费用tenementId
	 * @return
	 */
	public int delInfo(String tenementId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					TenementBean.class, tenementId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的居民信息
	 * 
	 * @param tenementId
	 *            社区编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public TenementBean getEditInfo(String tenementId) {
		return (TenementBean) this.hibernateTemplate.get(TenementBean.class,
				tenementId);
	}

	/**
	 * 修改居民费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int tenementUpdate(TenementBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
