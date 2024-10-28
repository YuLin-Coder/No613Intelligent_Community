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
import com.jypc.bean.ServiceBean;
import com.jypc.bean.TenementBean;

@Component(value = "serviceDao")
public class ServiceDao {
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
		return this.hibernateTemplate.find("from ServiceBean").size();
	}

	/**
	 * 获取维修信息列表（分页）
	 * 
	 * @param pager
	 * @return 维修信息
	 */
	@SuppressWarnings("unchecked")
	public List<ServiceBean> getServiceList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<ServiceBean> list = session
						.createQuery("from ServiceBean")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	// 获取住户信息
	@SuppressWarnings("unchecked")
	public List<TenementBean> getCostTypeList() {
		return this.hibernateTemplate.find("from TenementBean");
	}

	/**
	 * 删除单条维修信息
	 * 
	 * @param serviceId
	 *            维修serviceId
	 * @return
	 */
	public int delInfo(String serviceId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					ServiceBean.class, serviceId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 判断要添加的编号是否重复
	 * 
	 * @param serviceId
	 *            待判断的编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String serviceId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from ServiceBean c where c.serviceId=:serviceId", "id",
				serviceId).size();
		return result > 0 ? true : false;
	}

	// 添加
	public int costAdd(ServiceBean serviceBean) {
		try {
			this.hibernateTemplate.save(serviceBean);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 获取要修改的信息
	public ServiceBean getEditInfo(String serviceId) {
		return (ServiceBean) this.hibernateTemplate.get(ServiceBean.class,serviceId);
	}

	// 修改
	public int costUpdate(ServiceBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

}
