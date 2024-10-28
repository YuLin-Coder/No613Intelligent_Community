package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.EquTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.RepairBean;
import com.jypc.bean.TenementBean;

/**
 * 报修
 * 
 */
@Component(value = "reportDao")
public class ReportDao {
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
		return this.hibernateTemplate.find("from RepairBean").size();
	}

	/**
	 * 获取报修信息列表（分页）
	 * 
	 * @param pager
	 * @return 报修信息
	 */
	@SuppressWarnings("unchecked")
	public List<RepairBean> getRepairList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<RepairBean> list = session.createQuery("from RepairBean")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取报修信息列表
	 * 
	 * @return 报修信息
	 */
	@SuppressWarnings("unchecked")
	public List<RepairBean> getRepairList() {
		return this.hibernateTemplate.find("from RepairBean");
	}

	// 获取住户信息
	@SuppressWarnings("unchecked")
	public List<TenementBean> getCostTypeList() {
		return this.hibernateTemplate.find("from TenementBean");
	}

	// 获取类型信息
	@SuppressWarnings("unchecked")
	public List<EquTypeBean> getEquTypeList() {
		return this.hibernateTemplate.find("from EquTypeBean");
	}

	/**
	 * 删除单条报修信息
	 * 
	 * @param rid
	 *            报修rid
	 * @return
	 */
	public int delInfo(String repairId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					RepairBean.class, repairId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 判断要添加的编号是否重复
	 * 
	 * @param rid
	 *            待判断的编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String repairId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from RepairBean c where c.repairId=:id", "id", repairId)
				.size();
		return result > 0 ? true : false;
	}

	// 添加
	/*
	 * public int costAdd(RepairBean model) { return
	 * Integer.parseInt(this.hibernateTemplate.save(model).toString()); }
	 */
	public int costAdd(RepairBean repairBean) {
		try {
			this.hibernateTemplate.save(repairBean);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 获取要修改的信息
	public RepairBean getEditInfo(String repairId) {
		return (RepairBean) this.hibernateTemplate.get(RepairBean.class,
				repairId);
	}

	// 修改
	public int costUpdate(RepairBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

}
