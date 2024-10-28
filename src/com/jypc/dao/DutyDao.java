package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.DutyBean;
import com.jypc.bean.PagerView;

@Component(value = "dutyDao")
public class DutyDao {
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
		return this.hibernateTemplate.find("from DutyBean ").size();
	}

	/**
	 * 获取楼房信息列表（分页）
	 * 
	 * @param pager
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<DutyBean> getDutyList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<DutyBean> list = session
						.createQuery("from DutyBean d join fetch d.workerModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取信息列表
	 * 
	 * @return 信息
	 */
	@SuppressWarnings("unchecked")
	public List<DutyBean> getDutyList() {
		return this.hibernateTemplate.find("from DutyBean d join fetch d.workerModel");
	}

	/**
	 * 删除单条信息
	 * 
	 * @param dutyId
	 * @return
	 */
	public int delInfo(String dutyId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					DutyBean.class, dutyId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 添加信息
	 * 
	 * @param model
	 * @return
	 */
	public int add(DutyBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取要修改的信息
	 * 
	 * @param dutyId
	 *            编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public DutyBean getEditInfo(String dutyId) {
		return (DutyBean) this.hibernateTemplate.get(DutyBean.class, dutyId);
	}

	/**
	 * 修改信息
	 * 
	 * @param model携带修改过后的信息
	 * @return 0[失败] >0[成功]
	 */
	public int update(DutyBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 判断是否存在
	 * 
	 * @param dutyId
	 * @return
	 */
	public boolean existed(String dutyId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from DutyBean d where d.dutyId=:id", "id", dutyId).size();
		return result > 0 ? true : false;
	}

}
